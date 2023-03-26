# cold.sh

A Bash script that automates the process of extracting URLs from a given domain using various tools.

## Prerequisites

To use this script, you'll need to install a bunch of tools using this simple commands

```
git clone https://github.com/mux0x/cold.sh
chmod +x cold.sh/install.sh
chmod +x cold.sh/cold.sh
cold.sh/./install.sh
```

## Usage

```
Usage: ./cold.sh <url> <output directory> <github token> [optional cookies]

Arguments:
  url               the domain you want to target
  output directory the directory to save the output files in
  github token      a Github token to use with github-endpoints.py
  optional Headers  (optional) e.g. cookies to use in the requests can be "Cookie: x=123; y=456;"
```

## Example usage

```
./cold.sh https://example.com/ websDirectory YOUR_GITHUB_TOKEN "Cookie: x=123; y=456;"
```

## Output

The script will output the following files in the specified output directory:

- `urls.txt`: a list of unique URLs discovered from the target domain.
- `js.txt`: a list of unique URLs to Javascript files discovered from the target domain.
- `endpoints.txt`: a list of unique URLs to potential endpoints discovered from the target domain.
- `parameters.txt`: a list of unique parameters discovered in the URLs from the target domain.
