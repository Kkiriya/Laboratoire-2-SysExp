# Laboratoire 2 - Introduction aux Réseaux

## Systèmes d'exploitation - Collège de Maisonneuve

---

**Nom :** Valade

**Prénom :** Émile

**Groupe :** 25604

**Lien GitHub du devoir** : https://github.com/Kkiriya/Laboratoire-2-SysExp

## **Date de remise :** Jeudi 13 février 2026

## Barème récapitulatif

| Section                         | Points  | Note     |
| ------------------------------- | ------- | -------- |
| Partie 1 : Questions théoriques | 20      | /20      |
| Partie 2 : Commandes réseau     | 25      | /25      |
| Partie 3 : Analyse Wireshark    | 25      | /25      |
| Partie 4 : Script Bash          | 30      | /30      |
| **TOTAL**                       | **100** | **/100** |

---

# Partie 1 : Questions théoriques (20 points)

## Question 1 - Modèle OSI (5 points)

### a) Complétez le tableau (2.5 pts)

| Protocole/Élément | N° Couche | Nom de la couche |
| ----------------- | --------- | ---------------- |
| HTTP              | 7         | Application      |
| Adresse IP        | 3         | Réseau           |
| Câble Ethernet    | 2         | Liaison          |
| TCP               | 4         | Transport        |
| Adresse MAC       | 2         | Liaison          |

### b) Différence entre le modèle OSI et TCP/IP (2.5 pts)

```
Votre réponse :
La différence est que le modèle TCP/IP est le modèle pratique utilisé, tandis que le modèle OSI est plutôt une référence théorique. En pratique, il est plus simple et plus efficace d’effectuer plusieurs opérations de couches différentes dans la même étape, et c’est ce que fait le modèle TCP/IP.
```

---

## Question 2 - Adresses IP (5 points)

### a) Adresses privées ou publiques (2.5 pts)

| Adresse IP    | Privée / Publique |
| ------------- | ----------------- |
| 192.168.1.50  | privée            |
| 8.8.8.8       | publique          |
| 10.0.0.1      | privée            |
| 172.20.5.100  | privée            |
| 200.100.50.25 | publique          |

### b) Qu'est-ce qu'un masque de sous-réseau ? À quoi sert-il ? (2.5 pts)

```
Votre réponse :
Le masque de sous-réseau est une suite de bits qui permet d’identifier la portion réseau et la portion hôte d’une adresse IP. Il sert à déterminer quelles adresses IP appartiennent au même réseau.

Par exemple, avec l’adresse [192.168.1.100/24], le masque contient 24 bits à 1 et 8 bits à 0, ce qui nous donne : [11111111.11111111.11111111.00000000] (soit [255.255.255.0]).

Le masque indique donc que les 3 premiers octets appartiennent à la partie réseau et que le dernier octet correspond à la partie hôte. L’adresse du réseau est donc 192.168.1.0.
```

---

## Question 3 - Protocoles (10 points)

### a) Expliquez le fonctionnement du protocole ARP. Pourquoi est-il nécessaire ? (3 pts)

```
Votre réponse :
Le protocole ARP (Address Resolution Protocol) permet de traduire une adresse IP en adresse MAC sur un réseau local. Lorsqu’une machine veut communiquer avec une adresse IP, elle vérifie d’abord sa table ARP pour voir si une adresse MAC est déjà associée. Si ce n’est pas le cas, elle envoie une requête ARP en diffusion (broadcast) sur le réseau pour demander quelle machine possède cette adresse IP. La machine concernée répond avec son adresse MAC, qui est ensuite enregistrée dans la table ARP.

Le protocole ARP est nécessaire parce que la transmission des données sur le réseau local se fait avec les adresses MAC. L’adresse IP sert à l’identification et au routage logique, mais la livraison locale des données utilise les adresses MAC.
```

### b) Différence entre une requête DNS de type A et de type AAAA ? (2 pts)

```
Votre réponse :
Une requête DNS de type A retourne une adresse IPv4 associée à un nom de domaine.
Une requête DNS de type AAAA retourne une adresse IPv6 associée à un nom de domaine.

```

### c) Expliquez ce que fait la commande `ping` au niveau du protocole ICMP. Quels types de messages sont échangés ? (3 pts)

```markdown
Votre réponse :
La commande ping utilise le protocole ICMP pour tester la connectivité entre deux machines sur un réseau. Elle envoie des messages de requête (_Echo Request_) à l’adresse IP cible. Si la machine est joignable, elle répond avec des messages de réponse (_Echo Reply_). Cela permet de vérifier si l’hôte est accessible et de mesurer la latence des paquets.
```

