# this is a personal script for making sure I can jsut grab my tools on the box i am working on, to reduce the buzz when in the fuzz, to glow when in flow , to reduce desolation when doing enumeration.
# socialfish ;) For later please. a bit tired now.
# joomscan saved for later.
sudo apt install dirb
sudo apt-get install libcap2-bin wireshark

echo "? DO YOU WANT TO INSTALL METASPLOIT FRAMEWORK ?"
PS3="Please select an option : "
choices=("yes" "no")
select choice in "${choices[@]}"; do
        case $choice in
                yes)

				    echo "INSTALLING METASPLOIT FRAMEWORK" 
                    #INSTALL THE JAVA8
                    sudo add-apt-repository -y ppa:webupd8team/java
                    sudo apt-get update
                    sudo apt-get -y install oracle-java8-installer
                    #MAKING SURE WE'RE UPTO DATE AND NOT LIVING UNDER A ROCK
                    sudo apt-get update
                    sudo apt-get upgrade
                    #INSTALLING DEPENDENCIES
                    sudo apt-get install build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev libyaml-dev curl zlib1g-dev gawk bison libffi-dev libgdbm-dev libncurses5-dev libtool sqlite3 libgmp-dev gnupg2 dirmngr
                    #Installing a Proper Version of Ruby
                    gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
                    curl -L https://get.rvm.io | bash -s stable
                    source ~/.rvm/scripts/rvm
                    echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
                    source ~/.bashrc
                    RUBYVERSION=$(wget https://raw.githubusercontent.com/rapid7/metasploit-framework/master/.ruby-version -q -O - )
                    rvm install $RUBYVERSION
                    rvm use $RUBYVERSION --default
                    ruby -v

                    #Installing Ruby using rbenv:
                    cd ~
                    git clone git://github.com/sstephenson/rbenv.git .rbenv
                    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
                    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
                    exec $SHELL

                    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
                    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

                    # sudo plugin so we can run Metasploit as root with "rbenv sudo msfconsole" 
                    git clone git://github.com/dcarley/rbenv-sudo.git ~/.rbenv/plugins/rbenv-sudo

                    exec $SHELL

                    RUBYVERSION=$(wget https://raw.githubusercontent.com/rapid7/metasploit-framework/master/.ruby-version -q -O - )
                    rbenv install $RUBYVERSION
                    rbenv global $RUBYVERSION
                    ruby -v

                    #INSTALLING Nmap
                    mkdir ~/Development
                    cd ~/Development
                    git clone https://github.com/nmap/nmap.git
                    cd nmap 
                    ./configure
                    make
                    sudo make install
                    make clean

                    #INSTALLING METASPLOIT FRAMEWORK
                    cd /opt
                    sudo git clone https://github.com/rapid7/metasploit-framework.git
                    sudo chown -R `whoami` /opt/metasploit-framework
                    cd metasploit-framework
                    # If using RVM set the default gem set that is create when you navigate in to the folder
                    rvm --default use ruby-${RUBYVERSION}@metasploit-framework
                    gem install bundler
                    bundle install

                    cd metasploit-framework
                    sudo bash -c 'for MSF in $(ls msf*); do ln -s /opt/metasploit-framework/$MSF /usr/local/bin/$MSF;done'

                    #CONFIGURE POSTGRESQL SERVER
                    echo "export PATH=$PATH:/usr/lib/postgresql/10/bin" >> ~/.bashrc
                    . ~/.bashrc 
                    #NOW WE ADD THE CURRENT USER TO POSTGRE GROUP AND CREATE A NEW SESSION SO THAT THE PERMISSIONS APPLY.
                    sudo usermod -a -G postgres `whoami`
                    sudo su - `whoami`

                    #NAVIGATE TO THE METASPLOIT FOLDER AND INIT THE DB AND RESTAPI. WHEN RUN, THE MSF DB FOLLOW THE INSTRUCTIONS ON THE SCREEN.
                    cd /opt/metasploit-framework/
                    ./msfdb init
                    #If the service will be exposed to any network other than local 
                    #do generate proper SSL keys for use of it in operations. 
                    #For more information check Rapid7 documentation 
                    #https://github.com/rapid7/metasploit-framework/wiki/Metasploit-Web-Service	esac	
    esac                
done
fi

echo "INSTALLING ALTDNS"
git clone https://github.com/infosec-au/altdns
python pip install py-altdns
cd ~/tools
echo "done"


echo "INSTALLING DNSRECON"
git clone https://github.com/darkoperator/dnsrecon
cd ~/tools
echo "done."

echo "INSTALLING ENUM-4-LINUX"
git clone https://github.com/CiscoCXSecurity/enum4linux
cd ~/tools
echo "done."

echo "INSTALLING GOLISMERO"
cd /opt
git clone https://github.com/golismero/golismero.git
cd golismero
pip install -r requirements.txt
pip install -r requirements_unix.txt
ln -s ${PWD}/golismero.py /usr/bin/golismero
cd ~/tools
echo "done."
#If you have an API key for Shodan, or an OpenVAS server or SpiderFoot server you want to integrate with GoLismero, run the following commands:


echo "INSTALLING jSQL-injection"
wget "https://github.com/ron190/jsql-injection/releases/download/v0.82/jsql-injection-v0.82.jar"
cd ~/tools
echo "downloaded, done. "




#install go
if [[ -z "$GOPATH" ]];then
echo "It looks like go is not installed, would you like to install it now"
PS3="Please select an option : "
choices=("yes" "no")
select choice in "${choices[@]}"; do
        case $choice in
                yes)

					echo "Installing Golang"
					wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
					sudo tar -xvf go1.13.4.linux-amd64.tar.gz
					sudo mv go /usr/local
					export GOROOT=/usr/local/go
					export GOPATH=$HOME/go
					export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
					echo 'export GOROOT=/usr/local/go' >> ~/.bash_profile
					echo 'export GOPATH=$HOME/go'	>> ~/.bash_profile			
					echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bash_profile	
					source ~/.bash_profile
					sleep 1
					break
					;;
				no)
					echo "Please install go and rerun this script"
					echo "Aborting installation..."
					exit 1
					;;
	esac	
