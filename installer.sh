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

echo "🚀 Updating Packages..."
apt update

echo "🌙 Installing PHP-8.3..."
apt install -y php8.3 php8.3-cli php8.3-fpm php8.3-mysql php8.3-zip php8.3-xml php8.3-bcmath php8.3-mbstring php8.3-curl php8.3-intl php8.3-gd php8.3-opcache php8.3-simplexml unzip curl
update-alternatives --install /usr/bin/php php /usr/bin/php8.3 83
update-alternatives --set php /usr/bin/php8.3

echo "✨ Installing Composer Locally..."
curl -L -o /usr/local/bin/composer.phar https://raw.githubusercontent.com/lostdude01/Pterodactyl-Fix/main/composer.phar

echo "Making composer.phar executable and moving to /usr/local/bin/composer"
chmod +x /usr/local/bin/composer.phar
mv /usr/local/bin/composer.phar /usr/local/bin/composer

echo "🔥 Cleaning up installation..."

echo "Installation complete!"
echo -n "PHP version: "
php -v | head -n 1
echo -n "Composer version: "
composer --version

echo "Verifying PHP extensions..."
for ext in pdo_mysql zip simplexml bcmath dom; do
    if php -m | grep -q "$ext"; then
        echo " - $ext: enabled"
    else
        echo " - $ext: NOT enabled"
    fi
done

# Fix PATH if /usr/local/bin is missing
if ! echo "$PATH" | grep -q "/usr/local/bin"; then
    echo "🚀 Fixing Paths..."
else
    echo "✅ Composer is already Executable."
fi
