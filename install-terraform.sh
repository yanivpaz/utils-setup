#!/bin/bash

# script to isntall basic tools on wsl and cloudshell

function terraform-install() {
 echo "Installing Terraform "
 curl $LATEST_URL -o  /tmp/terraform.zip
 unzip -o  /tmp/terraform.zip
 rm -f /tmp/terraform.zip
 sudo mv terraform /usr/local/bin
}



# Main 
export TERRAFORM_BINARY=/usr/local/bin/terraform
if [ ! -f /usr/bin/jq ]
then
 echo "Installing jq"
 sudo apt install jq -y
fi

if [ ! -f /usr/bin/unzip ]
then
 echo "Installing zip"
 sudo apt install unzip -y
fi

LATEST_URL=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | egrep -v 'rc|beta|alpha' | egrep 'linux.*amd64'  | tail -1)
if [ ! -f $TERRAFORM_BINARY ]
then
 terraform-install
 else
 TF_CURRENT_VERSION=`terraform version -json |jq .terraform_version | tr -d '"'`
 TF_LATEST_VERSION=`echo $LATEST_URL | cut -d "/" -f5`
 echo "TF version is : $TF_CURRENT_VERSION , latest version is $TF_LATEST_VERSION"
 if [ "$TF_CURRENT_VERSION" != "$TF_LATEST_VERSION" ]
 then 
	 echo "installing latest version of Terraform"
	 sudo rm -f $TERRAFORM_BINARY
	 terraform-install
  else
	  echo "Terraform already installed with the latest version"

 fi 
fi