done
fi

go get github.com/OJ/gobuster

go get github.com/michenriksen/aquatone


echo "INSTALLING ARP-SCAN"
git clone https://github.com/royhills/arp-scan.git
cd arp-scan
autoreconf --install
./configure
make
make check 
make install
cd ~/tools
echo "done."

echo "Installing Websploit"
git clone https://github.com/websploit/websploit.git
cd websploit
python setup.py install
cd ~/tools/
echo "done"

echo "Installing JSParser from Nahamsec"
git clone https://github.com/nahamsec/JSParser.git
cd JSParser*
sudo python setup.py install
cd ~/tools/
echo "done"


echo "installing Sublist3r"
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r*
pip install -r requirements.txt
cd ~/tools/
echo "done"

echo "installing teh_s3_bucketeers"
git clone https://github.com/tomdev/teh_s3_bucketeers.git
cd ~/tools/
echo "done"


echo "installing wpscan"
git clone https://github.com/wpscanteam/wpscan.git
cd wpscan*
sudo gem install bundler && bundle install --without test
cd ~/tools/
echo "done"


echo "installing dirsearch"
git clone https://github.com/maurosoria/dirsearch.git
cd ~/tools/
echo "done"


echo "installing lazys3"
git clone https://github.com/nahamsec/lazys3.git
cd ~/tools/
echo "done"

echo "installing virtual host discovery"
git clone https://github.com/jobertabma/virtual-host-discovery.git
cd ~/tools/
echo "done"


echo "installing sqlmap"
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
cd ~/tools/
echo "done"

echo "installing knock.py"
git clone https://github.com/guelfoweb/knock.git
cd ~/tools/
echo "done"

echo "installing lazyrecon"
git clone https://github.com/nahamsec/lazyrecon.git
cd ~/tools/
echo "done"

echo "installing nmap"
sudo apt-get install -y nmap
echo "done"

echo "installing massdns"
git clone https://github.com/blechschmidt/massdns.git
cd ~/tools/massdns
make
cd ~/tools/
echo "done"

echo "installing asnlookup"
git clone https://github.com/yassineaboukir/asnlookup.git
cd ~/tools/asnlookup
pip install -r requirements.txt
cd ~/tools/
echo "done"

echo "installing httprobe"
go get -u github.com/tomnomnom/httprobe 
echo "done"

echo "installing unfurl"
go get -u github.com/tomnomnom/unfurl 
echo "done"

echo "installing waybackurls"
go get github.com/tomnomnom/waybackurls
echo "done"

echo "installing crtndstry"
git clone https://github.com/nahamsec/crtndstry.git
echo "done"

echo "downloading Seclists"
cd ~/tools/
git clone https://github.com/danielmiessler/SecLists.git
cd ~/tools/SecLists/Discovery/DNS/
##THIS FILE BREAKS MASSDNS AND NEEDS TO BE CLEANED
cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
cd ~/tools/
echo "done"

echo "Downloading Payloads-All-the-Things"
git clone https://github.com/swisskyrepo/PayloadsAllTheThings 
echo -e "All tools are set up in ~/tools"
cd ~/tools
echo "Downloading Payloads-All-the-Things"
git clone https://github.com/1N3/IntruderPayloads 
echo -e "All tools are set up in ~/tools"
cd ~/tools

echo "installing Masscan"
cd ~/tools
sudo apt-get install git gcc make libpcap-dev
git clone https://github.com/robertdavidgraham/masscan
cd masscan
make
cd ~/tools



cd ~/tools
ls -la
echo "don't forget to set up AWS credentials in ~/.aws/!"
echo "implement priviledge separation for wireshark https://lospi.net/software/wireshark/networks/ubuntu/2015/02/11/configuring-wireshark-on-ubuntu-14.html"

echo "Next, Alias commands for your convinience?"
echo "run msfconsole to see if it worked."
echo " go at https://github.com/golismero/golismero for a bit more of customised setup."

# I want to listen to tides of man for-ever, so damn smooth.