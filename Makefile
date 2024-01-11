ARCH := $(shell dpkg --print-architecture)
RELEASE := $(shell lsb_release -cs)
REPO := $(shell mktemp -d)

all: developer-packages cloud-packages cube-packages user-packages

developer-packages: install-github-cli

cloud-packages: install-azure-cli install-terraform-cli

cube-packages: install-cube-cli

base-packages:
	echo "Installing base packages"
	sudo apt update -qq
	sudo apt dist-upgrade -qq -y
	sudo apt install -qq -y vim-nox build-essential gnupg curl git git-lfs etckeeper xdg-utils wslu software-properties-common
	git lfs install

install-azure-cli: base-packages
	curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
	az cloud set --name AzureUSGovernment
	az config set extension.use_dynamic_install=yes_without_prompt

install-terraform-cli: base-packages 
	curl -sSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/hashicorp-archive-keyring.gpg
	sudo chmod go+r /usr/share/keyrings/hashicorp-archive-keyring.gpg
	echo "deb [arch=$(ARCH) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(RELEASE) main" | sudo tee /etc/apt/sources.list.d/terraform-cli.list > /dev/null
	sudo apt update -qq
	sudo apt install terraform -yqq

install-github-cli: base-packages
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
	sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
	echo "deb [arch=$(ARCH) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
	sudo apt update -qq
	sudo apt install gh -yqq

# Need to move to building the files then installing them. This will allow make clean to work as well.
install-cube-cli: install-github-cli
	gh repo clone battellecube/cube-env $(REPO)
	git -C $(REPO) checkout deb_repo
	cat $(REPO)/KEY.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/cubeenvcli-archive-keyring.gpg
	sudo chmod go+r /usr/share/keyrings/cubeenvcli-archive-keyring.gpg
	echo "deb [arch=$(ARCH) signed-by=/usr/share/keyrings/cubeenvcli-archive-keyring.gpg] https://battellecube.github.io/cube-env ./" | sudo tee /etc/apt/sources.list.d/cube-env.list > /dev/null
	echo "deb-src [arch=$(ARCH) signed-by=/usr/share/keyrings/cubeenvcli-archive-keyring.gpg] https://battellecube.github.io/cube-env ./" | sudo tee -a /etc/apt/sources.list.d/cube-env.list > /dev/null
	sudo apt update -qq
	sudo apt install -yqq cube-env
	sudo apt build-dep -yqq cube-env

user-packages:
	echo "Hook user dotfiles here"
