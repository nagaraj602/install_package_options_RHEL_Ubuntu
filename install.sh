echo
echo "Do you want to exit from this script? Or install any application?"
echo "1) Exit"
echo "2) Install Tomcat"
echo "3) Install Jenkins"
echo "3.1) Update the Jenkins URL IP in location config file"
echo "3.2) Update the Jenkins port or print the Jenkins URL"
echo "4) Install Maven"
echo "5) Install htop"
echo "6) Install gradle"
echo "7) Install nodejs"
echo "8) Install python pip packages"
echo "9) Install make packages"
echo "10) Install MySQL"
echo "11) Install Traceroute"
echo "12) Install nslookup"
echo "13) Install Java 25"
echo "14) Install lsof"
echo "15) Install SonarQube"
echo "16) Install JFrog"
echo "17) Install AWS Cli"
echo "18) Install Stress command"
echo "19) Install wordpress on Ubuntu"
echo "20) Install Docker on Ubuntu"
echo "21) Install trivy"
echo

read -rp "Enter your choice [1-21]: " choice


cleanup() {
    cd
    find "$HOME" -maxdepth 1 -type d -name "install_*_RHEL_Ubuntu" -exec rm -rf {} +
}
trap cleanup EXIT INT TERM



case $choice in
            1)
                echo "Exiting script..."
                cd
                exit 0
                ;;
        
            2)
                echo "Install Tomcat selected."
                cd
                sudo dnf install git -y > /dev/null 2>&1
                rm -rf install_tomcat_RHEL_Ubuntu
                git clone https://github.com/nagaraj602/install_tomcat_RHEL_Ubuntu.git > /dev/null 2>&1
                cd install_tomcat_RHEL_Ubuntu || exit
                bash tomcat.sh
                cd ..
                rm -rf install_tomcat_RHEL_Ubuntu
                ;;
                
            3)
                echo "Install Jenkins selected."
                cd
                sudo dnf install git -y > /dev/null 2>&1
                rm -rf install_jenkins_RHEL_Ubuntu
                git clone https://github.com/nagaraj602/install_jenkins_RHEL_Ubuntu.git > /dev/null 2>&1
                cd install_jenkins_RHEL_Ubuntu || exit
                bash jenkins.sh
                cd ..
                rm -rf install_jenkins_RHEL_Ubuntu
                ;;

            3.1)
                
                FILE="/var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml"
                echo "Updating Jenkins URL with new IP..."

                NEW_IP=$(curl -s ifconfig.me)                
                # Extract current URL
                CURRENT_URL=$(sudo grep -oP '(?<=<jenkinsUrl>).*?(?=</jenkinsUrl>)' "$FILE")                
                # Extract PORT from current URL
                PORT=$(echo "$CURRENT_URL" | grep -oP ':\K[0-9]+')                
                # Safety check
                if [ -z "$PORT" ]; then
                    echo "Failed to extract port!"
                    exit 1
                fi                
                # Build new URL
                NEW_URL="http://${NEW_IP}:${PORT}/"                
                # Replace old URL with new URL
                sudo sed -i "s|<jenkinsUrl>.*</jenkinsUrl>|<jenkinsUrl>${NEW_URL}</jenkinsUrl>|" "$FILE"                
                # Restart Jenkins
                sudo systemctl restart jenkins
                
                echo "----------------------------------------"
                echo "You can access the Jenkins at: $NEW_URL"
                echo "----------------------------------------"
                ;;

            3.2)
            
                FILE="/var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml"
                
                echo "Choose an option:"
                echo "1) Show current Jenkins URL"
                echo "2) Change Jenkins port"
                read -p "Enter choice [1-2]: " choice
                
                case $choice in
                
                1)
                    echo "Fetching current Jenkins URL..."
                
                    CURRENT_URL=$(sudo grep -oP '(?<=<jenkinsUrl>).*?(?=</jenkinsUrl>)' "$FILE")
                
                    if [ -z "$CURRENT_URL" ]; then
                        echo "Could not find Jenkins URL!"
                        exit 1
                    fi
                
                    echo "----------------------------------------"
                    echo "Current Jenkins URL: $CURRENT_URL"
                    echo "----------------------------------------"
                    ;;
                
                2)
                    echo "Enter new Jenkins port:"
                    read NEW_PORT
                
                    # Validate port (numeric + valid range)
                    if ! [[ "$NEW_PORT" =~ ^[0-9]+$ ]] || [ "$NEW_PORT" -lt 1 ] || [ "$NEW_PORT" -gt 65535 ]; then
                        echo "Invalid port!"
                        exit 1
                    fi
                
                    echo "Updating Jenkins port..."
                
                    # Detect config file (Ubuntu or RHEL)
                    if [ -f /etc/default/jenkins ]; then
                        CONFIG_FILE="/etc/default/jenkins"
                        PORT_KEY="HTTP_PORT"
                    elif [ -f /etc/sysconfig/jenkins ]; then
                        CONFIG_FILE="/etc/sysconfig/jenkins"
                        PORT_KEY="JENKINS_PORT"
                    else
                        echo "Jenkins config file not found!"
                        exit 1
                    fi
                
                    # Update Jenkins service port
                    sudo sed -i "s/^${PORT_KEY}=.*/${PORT_KEY}=${NEW_PORT}/" "$CONFIG_FILE"
                
                    # Get Public IP
                    NEW_IP=$(curl -s ifconfig.me)
                
                    # Build new URL
                    NEW_URL="http://${NEW_IP}:${NEW_PORT}/"
                
                    # Update XML (this is what you asked to ensure)
                    sudo sed -i "s|<jenkinsUrl>.*</jenkinsUrl>|<jenkinsUrl>${NEW_URL}</jenkinsUrl>|" "$FILE"
                
                    # Restart Jenkins
                    sudo systemctl restart jenkins
                
                    echo "----------------------------------------"
                    echo "Jenkins port updated successfully!"
                    echo "Access it at: $NEW_URL"
                    echo "----------------------------------------"
                    ;;
                
                *)
                    echo "Invalid option"
                    ;;
                
                esac
                ;;
        
            4)
                echo "Install Maven selected."
                cd
                sudo dnf install git -y > /dev/null 2>&1
                rm -rf install_maven_RHEL_Ubuntu
                git clone https://github.com/nagaraj602/install_maven_RHEL_Ubuntu.git > /dev/null 2>&1
                cd install_maven_RHEL_Ubuntu || exit
                bash maven.sh
                cd ..
                rm -rf install_maven_RHEL_Ubuntu
                ;;
        
            5)
                echo "Install htop selected."
                echo
                echo "Installing htop..."
                cd;
                sudo dnf install git -y > /dev/null 2>&1;
                rm -rf install_htop_RHEL_Ubuntu
                git clone https://github.com/nagaraj602/install_htop_RHEL_Ubuntu.git > /dev/null 2>&1;
                cd install_htop_RHEL_Ubuntu;
                bash htop.sh
                cd ..
                rm -rf install_htop_RHEL_Ubuntu
                ;;
        
            6)
                echo "Install gradle selected."
                cd
                sudo dnf install git -y > /dev/null 2>&1
                rm -rf install_gradle_RHEL_Ubuntu
                git clone https://github.com/nagaraj602/install_gradle_RHEL_Ubuntu.git > /dev/null 2>&1
                cd install_gradle_RHEL_Ubuntu || exit
                bash gradle.sh
                cd ..
                rm -rf install_gradle_RHEL_Ubuntu
                ;;
        
            7)
                echo "Install nodejs selected."
                curl -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash > /dev/null 2>&1
                export NVM_DIR="$HOME/.nvm"
                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
                [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
                source ~/.bashrc
                nvm install --lts > /dev/null 2>&1
                echo "NodeJs installed"
                ;;
        
            8)
                echo "Install python pip packages selected."
                python3 --version
                distro=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f2 | sed 's/"//g')
                if [ "$distro" = "rhel" ]; then
                    sudo dnf update -y > /dev/null 2>&1
                    sudo dnf install python3-pip -y > /dev/null 2>&1
                    echo "Pip package installed on $distro."
                elif [ "$distro" = "ubuntu" ]; then
                    sudo apt-get update -y > /dev/null 2>&1
                    sudo apt-get install python3-pip -y > /dev/null 2>&1
                    echo "Pip package installed on $distro."
                else
                    echo "Unsupported Distribution - Only RHEL and Ubuntu supported."
                    exit 1    
                fi            
                ;;
        
            9)
                echo "Install make packages selected."
                distro=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f2 | sed 's/"//g')
                if [ "$distro" = "rhel" ]; then
                    sudo dnf update -y > /dev/null
                    sudo dnf install make -y > /dev/null
                    sudo dnf groupinstall "Development Tools" -y > /dev/null
                    echo "Make package installed"
                elif [ "$distro" = "ubuntu" ]; then
                    sudo apt-get update -y > /dev/null
                    sudo apt-get install make -y > /dev/null
                    sudo apt-get install build-essential -y > /dev/null
                    echo "Make package installed"
                else
                    echo "Unsupported Distribution - Only RHEL and Ubuntu supported."
                    exit 1
                fi
        
                ;;
        
            10)
                echo "Install MySQL selected."
            
                distro=$(grep "^ID=" /etc/os-release | cut -d "=" -f2 | tr -d '"')
            
                if [ "$distro" = "rhel" ]; then
                    echo
                    echo
                    echo "Installing MySQL on $distro..."
                    sudo dnf update -y > /dev/null 2>&1
                    sudo dnf install -y https://dev.mysql.com/get/mysql84-community-release-el10-2.noarch.rpm > /dev/null 2>&1
                    sudo dnf install -y mysql-community-server > /dev/null 2>&1
                    sudo systemctl daemon-reexec
                    sudo systemctl enable mysqld
                    sudo systemctl start mysqld
                    echo
                    sudo grep -oP 'A temporary password.*' /var/log/mysqld.log
                    echo
                    echo "############################################"
                    echo -e "Run below command to finish installation:\n"
                    echo -e " --> sudo mysql_secure_installation"
                    echo 
                    echo -e "\t Set:\n
                    * Root password\n
                    * Remove anonymous users → YES \n
                    * Disallow root remote login → YES \n
                    * Remove test DB → YES \n"
                    echo 
                    echo "To login to mysql, run this command:"
                    echo -e "\n --> mysql -u root -p \n \n"
                    
                        
                elif [ "$distro" = "ubuntu" ]; then
                    echo
                    echo
                    echo "Installing MySQL on $distro..."
                    sudo apt-get update -y > /dev/null 2>&1
                    sudo apt install -y mysql-server > /dev/null 2>&1
                    sudo systemctl enable mysql > /dev/null 2>&1
                    sudo systemctl start mysql > /dev/null 2>&1
                    echo
                    echo "############################################"
                    echo -e "Run below command to finish installation:\n"
                    echo -e " --> sudo mysql_secure_installation"
                    echo 
                    echo -e "\t Set:\n
                    * Root password\n
                    * Remove anonymous users → YES \n
                    * Disallow root remote login → YES \n
                    * Remove test DB → YES \n"
                    echo 
                    echo "To login to mysql, run this command:"
                    echo -e "\n --> mysql -u root -p \n \n"
            
                else
                    echo "Unsupported Distribution - Only RHEL and Ubuntu supported."
                    exit 1
                fi
                ;;
        
            11) 
                echo "Install Traceroute selected."
                distro=$(grep "^ID=" /etc/os-release | cut -d "=" -f2 | tr -d '"')
            
                if [ "$distro" = "rhel" ]; then
                    sudo dnf update -y > /dev/null 2>&1
                    sudo dnf install traceroute -y > /dev/null 2>&1
                    echo "Traceroute installed on $distro..."
                    echo "You can run as: traceroute <hostname/IP>"
                elif [ "$distro" = "ubuntu" ]; then
                    sudo apt-get update -y > /dev/null 2>&1
                    sudo apt install traceroute -y > /dev/null 2>&1
                    echo "Traceroute installed on $distro..."
                    echo "You can run as: traceroute <hostname/IP>"
                else
                    echo "Unsupported Distribution - Only RHEL and Ubuntu supported."
                    exit 1
                fi
                ;;
        
            12)
                echo "Install nslookup selected."
                distro=$(grep "^ID=" /etc/os-release | cut -d "=" -f2 | tr -d '"')
            
                if [ "$distro" = "rhel" ]; then
                    sudo dnf update -y > /dev/null 2>&1
                    sudo dnf install bind-utils -y > /dev/null 2>&1
                    echo "nslookup installed on $distro..."
                    echo "You can run as: nslookup <hostname/IP/domain>"
                elif [ "$distro" = "ubuntu" ]; then
                    sudo apt-get update -y > /dev/null 2>&1
                    sudo apt install dnsutils -y > /dev/null 2>&1
                    echo "nslookup installed on $distro..."
                    echo "You can run as: nslookup <hostname/IP/domain>"
                else
                    echo "Unsupported Distribution - Only RHEL and Ubuntu supported."
                    exit 1
                fi
                ;;  

            13)
                echo "Install Java 25 selected."
                distro=$(grep "^ID=" /etc/os-release | cut -d "=" -f2 | tr -d '"')
            
                if [ "$distro" = "rhel" ]; then
                    sudo dnf update -y > /dev/null 2>&1
                    sudo yum install java-25-openjdk-devel -y > /dev/null
                elif [ "$distro" = "ubuntu" ]; then
                    sudo apt-get update -y > /dev/null
                    sudo apt-get install openjdk-25-jdk -y > /dev/null
                else
                    echo "Unsupported Distribution - Only RHEL and Ubuntu supported."
                    exit 1
                fi
                ;;  
            14)
                echo "Install lsof selected."
                distro=$(grep "^ID=" /etc/os-release | cut -d "=" -f2 | tr -d '"')
            
                if [ "$distro" = "rhel" ]; then
                    sudo dnf update -y > /dev/null 2>&1
                    sudo yum install lsof -y > /dev/null
                    echo 
                    echo "lsof installed on $distro."
                    echo
                elif [ "$distro" = "ubuntu" ]; then
                    sudo apt-get update -y > /dev/null
                    sudo apt-get install lsof -y > /dev/null
                    echo 
                    echo "lsof installed on $distro."
                    echo
                else
                    echo "Unsupported Distribution - Only RHEL and Ubuntu supported."
                    exit 1
                fi
                ;;
            15)
                echo "Install SonarQube selected."
                cd; sudo dnf install git -y > /dev/null 2>&1; git clone https://github.com/nagaraj602/install_sonarqube_RHEL_Ubuntu.git > /dev/null 2>&1; cd install_sonarqube_RHEL_Ubuntu; bash sonarqube.sh                
                ;;
                
            16)
                echo "Install JFrog selected."
                cd; sudo dnf install git -y > /dev/null 2>&1; git clone https://github.com/nagaraj602/install_jfrog_RHEL_Ubuntu.git > /dev/null 2>&1; cd install_jfrog_RHEL_Ubuntu; bash jfrog.sh                
                ;;

            17)
                echo "Install AWS Cli selected."
                distro=$(grep "^ID=" /etc/os-release | cut -d "=" -f2 | tr -d '"')
            
                if [ "$distro" = "rhel" ]; then
                    sudo dnf update -y > /dev/null 2>&1
                    sudo yum install unzip -y > /dev/null

                elif [ "$distro" = "ubuntu" ]; then
                    sudo apt-get update -y > /dev/null
                    sudo apt-get install unzip -y > /dev/null

                else
                    echo "Unsupported Distribution - Only RHEL and Ubuntu supported."
                    exit 1
                fi
                curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" > /dev/null 2>&1
                unzip awscliv2.zip > /dev/null 2>&1
                sudo ./aws/install > /dev/null 2>&1
                echo 
                echo "AWS Cli installed on $distro."
                echo                
                ;;
            18)
                echo "Install Stress selected."
                distro=$(grep "^ID=" /etc/os-release | cut -d "=" -f2 | tr -d '"')
            
                if [ "$distro" = "rhel" ]; then
                    sudo dnf update -y > /dev/null 2>&1
                    sudo rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm > /dev/null 2>&1
                    sudo yum update -y > /dev/null 2>&1
                    sudo yum install stress -y > /dev/null 2>&1

                elif [ "$distro" = "ubuntu" ]; then
                    sudo apt-get update -y > /dev/null 2>&1
                    sudo apt-get install stress -y > /dev/null 2>&1

                else
                    echo "Unsupported Distribution - Only RHEL and Ubuntu supported."
                    exit 1
                fi

                echo 
                echo "Stress command is installed on $distro."
                echo
                echo "###################################################################################"
                echo "#  You can use this command to generate stress:                                   #"
                echo -e "#\t 👉  stress -c 1 -t 3600                  --> For 1 core CPU for 1 hour   #"
                echo -e "#\t 👉  stress -c 2 -t 3600                  --> For 2 core CPU for 1 hour   #"
                echo "###################################################################################"
                echo
                echo                
                ;;   

            19)
                echo "Install WordPress selected."
                cd
                sudo dnf install git -y > /dev/null 2>&1
                rm -rf install_wordpress_Ubuntu
                https://github.com/nagaraj602/install_wordpress_Ubuntu.git > /dev/null 2>&1
                cd install_wordpress_Ubuntu || exit
                bash install.sh
                cd ..
                rm -rf install_wordpress_Ubuntu
                ;;
                
            20) 
                echo "Install Docker on Ubuntu selected"
                cd; 
                sudo dnf install git -y > /dev/null 2>&1; 
                git clone https://github.com/nagaraj602/install_docker_RHEL_Ubuntu.git > /dev/null 2>&1; 
                cd install_docker_RHEL_Ubuntu; 
                bash docker.sh
                ;;

            21)
                echo "Install Trivy selected on Ubuntu selected"
                sudo apt update && \
                sudo apt install wget apt-transport-https gnupg lsb-release -y && \
                sudo mkdir -p /etc/apt/keyrings && \
                wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /etc/apt/keyrings/trivy.gpg > /dev/null && \
                echo "deb [signed-by=/etc/apt/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list && \
                sudo apt update && \
                sudo apt install trivy -y
                ;;
                
            *)
                echo "Invalid option. Exiting."
                exit 1
                ;;
        esac

