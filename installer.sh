#!/bin/bash
set -e

echo "==============================================="
echo " Script Made by LostDude."
echo " THIS IS NOT OFFICIAL SCRIPT BY NIT."
echo " This Script will fix the NIT Composer Issues"
echo "==============================================="
echo ""

read -p "Are you sure you want to continue? (y/N): " confirm
confirm=${confirm,,}  # convert to lowercase
if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
    echo "Installation aborted."
    exit 1
fi

echo "Step 1: Installing prerequisites to add repo..."
apt update
apt install -y lsb-release apt-transport-https ca-certificates wget software-properties-common

echo "Step 2: Adding Ondřej Surý PHP repository..."
wget -qO /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

echo "Step 3: Updating package lists..."
apt update

echo "Step 4: Installing PHP 8.3 and extensions..."
apt install -y php8.3 php8.3-cli php8.3-fpm php8.3-mysql php8.3-zip php8.3-xml php8.3-bcmath php8.3-mbstring php8.3-curl php8.3-intl php8.3-gd php8.3-opcache php8.3-simplexml unzip git

echo "Step 5: Setting PHP 8.3 as the default PHP CLI version..."
update-alternatives --install /usr/bin/php php /usr/bin/php8.3 83
update-alternatives --set php /usr/bin/php8.3

echo "Step 6: Downloading composer.phar from GitHub..."
curl -o /usr/local/bin/composer https://raw.githubusercontent.com/lostdude01/Pterodactyl-Fix/main/composer.phar
chmod +x /usr/local/bin/composer

echo "Step 7: Fixing PATH if /usr/local/bin not present..."
if ! echo "$PATH" | grep -q "/usr/local/bin"; then
    echo "export PATH=\$PATH:/usr/local/bin" >> /etc/profile
    export PATH=$PATH:/usr/local/bin
    echo "Added /usr/local/bin to PATH"
fi

echo "Step 8: Verifying installation..."
echo -n "PHP version: "
php -v | head -n 1
echo -n "Composer version: "
composer --version

echo "Checking PHP extensions..."
for ext in pdo_mysql zip simplexml bcmath dom; do
    if php -m | grep -q "$ext"; then
        echo " - $ext: enabled"
    else
        echo " - $ext: NOT enabled"
    fi
done

echo ""
echo "All done! You should be ready to use the Pterodactyl panel with PHP 8.3 and Composer."