### d) Sur quel port et avec quel protocole de transport fonctionne DNS par défaut ? Pourquoi ce choix ? (2 pts)

```
Votre réponse :
DNS fonctionne par défaut sur le port 53 avec le protocole de transport UDP.

C’est le cas car le protocole UDP est plus rapide et plus léger que le protocole TCP, et cela est suffisant pour la majorité des requêtes DNS, qui sont légères et nécessitent peu d’échanges.
```

---

# Partie 2 : Commandes réseau (25 points)

## Exercice 1 : Configuration réseau (10 points)

_PS: J’utilise une machine virtuelle sous Windows pour les tests nécessitant WSL, et sinon j’utilise ma machine Linux._

### a) Configuration réseau

**Commande utilisée :**

```bash
ip addr show
```

**Adresse IP :**

```
Linux: 10.0.170
WSL: 10.0.0.2.15
```

**Masque de sous-réseau :**

```
/24 -> 255.255.255.0
```

**Nom de l'interface réseau principale :**

```
Linux: enp5s0
WSL: eth0
```

### b) Passerelle par défaut

**Commande utilisée :**

```bash
ip route
```

**Adresse de la passerelle :**

```
Linux: 10.0.0.1
WSL: 10.0.2.2
```

### c) Serveurs DNS

**Commande utilisée :**

```bash
cat /etc/resolv.conf
```

**Serveurs DNS configurés :**

```
Linux: nameserver 127.0.0.53
WSL: nameserver 10.0.2.3
```

> 📸 **Capture d'écran 1** : Insérez votre capture montrant la configuration réseau
>
> ![alt text](captures/partie2-Exercice1-config-reseau-Linux.jpg)
> ![alt text](captures/partie2-Exercice1-config-reseau-WSL.jpg)

---

## Exercice 2 : Tests de connectivité avec ping (8 points)

### a) Ping vers localhost (127.0.0.1) - 4 paquets

**Commande exacte utilisée :**

```bash
ping -c 4 127.0.0.1
```

**Résultat (succès/échec) :**

```
Linux: 4 succès, 0 échec
WSL: 4 succès, 0 échec
```

**Temps moyen de réponse :**

```
Linux: 0.026 ms
WSL: 0.366 ms
```

### b) Ping vers la passerelle - 4 paquets

**Résultat (succès/échec) :**

```
Linux: 4 succès, 0 échec
WSL: 4 succès, 0 échec
```

**Temps moyen de réponse :**

```
Linux: 1.456 ms
WSL: 0.282 ms
```

### c) Ping vers 8.8.8.8 - 4 paquets

**Résultat (succès/échec) :**

```
Linux: 4 succès, 0 échec
WSL: 4 succès, 0 échec
```

**Temps moyen de réponse :**

```
Linux: 16.409 ms
WSL: 13.946 ms
```

### d) Si le ping vers 8.8.8.8 fonctionne mais pas vers google.com, quel serait le problème probable ?

```
Votre réponse :
Le problème probable serait une résolution DNS qui échoue, c’est-à-dire que le système n’arrive pas à traduire le nom de domaine en adresse IP.
```

> 📸 **Capture d'écran 2** : Insérez votre capture des tests ping
>
> ![alt text](<captures/Partie 2/Exercice 2/test_ping_Linux.jpg>)
> ![alt text](<captures/Partie 2/Exercice 2/test_ping_WSL.jpg>)

---

## Exercice 3 : Table ARP et résolution DNS (7 points)

### a) Table ARP

_PS : La commande ARP ne fonctionne pas sur ma VM à cause de la double virtualisation causée par l’ajout de WSL dans le mix._

**Commande utilisée :**

```bash
arp -a
ip neigh show
```

**Nombre d'entrées :**

```
arp -a: 12 lignes
ip neigh show: 12 lignes
```

**Une entrée (IP et MAC) :**

```
10.0.0.54 -> 54:67:e6:b1:62:60
```

### b) Requête DNS pour www.collegemaisonneuve.qc.ca

_PS : L’adresse web fournie n’est pas correcte, elle retourne une erreur **server can't find www.collegemaisonneuve.qc.ca
: NXDOMAIN**. J’ai donc pris la liberté de me procurer la bonne adresse du Collège Maisonneuve et de répondre aux questions avec celle-ci._

**Commande utilisée :**

```bash
nslookup www.cmaisonneuve.qc.ca
```

