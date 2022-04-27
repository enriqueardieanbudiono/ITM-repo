<#
Author: Enrique A. Budiono 
Description: This automation is created for itmt-430 student when installing tools for the first time 
#>

Write-Host "======================="
Write-Host "Starting the automation"
Write-Host "======================="

Write-Host "`n======================="
Write-Host "Questions for GitHub!"
Write-Host "======================="

# Asking the user name
$name = Read-Host "What is your name? "
$email = Read-Host "What is your email for github? "

$testchoco = powershell choco -v
<# If Chocolately not installed #>
Write-Host "Checking if chocolately is installed"
if(-not($testchoco)) {
    Write-Output "Chocolately is not installed, installing it"
    Set-ExecutionPolicy Bypass -Scope Process -Force; 
    [System.Net.ServicePointManager]::SecurityProtocol = 
    [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
else {
    Write-Output "Chocolately is already installed"
}

<# Installing package using Chocolatey #>
Write-Host "Installing package using Chocolatey"
choco install -y powershell-core microsoft-windows-terminal git -y vscode vscode-powershell atom virtualbox vagrant packer
Write-Host "Finished installing package using Chocolatey"

<# Show the SSH Version #>
Write-Host "`nChecking SSH version:"

$ssh = ssh.exe -V
Write-Output $ssh

<# Show the git version #>
Write-Host "`nChecking git version:"
git.exe --version

<# Configuring Git Client #>
Write-Host "`n======================="
Write-Host "Configuring Git Client"
Write-Host "=======================`n"

Write-Host "Entering the Github Name"
git.exe config --global user.name $name
Write-Host "Entering the Github Email"
git.exe config --global user.email $email

Write-Host "`n==========================="
Write-Host "Showing the git config list"
Write-Host "===========================`n"
Write-Output "Github user.name:"
git.exe config user.name
Write-Output "Github user.email:"
git.exe config user.email

<# Showing Version of Virtualbox #>
Write-Host "`n==========================="
Write-Host "Checking Virtualbox Version"
Write-Host "===========================`n"
Write-Host "Virtualbox Version:"
VBoxManage.exe --version

<# Showing Vagrant version#>
Write-Host "`n========================"
Write-Host "Checking Vagrant Version"
Write-Host "========================`n"
Write-Host "Vagrant Version:"
vagrant.exe --version

<# Showing Packer version #>
Write-Host "`n======================="
Write-Host "Checking Packer Version"
Write-Host "=======================`n"
Write-Host "Vagrant Version:"
packer.exe --version