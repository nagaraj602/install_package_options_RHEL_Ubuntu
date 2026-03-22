echo
echo "Do you want to exit from this script? Or install any application?"
echo "1) Exit"
echo "2) Install Tomcat"
echo "3) Install Jenkins"
echo "4) Install Maven"
echo "5) Install htop"
echo "6) Install gradle"
echo "7) Install nodejs"
echo "8) Install python pip packages"
echo "9) Install make packages"
echo "10) Install MySQL"
echo

read -p "Enter your choice [1-10]: " choice

case $choice in
    1)
        echo "Exiting script..."
        exit 0
        ;;

    2)
        echo "Install Tomcat selected..."
        cd
        sudo yum install git -y > /dev/null 2>&1
        rm -rf install_tomcat_RHEL_Ubuntu
        git clone https://github.com/nagaraj602/install_tomcat_RHEL_Ubuntu.git > /dev/null 2>&1
        cd install_tomcat_RHEL_Ubuntu || exit
        bash tomcat.sh
        cd ..
        rm -rf install_tomcat_RHEL_Ubuntu
        ;;
        
    3)
        echo "Install Jenkins selected..."
        cd
        sudo yum install git -y > /dev/null 2>&1
        rm -rf install_jenkins_RHEL_Ubuntu
        git clone https://github.com/nagaraj602/install_jenkins_RHEL_Ubuntu.git > /dev/null 2>&1
        cd install_jenkins_RHEL_Ubuntu || exit
        bash jenkins.sh
        cd ..
        rm -rf install_jenkins_RHEL_Ubuntu
        ;;

    4)
        echo "Install Maven selected..."
        cd
        sudo yum install git -y > /dev/null 2>&1
        rm -rf install_maven_RHEL_Ubuntu
        git clone https://github.com/nagaraj602/install_maven_RHEL_Ubuntu.git > /dev/null 2>&1
        cd install_maven_RHEL_Ubuntu || exit
        bash maven.sh
        cd ..
        rm -rf install_maven_RHEL_Ubuntu
        ;;

    5)
        echo "Install htop selected..."
        cd;
        sudo yum install git -y > /dev/null 2>&1;
        rm -rf install_htop_RHEL_Ubuntu
        git clone https://github.com/nagaraj602/install_htop_RHEL_Ubuntu.git > /dev/null 2>&1;
        cd install_htop_RHEL_Ubuntu;
        bash htop.sh
        cd ..
        rm -rf install_htop_RHEL_Ubuntu
        ;;

    6)
        echo "Install gradle selected..."
        cd
        sudo yum install git -y > /dev/null 2>&1
        rm -rf install_gradle_RHEL_Ubuntu
        git clone https://github.com/nagaraj602/install_gradle_RHEL_Ubuntu.git > /dev/null 2>&1
        cd install_gradle_RHEL_Ubuntu || exit
        bash gradle.sh
        cd ..
        rm -rf install_gradle_RHEL_Ubuntu
        ;;

    7)
        echo "Install nodejs selected..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash > /dev/null 2>&1
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        source ~/.bashrc
        nvm install --lts
        echo "NodeJs installed"
        ;;

    8)
        echo "Install python pip packages selected..."
        python
        sudo yum install python-pip -y > /dev/null 2>&1
        echo "Pip package installed"
        ;;

    9)
        echo "Install make packages selected..."
        distro=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f2 | sed 's/"//g')
        if [ "$distro" = "rhel" ]; then
            sudo yum update -y > /dev/null
            sudo yum install make -y > /dev/null
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
        echo "Install MySQL selected..."
    
        distro=$(grep "^ID=" /etc/os-release | cut -d "=" -f2 | tr -d '"')
    
        if [ "$distro" = "rhel" ]; then
            sudo dnf clean all > /dev/null 2>&1
            sudo dnf makecache > /dev/null 2>&1
            sudo dnf install mariadb-server -y
            if ! rpm -q mariadb-server > /dev/null 2>&1; then
                echo "MariaDB installation failed"
                exit 1
            fi
            if systemctl list-unit-files | grep -q mariadb; then
                sudo systemctl start mariadb
                sudo systemctl enable mariadb
            elif systemctl list-unit-files | grep -q mysqld; then
                sudo systemctl start mysqld
                sudo systemctl enable mysqld
            else
                echo "Service not found after install"
                exit 1
            fi
            
        elif [ "$distro" = "ubuntu" ]; then
            sudo apt-get update -y > /dev/null 2>&1
            sudo apt-get install mysql-server -y > /dev/null 2>&1
            sudo systemctl start mysql
            sudo systemctl enable mysql
    
        else
            echo "Unsupported Distribution - Only RHEL and Ubuntu supported."
            exit 1
        fi
        ;;
    
    *)
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac
