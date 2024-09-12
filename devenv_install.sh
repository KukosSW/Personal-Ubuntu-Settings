# This scripts installing all of the necessary software for a development environment.
#
# LIST:
# - software-properties-common
# - apt-transport-https
# - ca-certificates
# - gnupg-agent
# - gnupg
# - curl
# - wget
# - git
# - tar
# - gawk
# - sed
# - grep
# - unzip
# - zip
# - net-tools
# - rsync
# - openssh-client
# - openssh-server
# - sshpass
# - shellcheck
# - jq
# - vagrant
# - VirtualBox
# - docker

function PersonalSettings::DevEnv::install_docker()
{
    if command -v "docker" &> /dev/null; then
        echo "Docker is already installed"
        return 0
    fi

    sudo install -m 0755 -d /etc/apt/keyrings || return 1
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc || return 1
    sudo chmod a+r /etc/apt/keyrings/docker.asc || return 1

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list

    sudo apt update || return 1
    sudo apt install -y docker-ce || return 1
    sudo apt install -y docker-ce-cli || return 1
    sudo apt install -y containerd.io || return 1
    sudo apt install -y docker-buildx-plugin || return 1
    sudo apt install -y docker-compose-plugin || return 1

    sudo usermod -aG docker "${USER}" || return 1

    return 0
}

function PersonalSettings::DevEnv::install_virtualbox()
{
    if command -v "virtualbox" &> /dev/null; then
        echo "VirtualBox is already installed"
        return 0
    fi

    sudo apt install -y virtualbox || return 1

    echo virtualbox-ext-pack virtualbox-ext-pack/license select true | sudo debconf-set-selections || return 1
    sudo apt install -y virtualbox-ext-pack || return 1

    sudo apt install -y virtualbox-guest-additions-iso || return 1
    sudo apt install -y virtualbox-dkms || return 1
    sudo apt install -y virtualbox-qt || return 1
    sudo apt install -y virtualbox-guest-utils || return 1
    sudo apt install -y virtualbox-guest-x11 -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" || return 1

    return 0
}

function PersonalSettings::DevEnv::install_vagrant()
{
    if command -v "vagrant" &> /dev/null; then
        echo "Vagrant is already installed"
        return 0
    fi

    local ubuntu_version
    ubuntu_version=$(lsb_release -cs)

    # --spider option in wget checks if the file exists without downloading it
    if wget -q --spider "https://apt.releases.hashicorp.com/dists/${ubuntu_version}/Release"; then
        wget -qO- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg || return 1
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
            | sudo tee /etc/apt/sources.list.d/hashicorp.list || return 1

        sudo apt update || return 1
        sudo apt install -y vagrant || return 1
    else
        local vagrant_version
        vagrant_version=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/vagrant | jq -r '.current_version')
        wget -q "https://releases.hashicorp.com/vagrant/${vagrant_version}/vagrant_${vagrant_version}-1_amd64.deb"

        sudo dpkg -i "vagrant_${vagrant_version}-1_amd64.deb" || return 1
        rm -rf "vagrant_${vagrant_version}-1_amd64.deb"


        sudo apt --fix-broken install || return 1
    fi

    vagrant plugin install vagrant-scp >/dev/null 2>&1 || return 1
    vagrant plugin install vagrant-disksize >/dev/null 2>&1 || return 1
    vagrant plugin install vagrant-vbguest >/dev/null 2>&1 || return 1
    vagrant plugin install vagrant-timezone >/dev/null 2>&1 || return 1
    vagrant plugin install vbinfo >/dev/null 2>&1 || return 1

    return 0
}

function PersonalSettings::DevEnv::install()
{
    sudo apt update || return 1
    sudo apt upgrade -y || return 1

    sudo apt install -y software-properties-common || return 1
    sudo apt install -y apt-transport-https || return 1
    sudo apt install -y ca-certificates || return 1
    sudo apt install -y gnupg-agent || return 1
    sudo apt install -y gnupg || return 1
    sudo apt install -y curl || return 1
    sudo apt install -y wget || return 1
    sudo apt install -y git || return 1
    sudo apt install -y tar || return 1
    sudo apt install -y gawk || return 1
    sudo apt install -y sed || return 1
    sudo apt install -y grep || return 1
    sudo apt install -y unzip || return 1
    sudo apt install -y zip || return 1
    sudo apt install -y net-tools || return 1
    sudo apt install -y rsync || return 1
    sudo apt install -y openssh-client || return 1
    sudo apt install -y openssh-server || return 1
    sudo apt install -y sshpass || return 1
    sudo apt install -y shellcheck || return 1
    sudo apt install -y jq || return 1

    PersonalSettings::DevEnv::install_docker || return 1
    PersonalSettings::DevEnv::install_virtualbox || return 1
    PersonalSettings::DevEnv::install_vagrant || return 1


    return 0
}

PersonalSettings::DevEnv::install || exit 1