#!/bin/bash
set -e

echo "==============================================="
echo " Script Made by LostDude."
echo " THIS IS NOT OFFICIAL SCRIPT BY NIT."
echo " This Script will fix the NIT Composer Issues"
echo "==============================================="
echo ""

# Auto-confirm to continue without prompt
confirm="y"

if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
    echo "Installation aborted."
    exit 1
fi

echo "Updating package lists..."
apt update

echo "Installing PHP 8.2 and required extensions..."
apt install -y php8.2 php8.2-cli php8.2-fpm php8.2-mysql php8.2-zip php8.2-xml php8.2-bcmath php8.2-mbstring php8.2-curl php8.2-intl php8.2-gd php8.2-opcache php8.2-simplexml git unzip

echo "Setting PHP 8.2 as default CLI..."
update-alternatives --install /usr/bin/php php /usr/bin/php8.2 82
update-alternatives --set php /usr/bin/php8.2

echo "Downloading composer.phar..."
curl -sS https://raw.githubusercontent.com/lostdude01/Pterodactyl-Fix/main/composer.phar -o /usr/local/bin/composer.phar
chmod +x /usr/local/bin/composer.phar

echo "Creating composer executable wrapper..."
cat > /usr/local/bin/composer << 'EOF'
#!/bin/bash
php /usr/local/bin/composer.phar "$@"
EOF
chmod +x /usr/local/bin/composer

echo "Cleaning up..."

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
