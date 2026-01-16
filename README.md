# Ansible – zautomatyzowane środowisko webowe na Proxmox VE

Projekt inżynierski polegający na zaprojektowaniu oraz wdrożeniu przykładowego
zautomatyzowanego środowiska webowego z wykorzystaniem narzędzia **Ansible**
oraz hypervisora **Proxmox VE**.
Celem projektu jest demonstracja podejścia **Infrastructure as Code (IaC)**
oraz automatyzacji konfiguracji i utrzymania infrastruktury serwerowej.

---

##Cel projektu

Celem projektu było:
- zaprojektowanie środowiska serwerowego opartego na kontenerach LXC,
- automatyzacja konfiguracji usług z wykorzystaniem Ansible,
- wdrożenie monitoringu infrastruktury,
- implementacja bezobsługowego mechanizmu kopii zapasowych,
- zapewnienie powtarzalności i spójności konfiguracji.

Projekt został zrealizowany w środowisku lokalnym.

---

##Architektura Srodowiska
Środowisko składa się z następujących komponentów:

###Hypervisor
- **Proxmox VE 8.x**
- Kontenery LXC oparte o **Debian 12 (Bookworm)**

###Ansible Control Node
- WSL2 (Windows Subsystem for Linux)
- Debian 12
- Ansible

###Kontenery LXC
| Rola | Usługa | Adres IP |
|----|------|---------|
| Web Server | NGINX | 192.168.0.251 |
| Monitoring | Prometheus | 192.168.0.252 |
| Monitoring | Grafana | 192.168.0.253 |
| Backup Server | rsync + cron | 192.168.0.254 |

Komunikacja pomiędzy Ansible Control Node a kontenerami odbywa się poprzez SSH
z wykorzystaniem uwierzytelniania kluczami publicznymi.

---

##akres funkcjonalny

Projekt obejmuje:

- automatyczną instalację i konfigurację serwera webowego **NGINX**,
- wdrożenie systemu monitoringu **Prometheus + Grafana**,
- instalację **Node Exporter** na wszystkich serwerach,
- wizualizację parametrów systemowych w Grafanie,
- implementację bezobsługowego systemu kopii zapasowych,
- wersjonowanie konfiguracji z wykorzystaniem Git.

---

##Struktura repozytorium
ansible/
├── ansible.cfg
├── inventory.yml
├── site.yml
├── roles/
│ ├── common/
│ ├── nginx/
│ ├── prometheus/
│ ├── grafana/
│ ├── node_exporter/
│ └── backup/
└── README.md


###Najważniejsze pliki:
- `site.yml` – główny playbook uruchamiający wszystkie role,
- `inventory.yml` – definicja hostów i grup,
- `roles/` – role Ansible odpowiadające za konfigurację usług.

---

##Backup danych

System kopii zapasowych:
- obejmuje wyłącznie **dane aplikacyjne**:
  - NGINX: `/var/www/html`
  - Grafana: `/var/lib/grafana`
  - Prometheus: `/var/lib/prometheus`
- wykorzystuje narzędzie **rsync**,
- działa cyklicznie z wykorzystaniem **cron**,
- korzysta z uwierzytelniania SSH opartego na kluczach,
- używa ograniczonych uprawnień sudo wyłącznie do uruchamiania `rsync`.

---

## Testowanie i weryfikacja

Poprawność działania środowiska weryfikowana jest poprzez:
- test połączeń Ansible (`ansible all -m ping`),
- ponowne uruchomienie playbooków (idempotencja),
- dostęp do strony WWW,
- weryfikację statusu targetów w Prometheusie,
- wizualizację danych w Grafanie,
- ręczne i automatyczne testy mechanizmu backupu.

---

##Wymagania

- Proxmox VE 8.x
- Debian 12 (Bookworm)
- Ansible (Control Node)
- Dostęp SSH do kontenerów
- Sieć lokalna 192.168.0.0/24

---

##Autor

Projekt wykonany w ramach **pracy inżynierskiej**
kierunek: Informatyka 

Autor: **Maciej Knutelski**

---

##Możliwe rozszerzenia projektu

- integracja z API Proxmox VE,
- automatyczne tworzenie kontenerów LXC,
- alerting w Prometheus (Alertmanager),
- wysoką dostępność (HA),
- centralny system logów.

---

##Licencja

Projekt edukacyjny – do użytku akademickiego.

