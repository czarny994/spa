#!/bin/bash

echo "************** ANGULAR INSTALL **************"
curl -sL https://rpm.nodesource.com/setup_15.x | sudo -E bash -
sudo yum install -y nodejs
echo "NODE VERSION:"
node --version
echo "npm VERSION:"
npm --version
sudo npm install -g @angular/cli@9.1.0 > /dev/null
ng --version
