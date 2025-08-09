#!/bin/bash
set -e

echo "==============================================="
echo " Script Made by LostDude."
echo " THIS IS NOT OFFICIAL SCRIPT BY NIT."
echo " This Script will fix the NIT Composer Issues"
echo "==============================================="
echo ""

# No prompt, auto continue
confirm="y"

if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
    echo "Installation aborted."
    exit 1
fi

echo "Adding SURY PHP repository for PHP 8.3..."
apt update
apt install -y ca-certificates apt-transport-https software-properties-common wget
wget -qO- https://packages.sury.org/php/apt.gpg | tee /etc/apt/trusted.gpg.d/php.gpg >/dev/null
echo "deb https://packages.sury.org/php/ bookworm main" | tee /etc/apt/sources.list.d/php.list
apt update

echo "Installing PHP 8.3 and required extensions..."
apt install -y php8.3 php8.3-cli php8.3-fpm php8.3-mysql php8.3-zip php8.3-xml php8.3-bcmath php8.3-mbstring php8.3-curl php8.3-intl php8.3-gd php8.3-opcache php8.3-simplexml git unzip

echo "Setting PHP 8.3 as default CLI..."
update-alternatives --install /usr/bin/php php /usr/bin/php8.3 83
update-alternatives --set php /usr/bin/php8.3

echo "Downloading composer.phar..."
curl -sS https://raw.githubusercontent.com/lostdude01/Pterodactyl-Fix/main/composer.phar -o /usr/local/bin/composer.phar
chmod +x /usr/local/bin/composer.phar

echo "Creating composer executable wrapper..."
cat > /usr/local/bin/composer << 'EOF'
#!/bin/bash
php /usr/local/bin/composer.phar "$@"
EOF
chmod +x /usr/local/bin/composer

if ! echo "$PATH" | grep -q "/usr/local/bin"; then
    echo "Adding /usr/local/bin to PATH..."
    # Add it to ~/.bashrc if not already present
    if ! grep -q 'export PATH=/usr/local/bin:$PATH' ~/.bashrc; then
        echo 'export PATH=/usr/local/bin:$PATH' >> ~/.bashrc
    fi
    # Also update current session PATH
    export PATH="/usr/local/bin:$PATH"
else
    echo "/usr/local/bin already in PATH."
fi

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
