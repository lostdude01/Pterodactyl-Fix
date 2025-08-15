### 🚀 NIT Pterodactyl Resolver for KVM-I7 | Made by LostDude . [UPDATED 0.2.0]

> This script was created to address recent NIT routing issues in the US-1 Node. These issues cause the Pterodactyl installer to fail midway through the installation process. By applying this fix, the installation can complete successfully without interruptions.

> Fixes this Error:

```
Installing composer..
curl: (28) Failed to connect to getcomposer.org port 443 after 132797 ms: Connection timed out.
```

### 📕 How to Use installer:

**Install Curl:** ```apt update && apt install curl -y```

**Run Script:** ```curl -sSL https://raw.githubusercontent.com/lostdude01/Pterodactyl-Fix/main/installer.sh | bash```

**Fix Paths:** ```export PATH="/usr/local/bin:$PATH"```

#### ✅ Done! Now you won't get Composer error. Run the Pterodactyl Installer & Enjoy!



