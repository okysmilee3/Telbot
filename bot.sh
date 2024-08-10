#!/bin/bash
NS=$( cat /etc/xray/dns )
PUB=$( cat /etc/slowdns/server.pub )
domain=$(cat /etc/xray/domain)
#color
grenbo="\e[92;1m"
NC='\e[0m'
#install
clear
history -c 
rm -fr xbot.sh
rm -fr /usr/bin/lunatic
rm -fr /usr/bin/xdbot.zip*
#color
NC='\e[0m'
u="\033[1;36m"
y="\033[1;93m"
g="\033[1;92m"
r="\033[1;91m"

REPO="https://raw.githubusercontent.com/okysmilee3/Telbot/main/"
NS=$( cat /etc/xray/dns )
PUB=$( cat /etc/slowdns/server.pub )
domain=$(cat /etc/xray/domain)
#install
apt update && apt upgrade
apt install neofetch -y
apt install python3 python3-pip git
cd /usr/bin
wget -q -O bot.zip "${REPO}bot.zip"
unzip bot.zip
mv bot/* /usr/bin
chmod +x /usr/bin/*
rm -rf bot.zip
clear
wget -q -O lunatic.zip "${REPO}lunatic.zip"
unzip lunatic.zip
pip3 install -r lunatic/requirements.txt

clear
echo ""
figlet 'LUNATIC TUNNELING' | lolcat
echo -e ""
echo -e ""
read -e -p "  [*] Input your Bot Token : " bottoken
echo ""
echo ""
read -e -p "  [*] Input Your Id Telegram : " admin
echo -e BOT_TOKEN='"'$bottoken'"' >> /usr/bin/lunatic/var.txt
echo -e ADMIN='"'$admin'"' >> /usr/bin/lunatic/var.txt
echo -e DOMAIN='"'$domain'"' >> /usr/bin/lunatic/var.txt
echo -e PUB='"'$PUB'"' >> /usr/bin/lunatic/var.txt
echo -e HOST='"'$NS'"' >> /usr/bin/lunatic/var.txt
clear

# BOT NOTIP
if [[ ${c} != "0" ]]; then
  echo "${d}" >/etc/bot/${bottoken}
fi
DATADB=$(cat /etc/bot/.bot.db | grep "^#bot#" | grep -w "${bottoken}" | awk '{print $2}')
if [[ "${DATADB}" != '' ]]; then
  sed -i "/\b${user}\b/d" /etc/bot/.bot.db
fi
echo "#bot# ${bottoken} ${admin}" >>/etc/bot/.bot.db



if [ -e /etc/systemd/system/xbot.service ]; then
echo ""
else
rm -fr /etc/systemd/system/xbot.service
fi

cat > /etc/systemd/system/xbot.service << END
[Unit]
Description=Simple Bot Tele By - @xdxl_store
After=network.target

[Service]
WorkingDirectory=/usr/bin
ExecStart=/usr/bin/python3 -m lunatic
Restart=always

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl start lunatic
systemctl enable lunatic
systemctl restart lunatic
cd

# // STATUS SERVICE BOT
bot_service=$(systemctl status lunatic | grep active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $bot_service == "running" ]]; then 
   sts_bot="${g}[ON]${NC}"
else
   sts_bot="${r}[OFF]${NC}"
fi

rm -fr /usr/bin/bot.zip
rm -fr /usr/bin/lunatic.zip
clear
neofetch
echo -e "  ${y} Your Data BOT Info"
echo -e "  ${u}┌───────────────────────────────────┐${NC}"
echo -e "  ${u}│$r Status BOT ${y}=$NC $sts_bot "
echo -e "  ${u}│$r Token BOT  ${y}=$NC $bottoken "
echo -e "  ${u}│$r Admin ID   ${y}=$NC $admin "
echo -e "  ${u}│$r Domain     ${y}=$NC $domain "
echo -e "  ${u}└───────────────────────────────────┘${NC}"
echo -e ""
history -c
read -p "  Press [ Enter ] to back on menu"
m-bot