**Adresse IP obtenue :**

```
206.167.46.15
```

### c) Commande `dig` pour github.com - TTL

**TTL (Time To Live) de l'enregistrement :**

```
Linux: 60 s
WSL: 5 s
```

> 📸 **Capture d'écran 3** : Insérez votre capture de la table ARP et d'une requête DNS
>
> ![alt text](<captures/Partie 2/Exercice 3/ARP_table_linux.jpg>)
> ![alt text](<captures/Partie 2/Exercice 3/requete_DNS_cegep_maisonneuve_WSL.jpg>)

---

# Partie 3 : Analyse Wireshark (25 points)

## Exercice 4 : Capture et analyse ICMP (10 points)

### Analyse d'un paquet "Echo (ping) request"

| Information             | Valeur observée |
| ----------------------- | --------------- |
| Adresse MAC source      |                 |
| Adresse MAC destination |                 |
| Adresse IP source       |                 |
| Adresse IP destination  |                 |
| Type ICMP (numéro)      |                 |
| Code ICMP               |                 |

### Question : Différence entre le Type ICMP d'un "Echo Request" et d'un "Echo Reply" ?

```
Votre réponse :


```

> 📸 **Capture d'écran 4** : Capture Wireshark montrant les paquets ICMP avec le détail d'un paquet
>
> ![Capture 4](captures/capture4_wireshark_icmp.png)

---

## Exercice 5 : Capture et analyse DNS (8 points)

### Analyse de la requête et réponse DNS

| Information                | Valeur observée |
| -------------------------- | --------------- |
| Port source (requête)      |                 |
| Port destination (requête) |                 |
| Protocole de transport     |                 |
| Type de requête DNS        |                 |
| Adresse IP dans la réponse |                 |

> 📸 **Capture d'écran 5** : Capture Wireshark montrant la requête et réponse DNS
>
> ![Capture 5](captures/capture5_wireshark_dns.png)

---

## Exercice 6 : Capture et analyse ARP (7 points)

### Tableau d'un échange ARP observé

| Information             | ARP Request | ARP Reply |
| ----------------------- | ----------- | --------- |
| Adresse MAC source      |             |           |
| Adresse MAC destination |             |           |
| Adresse IP recherchée   |             |           |

### Question : Pourquoi l'adresse MAC de destination dans l'ARP Request est-elle `ff:ff:ff:ff:ff:ff` ?

```
Votre réponse :


```

> 📸 **Capture d'écran 6** : Capture Wireshark montrant l'échange ARP
>
> ![Capture 6](captures/capture6_wireshark_arp.png)

---

# Partie 4 : Script de diagnostic réseau (30 points)

## Exercice 7 : Création du script

### Informations sur votre script

**Nom du fichier :** `diagnostic_reseau.sh`

### Checklist des fonctionnalités implémentées

Cochez les fonctionnalités que vous avez implémentées :

- [ ] Affichage du nom de l'hôte
- [ ] Affichage de la date et heure
- [ ] Affichage de la version du système
- [ ] Affichage de l'adresse IP locale
- [ ] Affichage de l'adresse de la passerelle
- [ ] Affichage des serveurs DNS
- [ ] Test de connectivité localhost
- [ ] Test de connectivité passerelle
- [ ] Test de connectivité Internet (8.8.8.8)
- [ ] Test de résolution DNS (google.com)
- [ ] Affichage de la table ARP
- [ ] Résolution DNS de 2+ domaines
- [ ] Gestion des erreurs (messages si échec)
- [ ] Commentaires dans le code
- [ ] Affichage clair avec titres de sections

### Difficultés rencontrées (optionnel)

```
Décrivez ici les difficultés que vous avez rencontrées lors de la création du script :


```

> 📸 **Capture d'écran 7** : Capture montrant l'exécution de votre script
>
> ![Capture 7](captures/capture7_script_execution.png)

---

# Récapitulatif de la remise

## Fichiers à inclure dans votre projet

Vérifiez que votre projet contient :

- [ ] `reponse.md` (ce fichier complété)
- [ ] `diagnostic_reseau.sh` (votre script)
- [ ] `captures/capture1_config_reseau.png`
- [ ] `captures/capture2_ping.png`
- [ ] `captures/capture3_arp_dns.png`
- [ ] `captures/capture4_wireshark_icmp.png`
- [ ] `captures/capture5_wireshark_dns.png`
- [ ] `captures/capture6_wireshark_arp.png`
- [ ] `captures/capture7_script_execution.png`

---

---

_Bon travail !_
