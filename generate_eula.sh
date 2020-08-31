#!/bin/bash

now=$(date)

cat > eula.txt << EOF
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#$now
eula=true
EOF