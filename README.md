```bash
 ▄▄·       ▄▄▌  ·▄▄▄▄  
▐█ ▌▪▪     ██•  ██▪ ██ 
██ ▄▄ ▄█▀▄ ██▪  ▐█· ▐█▌: Crawl >> Links || Discover >> Endopints >> Params || Scan >> JavaScript >> Secrets || Analyze >> Everything
▐███▌▐█▌.▐▌▐█▌▐▌██. ██ 
·▀▀▀  ▀█▄▀▪.▀▀▀ ▀▀▀▀▀•
```
### About:
Col(lect) D(ata): A Fancy Bash Wrapper around [**gau**](https://github.com/lc/gau), [**github-endpoints**](https://github.com/gwen001/github-search/blob/master/github-endpoints.py), [**gospider**](https://github.com/jaeles-project/gospider), [**hakrawler**](https://github.com/hakluke/hakrawler), [**JSA**](https://github.com/w9w/JSA), [**katana**](https://github.com/projectdiscovery/katana), [**subJS**](https://github.com/lc/subjs), [**waymore**](https://github.com/xnl-h4ck3r/waymore) & [**xnLinkFinder**](https://github.com/xnl-h4ck3r/xnLinkFinder) to find as much Links, Endpoints & Params as possible on a single `$URL`.

### **Installation**:
 - **Bash**: 
```bash
sudo wget https://raw.githubusercontent.com/Azathothas/BugGPT-Tools/main/cold/cold.sh -O /usr/local/bin/cold && sudo chmod +xwr /usr/local/bin/cold && cold --help
``` 
### Initialization:
```bash
cold -init
# Essentially dry runs and attempts auto install of dependencies and Initialize upon first & second run:
# cold -u https://example5.com -o /tmp/example5.com -gh ghp_xyz ; cold -u https://example5.com -o /tmp/example.com -gh ghp_xyz
```

### Usage:
`cold --help`
```bash
 ▄▄·       ▄▄▌  ·▄▄▄▄  
▐█ ▌▪▪     ██•  ██▪ ██ 
██ ▄▄ ▄█▀▄ ██▪  ▐█· ▐█▌
▐███▌▐█▌.▐▌▐█▌▐▌██. ██ 
·▀▀▀  ▀█▄▀▪.▀▀▀ ▀▀▀▀▀• 

➼ Usage: cold -u <url> -o /path/to/outputdir -gh <github_token> <other options>

Extended Help
-u,       --url              Specify the URL to scrape (Required)
-o,       --output_dir       Specify the directory to save the output files (Required)
-gh,      --github_token     Specify manually: ghp_xxx (Not Required if $HOME/.config/.github_tokens exists)
-d,       --deep             Specify if Gospider, Hakrawler, Katana & XnLinkfinder should run with depth 5.(Slow)
-h,       --headers          Specify additional headers or cookies to use in the HTTP request (optional)
-init,    --init             Initialize ➼ cold by dry-running it against example.com (Only run on a fresh Install)
-up,      --update           Update cold
-ctmp,    --clean-tmp        Cleans /tmp/ files after run
-curls,   --clean-urls       Removes noisy junk urls (godeclutter | urless)
-params,  --discover-params  Runs Arjun for parameter discovery (Basic & Slow)
-secrets, --scan-secrets     Runs gf-secrets + TruffleHog (Massive Output, Resource-Intensive & Slow)

Example Usage: 
Basic: 
cold --url https://example.com --output_dir /path/to/outputdir --github_token ghp_xyz

Extensive: 
cold --url https://example.com --output_dir /path/to/outputdir --github_token ghp_xyz --headers "Authorization: Bearer token; Cookie: cookie_value" --deep --discover-params --scan-secrets

Tips: 
➼ Include UrlScan API keys in $HOME/Tools/waymore/config.yml to find more links
➼ Include multiple github_tokens in $HOME/.config/.github_tokens to avoid rate limits
➼ --scan-secrets produces massive files (Several GBs). So TuffleHog is run by default. Best run with --deep
➼ Don't Worry if your Terminal Hangs for a bit.. It's a feature not a bug
```
