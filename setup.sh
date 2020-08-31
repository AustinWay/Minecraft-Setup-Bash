#!/bin/bash
# https://linuxize.com/post/how-to-install-minecraft-server-on-ubuntu-18-04/

# =============
# Prerequisites
# =============

# Update packages 
sudo apt-get update
# Install build essential
sudo apt-get install git build-essential -y
# Install GNU Compiler Collection
sudo apt-get install gcc -y




# ===================================
# Installing Java Runtime Environment
# ===================================

# Install Java JRE
sudo apt-get install default-jre -y
# Install Java JDK
sudo apt-get install default-jdk -y
# Insatll Java Runtime Environment
sudo apt install openjdk-14-jre-headless -y



# ==============================
# Installing Minecraft on Ubuntu
# ==============================

# Create a minecraft user
sudo useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft
# set password for minecraft (optional) 
# sudo passwd minecraft
# swtich to minecraft user
sudo su - minecraft
# make three directories
mkdir -p ~/{backups,tools,server}

cd ~/tools && git clone https://github.com/Tiiffi/mcrcon.git
cd ~/tools/mcrcon
gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c
./mcrcon -h


wget https://launcher.mojang.com/v1/objects/c5f6fb23c3876461d46ec380421e42b289789530/server.jar -P ~/server
cd ~/server
java -Xmx1024M -Xms512M -jar server.jar nogui

now=$(date)

cat > eula.txt << EOF
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#$now
eula=true
EOF

cat > server.propterties << EOF
#Minecraft server properties
#$now
spawn-protection=16
max-tick-time=60000
query.port=25565
generator-settings=
sync-chunk-writes=true
force-gamemode=false
allow-nether=true
enforce-whitelist=false
gamemode=survival
broadcast-console-to-ops=true
enable-query=false
player-idle-timeout=0
difficulty=easy
spawn-monsters=true
broadcast-rcon-to-ops=true
op-permission-level=4
pvp=true
entity-broadcast-range-percentage=100
snooper-enabled=true
level-type=default
hardcore=false
enable-status=true
enable-command-block=false
max-players=20
network-compression-threshold=256
resource-pack-sha1=
max-world-size=29999984
function-permission-level=2
rcon.port=25575
rcon.password=strong-password
enable-rcon=true
server-port=25565
server-ip=
spawn-npcs=true
allow-flight=false
level-name=world
view-distance=10
resource-pack=
spawn-animals=true
white-list=false
generate-structures=true
max-build-height=256
online-mode=true
level-seed=
use-native-transport=true
prevent-proxy-connections=false
enable-jmx-monitoring=false
rate-limit=0
motd=A Minecraft Server
EOF




# ==========================
# Creating Systemd Unit File
# ==========================

# change directory
cd /etc/systemd/system/
# create file minecraft.service
cat > minecraft.service << EOF
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=minecraft
Nice=1
KillMode=none
SuccessExitStatus=0 1
ProtectHome=true
ProtectSystem=full
PrivateDevices=true
NoNewPrivileges=true
WorkingDirectory=/opt/minecraft/server
ExecStart=/usr/bin/java -Xmx1024M -Xms512M -jar server.jar nogui
ExecStop=/opt/minecraft/tools/mcrcon/mcrcon -H 127.0.0.1 -P 25575 -p strong-password stop

[Install]
WantedBy=multi-user.target
EOF


# reload systemd manager configuration
sudo systemctl daemon-reload
# start minecraft
sudo systemctl start minecraft
#check service status
sudo systemctl status minecraft
#start minecraft on system boot up
sudo systemctl enable minecraft




# ==================
# Adjusting Firewall
# ==================

# allow traffic on the default Minecraft port 25565
sudo ufw allow 25565/tcp




# ==================
# Configure Backups
# ==================

# switch to minecraft user
sudo su - minecraft

