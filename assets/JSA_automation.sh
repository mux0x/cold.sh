#!/bin/bash
if [ -z "$1" ]; then
    echo "Error: no output directory specified"
    echo "Usage: Usage: echo https://www.example.com$ | $0 <output directory> <github token> <urls-file>"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Error: no output github token specified"
    echo "Usage: Usage: echo https://www.example.com$ | $0 <output directory> <github token> <urls-file>"
    exit 1
fi

if [ -z "$3" ]; then
    echo "Error: no urls in has been specified"
    echo "Usage: Usage: echo https://www.example.com$ | $0 <output directory> <github token> <urls-file>"
    exit 1
fi
if [ ! -t 0 ]; then
    echo "Error: no stdin specified"
    echo "Usage: echo https://www.example.com$ | 0 <output directory> <github token> <urls-file>"
    exit 1
fi


urlsFile=$3
mkdir -p $1
outputDir=$1
mkdir -p $1/tmp
mkdir -p $outputDir
tmpDir=$outputDir/tmp
ght=$2
stdin=$(</dev/stdin)

array=()
for i in {a..z} {A..Z} {0..9}; do
    array[$RANDOM]=$i
done
random_str=$(printf %s ${array[@]::23})

## fetching js files with subjs tool


printf 'Fetching js files with subjs tool..\n'
printf $stdin | subjs | tee $tmpDir/subjs${random_str}.txt >/dev/null


## lauching wayback with a "js only" mode to reduce execution time
printf 'Launching Gau with wayback..\n'
printf $stdin | xargs -I{} echo "{}/*&filter=mimetype:application/javascript&somevar=" | gau --providers wayback --threads 5 | tee $tmpDir/gau${random_str}.txt >/dev/null   ##gau
printf $stdin | xargs -I{} echo "{}/*&filter=mimetype:text/javascript&somevar=" | gau --providers wayback --threads 5 | tee -a $tmpDir/gau${random_str}.txt >/dev/null   ##gau


## if js file parsed from wayback didn't return 200 live, we are generating a URL to see a file's content on wayback's server;
## it's useless for endpoints discovery but there is a point to search for credentials in the old content; that's what we'll do
## only wayback as of now

printf "Fetching URLs for 404 js files from wayback..\n"
cat $tmpDir/gau${random_str}.txt | cut -d '?' -f1 | cut -d '#' -f1 | sort -u | xargs -I{} sh -c ~/Tools/JSA/automation/./404_js_wayback.sh {} |  tee -a $tmpDir/creds_search${random_str}.txt >/dev/null


## Classic crawling. It could give different results than subjs tool
printf 'Now crawling web pages..\n'
printf $stdin | hakrawler -u -subs -insecure -d 2 | grep '\.js' | tee $tmpDir/spider${random_str}.txt >/dev/null   ##just crawling web pages
cat $urlsFile | grep '\.js' | anew  | tee $tmpDir/spider${random_str}.txt >/dev/null   ##just crawling web pages


## Searching for URLs in github, - that could give some unique results, too
## python one-liner - for clear domain matching

printf 'Searching for URLs in GH..\n'
printf ${stdin} | python3 -c "import re,sys; str0=str(sys.stdin.readlines()); str1=re.search('(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]', str0);  print(str1.group(0)) if str1 is not None else exit()" | xargs -I{} python3 ~/Tools/JSA/automation/github-endpoints.py -d {} -t $ght | grep '\.js' | tee $tmpDir/gh${random_str}.txt >/dev/null
    
    
## sorting out all the results

##that's for creds_check

cat $tmpDir/subjs${random_str}.txt $tmpDir/gau${random_str}.txt $tmpDir/gh${random_str}.txt $tmpDir/spider${random_str}.txt | cut -d '?' -f1 | cut -d '#' -f1 | grep -E '\.js(?:onp?)?$' | sort -u | tee $tmpDir/all_js_files${random_str}.txt >/dev/null 

## save all endpoints to the file for future processing

## extracting js files from js files
printf "Printing deep-level js files..\n"
cat $tmpDir/all_js_files${random_str}.txt | parallel --gnu --pipe -j 15 "python3 ~/Tools/JSA/automation/js_files_extraction.py | tee -a $tmpDir/all_js_files${random_str}.txt"

printf "Searching for endpoints..\n"
cat $tmpDir/all_js_files${random_str}.txt | parallel --gnu --pipe -j 15 "python3 ~/Tools/JSA/automation/endpoints_extraction.py | tee -a $tmpDir/all_endpoints${random_str}.txt"
cat $tmpDir/all_endpoints${random_str}.txt | sort -u   | tee $tmpDir/all_endpoints_unique${random_str}.txt >/dev/null


## credentials checking

printf "Checking our js files for sweet credentials.."
cat $tmpDir/all_js_files${random_str}.txt $tmpDir/creds_search${random_str}.txt | parallel --gnu -j 15 "nuclei -t ~/Tools/JSA/templates/credentials-disclosure-all.yaml -no-color -silent -target {}" 


## parameters bruteforcing with modified Arjun

printf "Arjun parameters discovery.."
cat $tmpDir/all_endpoints_unique${random_str}.txt | parallel -j 15 "arjun -w ~/Tools/Arjun/arjun/db/large.txt -t 12 -m GET -u {} -o $1/bruted-params.json --stable" 


rm $tmpDir/subjs${random_str}.txt $tmpDir/gau${random_str}.txt $tmpDir/spider${random_str}.txt $tmpDir/gh${random_str}.txt $tmpDir/all_js_files${random_str}.txt $tmpDir/all_endpoints${random_str}.txt $tmpDir/all_endpoints_unique${random_str}.txt
rm -rf $tmpDir
