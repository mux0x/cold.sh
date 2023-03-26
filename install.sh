#!/bin/bash
mkdir ~/Tools
# Install waybackurls
go install github.com/tomnomnom/waybackurls@latest

# install anew
go install github.com/tomnomnom/anew@latest

# Install gau
go install github.com/lc/gau/v2/cmd/gau@latest

# Install katana
go install github.com/projectdiscovery/katana/cmd/katana@latest

# Install hakrawler
go install  github.com/hakluke/hakrawler@latest

# Install gospider
go install github.com/jaeles-project/gospider@latest


# Install xnLinkFinder
git clone https://github.com/xnl-h4ck3r/xnLinkFinder ~/Tools/xnLinkFinder
cd ~/Tools/xnLinkFinder
pip3 install -r requirements.txt

# Install github-endpoints.py
wget https://raw.githubusercontent.com/gwen001/github-search/master/github-endpoints.py -O ~/Tools/github-endpoints.py


currentDir=$(pwd)
# Install JSA
git clone https://github.com/w9w/JSA.git && cd JSA && pip3 install -r requirements.txt
wget https://raw.githubusercontent.com/mux0x/needs/main/JSA_automation.sh -O ~/Tools/JSA/automation.sh
chmod +x ~/Tools/JSA/automation.sh
chmod +x ~/Tools/JSA/automation/./404_js_wayback.sh
cd $currentDir

go install github.com/lc/subjs@latest
sudo apt-get install parallel -y && sudo apt-get install chromium-chromedriver -y
sudo rm /etc/parallel/config


echo "Installation completed successfully!"
