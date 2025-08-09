#!/bin/bash
set -e

echo "===================================================="
echo " THIS IS NOT OFFICIAL SCRIPT BY KVM-I7."
echo "===================================================="
echo " Script Made by LostDude. Made for E5-Compute"
echo " This Script will fix the NIT Composer Issues"
echo " Script Made for NIT issue Nodes in E5-Compute"
echo "===================================================="
echo " After running this Script use pterodactyl installer"
echo "===================================================="
echo " https://github.com/lostdude01 | Credits: Lostdude"
echo "===================================================="
echo ""

# No prompt, auto continue
confirm="y"

if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
    echo "Installation aborted."
    exit 1
fi

echo "🚀 Downloading Dependencies..."
apt update
apt install -y ca-certificates apt-transport-https software-properties-common wget
wget -qO- https://packages.sury.org/php/apt.gpg | tee /etc/apt/trusted.gpg.d/php.gpg >/dev/null
echo "deb https://packages.sury.org/php/ bookworm main" | tee /etc/apt/sources.list.d/php.list
apt update
curl -sS https://raw.githubusercontent.com/lostdude01/Pterodactyl-Fix/main/composer.phar -o /usr/local/bin/composer.phar
chmod +x /usr/local/bin/composer.phar

echo "🚀 Installing Dependencies..."
apt install -y php8.3 php8.3-cli php8.3-fpm php8.3-mysql php8.3-zip php8.3-xml php8.3-bcmath php8.3-mbstring php8.3-curl php8.3-intl php8.3-gd php8.3-opcache php8.3-simplexml git unzip
echo "Setting PHP 8.3 as default CLI..."
update-alternatives --install /usr/bin/php php /usr/bin/php8.3 83
update-alternatives --set php /usr/bin/php8.3

echo "🚀 Patching Composer..."
cat > /usr/local/bin/composer << 'EOF'
#!/bin/bash
php /usr/local/bin/composer.phar "$@"
EOF
chmod +x /usr/local/bin/composer

echo "🚀 Fixing Path Errors..."
echo 'export PATH=/usr/local/bin:$PATH' >> ~/.bashrc
export COMPOSER_ALLOW_SUPERUSER=1
export PATH="/usr/local/bin:$PATH"

 echo "✅ Installation Completed"
