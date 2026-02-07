#!/bin/bash

# Author: Émile
# Date: 2026-02-06
# But: Effectue un diagnostic complet du reseau

# COLOURS
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# 1. Afficher les informations systeme

HOSTNAME=$(HOSTNAME) # imprime le nom de l'hote
DATETIME=$(date) # imprime la date et l'heure courante
SYSTEM_VERSION=$(uname -r) # imprime la version du systeme

echo -e "${YELLOW}=== INFORMATIONS SYSTÈME ===${RESET}"
echo -e "${CYAN}Nom de l'hôte:${RESET} ${HOSTNAME}"
echo -e "${CYAN}Date et heure actuelles:${RESET} ${DATETIME}"
echo -e "${CYAN}Version du système:${RESET} ${SYSTEM_VERSION}"

# 2. Afficher la configuration reseau
LOCALIP=$(HOSTNAME -I | awk '{print $1}') # sur windows HOSTNAME -I imprime l'ip locale ainsi get l'ip gateway et l'ip sous ipv6 puisque lon veut lip sous ipv4 seulement on utilise awk
DEFAULT_GATEWAY=$(ip route | awk 'NR ==1 {print $3}') # permet de n'imprimer que le default gateway et rien d'autre
DNS_SERVER=$(awk '/^nameserver/ {print $2}' /etc/resolv.conf) #retourne toute les addresse de serveurs trouver dans le fichier resolv.conf

echo -e "\n${YELLOW}=== CONFIGURATION RÉSEAU ===${RESET}"
echo -e "${CYAN}Adresse IP locale:${RESET} ${LOCALIP}"
echo -e "${CYAN}Adresse de la passerelle par défaut:${RESET} ${DEFAULT_GATEWAY}"
echo -e "${CYAN}Serveurs DNS configurés:${RESET} ${DNS_SERVER}"

# 3. Effectuer des test de connectivite
echo -e "\n${YELLOW}=== TEST DE CONNECTIVITÉ ===${RESET}"

# fonction pour le test de ping et son animation
test_ping() { # $1 est l'ip que l'on veut tester
   ping -c 4 -w 6 "$1" >/dev/null 2>&1 & # >/dev/null 2>&1 fait en sorte que ping s'execute silentieusement
   ping_pid=$! # permet de recuperer le process ID de la derniere commande executer, ce qui nous permet de savoir si elle roule toujour.

   # charcatere pour l'animation
   spinny='|/-\'

    # loop pour afficher du feedback pendant que ping s'execute
    i=0 # pour l'animation
    while kill -0 $ping_pid 2>/dev/null; do # kill -0 $ping_pid ici check si ping est toujour en execution, 2>/dev/null ignore tous message d'erreyr que kill pourrait lancer
        printf "\rPing en cours: "$1" ${YELLOW}%s${RESET}" "${spinny:i++%${#spinny}:1}" # \r retourne au debut de la ligne et overwrite tous texte present, i++%{#spinny} effectue essentiellement modulo 4 sur la valeur du i ce qui permet de loop les valeurs de 0 a 3. ; jutilise printf ici car echo a de la misere avec l'affichage
        sleep 0.2
    done

    wait $ping_pid
    ping_status=$? # $? contient la valeur de sortie de la derniere commande executer dans ce cas c'est la commande de sortie de ping.

    if [ $ping_status -eq 0 ]; then # ici on compare a 0 car c'est le message de sortie qui est equivalent a un success pour la commande ping
        echo -e "\n${GREEN}Ping de l'adresse IP: "$1" réussi!${RESET}"
    else
        echo -e "\n${RED}Ping de l'adresse IP: "$1" echoué!${RESET}"
    fi
}

# Test de localhost
echo -e "${CYAN}Test de localhost (127.0.0.1):${RESET}"
test_ping 127.0.0.1

# Test de la passerelle
echo -e "${CYAN}\nTest de la passerelle (${DEFAULT_GATEWAY}):${RESET}"
test_ping ${DEFAULT_GATEWAY}

# Test d'internet (8.8.8.8)
echo -e "${CYAN}\nTest de l'internet (8.8.8.8):${RESET}"
test_ping 8.8.8.8

# Test de timeout
echo -e "${CYAN}\nTest de timeout (203.0.113.42):${RESET}"
test_ping 203.0.113.42

# Test de resolution DNS avec google.com
echo -e "${CYAN}\nTest de resolution DNS (google.com):${RESET}"
if [ -n "$(dig +short google.com)" ]; then # check si dig retourne une ip
    echo -e "${GREEN}resolution DNS vers google.com réussi!${RESET}"
else
    echo -e "${RED}resolution DNS vers google.com échoué!${RESET}"
fi

# 4. Afficher la table ARP
echo -e "${YELLOW}\n=== AFFICHAGE DE LA TABLE ARP ===${RESET}"
arp -a

# 5. Effectuer des résolution
echo -e "${YELLOW}\n=== EFFECTUER DES RÉSOLUTIONS DNS ===${RESET}"
echo -e "${CYAN}Résolution DNS de google.com:${RESET}"
dig +short google.com

echo -e "${CYAN}\nRésolution DNS de github.com:${RESET}"
dig +short github.com

echo -e "${CYAN}\nRésolution DNS de www.cmaisonneuve.qc.ca:${RESET}"
dig +short www.cmaisonneuve.qc.ca
