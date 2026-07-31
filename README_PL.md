# RCSIM RPi5 Deployment Tool - Narzędzie Wdrożeniowe

Narzędzie wdrożeniowe dla stosu oprogramowania **RCSIM (Race Ready Autonomous System)** na komputery jednopłytkowe Raspberry Pi 5 z akceleratorem Hailo-8L. Aplikacja udostępnia nowoczesny interfejs graficzny w przeglądarce (Web GUI) oparty na technologii Flask oraz opcjonalny interfejs legacy oparty na Tkinter.

---

## 📋 Spis treści
1. [Główne Funkcje](#-główne-funkcje)
2. [Wymagania i Zależności](#-wymagania-i-zależności)
3. [Struktura Projektu](#-struktura-projektu)
4. [Proces Budowania Aplikacji (Build Process)](#-proces-budowania-aplikacji-build-process)
5. [Konfiguracja (Configuration)](#-konfiguracja-configuration)
   - [Struktura pliku deployment_settings.json](#struktura-pliku-deployment_settingsjson)
   - [Parametry Połączenia i SSH](#parametry-połączenia-i-ssh)
   - [Konfiguracja RTK & NTRIP](#konfiguracja-rtk--ntrip)
   - [Konfiguracja Sprzętowa (Hardware)](#konfiguracja-sprzętowa-hardware)
   - [Komunikacja i MAVLink](#komunikacja-i-mavlink)
6. [Instrukcja Użycia](#-instrukcja-użycia)

---

## 🚀 Główne Funkcje

*   **Automatyczne Wdrażanie (Automated Deployment):** Archiwizacja lokalnego projektu źródłowego, bezpieczny transfer SFTP na Raspberry Pi 5, automatyczne budowanie kontenerów Docker oraz uruchamianie usług systemowych.
*   **Zarządzanie Połączeniem SSH:** Obsługa tradycyjnego logowania hasłem oraz kluczami SSH (w tym passphrase do klucza prywatnego).
*   **Zaawansowana Konfiguracja Sprzętowa:** Bezpośrednie ustawianie sterowników IMU, portów oraz prędkości transmisji (baudrate) dla GPS, LiDAR i odbiornika ELRS z poziomu Web GUI.
*   **Integracja RTK / NTRIP:** Pełna parametryzacja stacji bazowych NTRIP i poprawek RTK dla precyzyjnego pozycjonowania GPS.
*   **Zdalna Diagnostyka:** Monitorowanie statusu usług systemowych, zużycia procesora, pamięci i temperatury Raspberry Pi 5 w czasie rzeczywistym.
*   **Elastyczna Komunikacja:** Wybór protokołów i trybów przesyłania danych (np. NATIVE, MAVLINK) wraz z konfiguracją system_id i częstotliwości odświeżania telemetrii.

---

## 🛠️ Wymagania i Zależności

Przed rozpoczęciem upewnij się, że posiadasz zainstalowane następujące oprogramowanie:
*   **Python 3.8+** (rekomendowany Python 3.10 lub nowszy na Windows)
*   **Biblioteki Python:**
    ```bash
    pip install flask paramiko requests cryptography
    ```
*   **Do budowania wersji wykonywalnej (.exe):**
    ```bash
    pip install pyinstaller pyinstaller-hooks-contrib
    ```

---

## 📂 Struktura Projektu

```
RCSIM_deployment_tool/
├── core/
│   ├── build_deployment.py       # Skrypt wywołujący PyInstallera
│   ├── config_manager.py         # Zarządzanie konfiguracją i lokalizacją
│   ├── deployment_logic.py       # Logika SSH, SFTP, transferu i wdrażania
│   ├── deployment_settings.json  # Zapisane ustawienia aplikacji
│   └── service_monitor.py        # Wątek monitorowania statusu RPi
├── ui/
│   ├── locales/                  # Pliki tłumaczeń (pl, en)
│   └── ui_components.py          # Legacy interfejs Tkinter (fallback)
├── web/                          # Pliki statyczne i szablony Web GUI (HTML/CSS/JS)
├── RCsimDeployment.spec          # Specyfikacja PyInstaller dla budowania EXE
├── RCsimRPi5deploymentapp.py     # Główny plik startowy launchera
├── build_deployment.bat          # Skrypt wsadowy do budowania EXE na Windows
├── README.md                     # Niniejsza dokumentacja (PL)
└── README_EN.md                  # Dokumentacja w języku angielskim (EN)
```

---

## 🏗️ Proces Budowania Aplikacji (Build Process)

Aplikacja wdrożeniowa RCSIM może zostać skompilowana do pojedynczego, niezależnego pliku wykonywalnego `.exe` dla systemu Windows. Eliminuje to konieczność posiadania zainstalowanego środowiska Python na maszynie operatora.

### Budowanie krok po kroku:
1. Uruchom skrypt wsadowy **`build_deployment.bat`** jako administrator lub zwykły użytkownik.
2. Skrypt automatycznie:
   - Sprawdzi dostępność pakietów `PyInstaller`, `paramiko` oraz `cryptography` i zainstaluje je w razie potrzeby.
   - Uruchomi kompilator poprzez skrypt pomocniczy `core/build_deployment.py`.
   - PyInstaller wykorzysta plik konfiguracyjny `RCsimDeployment.spec`, aby poprawnie spakować pliki statyczne Web UI, lokalizacje i wszystkie zależności biblioteczne (m.in. `paramiko`, `cryptography`, `nacl`).
3. Po pomyślnym zakończeniu procesu, gotowy plik wykonywalny znajdziesz w katalogu:
   ```
   RCSIM_deployment_tool/dist/RCsimDeployment.exe
   ```

---

## ⚙️ Konfiguracja (Configuration)

Wszystkie parametry wdrożenia i ustawień sprzętowych są przechowywane w pliku **`core/deployment_settings.json`** (lub bezpośrednio obok pliku `.exe` po skompilowaniu).

### Struktura pliku `deployment_settings.json`

Poniżej znajduje się domyślny szablon konfiguracji:

```json
{
    "rpi_host": "192.168.1.100",
    "rpi_user": "rcsim",
    "rpi_pass": "twóje_hasło_ssh",
    "project_source": "C:\\Sciezka\\Do\\Projektu\\RCSIMDEPLOY",
    "pc_tailscale_ip": "100.x.y.z",
    "use_rtk": true,
    "ntrip_user": "uzytkownik_ntrip",
    "ntrip_pass": "haslo_ntrip",
    "ntrip_host": "rtk2go.com",
    "ntrip_port": "2101",
    "ntrip_mount": "StacjaBazowa",
    "imu_driver": "native_bmx160_bmp388",
    "gps_enabled": true,
    "gps_port": "/dev/ttyAMA0",
    "gps_baudrate": "115200",
    "camera_port": "cam0",
    "camera_resolution": "1920x1080",
    "camera_fps": "30",
    "camera_bitrate": "10 Mbps",
    "camera_type": "imx219",
    "lidar_enabled": true,
    "lidar_port": "/dev/ttyUSB0",
    "lidar_baudrate": "115200",
    "elrs_enabled": true,
    "elrs_port": "/dev/ttyAMA3",
    "elrs_baudrate": "57600",
    "language": "Polski",
    "rpi_use_key": false,
    "rpi_key_path": "",
    "rpi_key_passphrase": "",
    "pc_udp_port": "12347",
    "rpi_udp_port": "12346",
    "comm_mode": "AUTO",
    "comm_protocol": "NATIVE",
    "mavlink_system_id": "1",
    "mavlink_throttle_hz": "50",
    "fast_mode": false,
    "app_type": "RCSIM_DOCKER"
}
```

### Parametry Połączenia i SSH
*   `rpi_host`: Adres IP lub nazwa hosta docelowego Raspberry Pi 5.
*   `rpi_user`: Nazwa użytkownika SSH (np. `rcsim` lub `pi`).
*   `rpi_pass`: Hasło SSH.
*   `rpi_use_key`: Czy używać klucza prywatnego SSH zamiast hasła (`true`/`false`).
*   `rpi_key_path`: Ścieżka do pliku klucza prywatnego (np. id_rsa).
*   `rpi_key_passphrase`: Hasło odblokowujące klucz prywatny (jeśli wymagane).

### Konfiguracja RTK & NTRIP
*   `use_rtk`: Włączenie poprawek RTK dla GPS.
*   `ntrip_host` / `ntrip_port`: Adres i port serwera NTRIP (np. RTK2go lub komercyjnego dostawcy poprawek ASG-EUPOS).
*   `ntrip_user` / `ntrip_pass`: Dane uwierzytelniające klienta NTRIP.
*   `ntrip_mount`: Nazwa punktu montowania stacji referencyjnej (Mountpoint).

### Konfiguracja Sprzętowa (Hardware)
*   `imu_driver`: Sterownik jednostki IMU (np. `native_bmx160_bmp388`, `native_mpu9250`).
*   `gps_enabled` / `gps_port` / `gps_baudrate`: Włączenie i parametry magistrali UART dla odbiornika GPS.
*   `lidar_enabled` / `lidar_port` / `lidar_baudrate`: Włączenie i parametry komunikacji LiDAR.
*   `elrs_enabled` / `elrs_port` / `elrs_baudrate`: Parametry połączenia z odbiornikiem ExpressLRS.
*   `camera_type` / `camera_resolution` / `camera_fps` / `camera_bitrate`: Specyfikacja kamery CSI/USB i parametry kodowania strumienia wideo.

### Komunikacja i MAVLink
*   `comm_mode`: Tryb komunikacji (np. `AUTO`, `UDP`, `SERIAL`).
*   `comm_protocol`: Protokół danych telemetrycznych (`NATIVE` lub `MAVLINK`).
*   `mavlink_system_id`: Identyfikator systemowy urządzenia w sieci MAVLink.
*   `mavlink_throttle_hz`: Częstotliwość wysyłania ramek telemetrycznych (np. 50 Hz).
*   `pc_udp_port` / `rpi_udp_port`: Porty UDP używane do strumieniowania telemetrii i komend sterujących.

---

## 💻 Instrukcja Użycia

### Uruchomienie lokalne (ze źródła):
1. Zainstaluj wymagane pakiety:
   ```bash
   pip install -r requirements.txt  # Lub zainstaluj ręcznie: flask, paramiko, requests
   ```
2. Uruchom skrypt główny:
   ```bash
   python RCsimRPi5deploymentapp.py
   ```
3. Otwórz przeglądarkę internetową i wejdź pod adres:
   ```
   http://127.0.0.1:5000
   ```

### Uruchomienie z wersji wykonywalnej:
1. Przejdź do folderu `dist/` i uruchom plik `RCsimDeployment.exe`.
2. Aplikacja automatycznie otworzy okno przeglądarki z graficznym interfejsem konfiguracyjnym.
3. Wprowadź parametry połączenia SSH, wybierz ścieżkę do projektu źródłowego RCSIM, dostosuj parametry sprzętu i kliknij **"Start Deployment"**.
