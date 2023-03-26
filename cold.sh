#!/bin/bash
if [ -z "$1" ]; then
    echo "URL is empty"
    echo "Usage: ./cold.sh <url> <output directory> <github token>"
    exit 1
fi
if [ -z "$2" ]; then
    echo "Output directory is empty"
    echo "Usage: ./cold.sh <url> <output directory> <github token>"
    exit 1
fi
if [ -z "$3" ]; then
    echo "Github token is empty"
    echo "Usage: ./cold.sh <url> <output directory> <github token>"
    exit 1
fi

url=$1
outputDir=$2
githubToken=$3
optionalCookies=$4
mkdir -p $outputDir
binaries=("waybackurls" "gau" "katana" "hakrawler" "gospider" "anew")
paths=("$HOME/Tools/xnLinkFinder/xnLinkFinder.py" "$HOME/Tools/JSA/./automation.sh" "~/Tools/github-endpoints.py")
for binary in "${binaries[@]}"; do
    if ! command -v "$binary" &> /dev/null; then
        echo "Error: $binary not found"
        exit 1
    fi
done
for path in "${paths[@]}"; do
    if [ ! -f "$path" ]; then
        echo "Error: $path not found"
        exit 1
    fi
done
function extract_domain_name() {
    # Extract domain name up to the second level
    domain=$(echo $url | awk -F/ '{print $3}' | awk -F. '{if (NF>2) {print $(NF-1)"."$NF} else {print $0}}')
    # Return domain name
    echo $domain
}
domain=$(extract_domain_name $url)

echo $url | waybackurls | anew $outputDir/urls.txt;
echo $url | gau --threads 5 | anew $outputDir/urls.txt

if [ -n "$optionalCookies" ]; then 
    echo $url | katana -d 5 silent -H "$optionalCookies" | anew $outputDir/urls.txt
else
    echo $url | katana -d 5 silent  | anew $outputDir/urls.txt
fi

if [ -n "$optionalCookies" ]; then 
    echo $url | hakrawler -h "$optionalCookies" | anew $outputDir/urls.txt
else
    echo $url | hakrawler  | anew $outputDir/urls.txt
fi

if [ -n "$optionalCookies" ]; then 
    gospider -s $url -a -w -r -H "$optionalCookies" | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u | anew $outputDir/urls.txt
else
    gospider -s $url -a -w -r  | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u | anew $outputDir/urls.txt
fi

if [ -n "$optionalCookies" ]; then 
    python3 ~/Tools/xnLinkFinder/xnLinkFinder.py  -i $url -H "$optionalCookies" -sp $url -d 4 -sf .*$domain  -v -o $outputDir/urls.txt -op $outputDir/parameters.txt
else
    python3 ~/Tools/xnLinkFinder/xnLinkFinder.py  -i $url -sp $url -d 4 -sf .*$domain  -v -o $outputDir/urls.txt -op $outputDir/parameters.txt
fi

python3 ~/Tools/github-endpoints.py -t $githubToken -d $domain | anew $outputDir/urls.txt
cat $outputDir/urls.txt | grep -aEi "\.js([?#].*)?$" | anew $outputDir/js.txt
echo $url | $HOME/Tools/JSA/./automation.sh $outputDir $githubToken $outputDir/urls.txt 1> $outputDir/JSA.log 2>&1
cat $outputDir/urls.txt| sed '$!N; /^\(.*\)\n\1$/!P; D'| grep -P '\.php|\.asp|\.js|\.jsp|\.jsp' | anew $outputDir/endpoints.txt
cat $outputDir/urls.txt| grep -Po '(?:\?|\&)(?<key>[\w]+)(?:\=|\&?)(?<value>[\w+,.-]*)' | tr -d '?' | tr -d '&' | sed 's/=.*//' | sort -u | uniq | anew $outputDir/parameters.txt