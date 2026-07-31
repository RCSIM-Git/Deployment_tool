# RCSIM RPi5 Deployment Tool

Deployment utility for the **RCSIM (Race Ready Autonomous System)** software stack targeting Raspberry Pi 5 single-board computers equipped with Hailo-8L accelerators. The application provides a modern web browser interface (Web GUI) powered by Flask, alongside a legacy Tkinter-based fallback interface.

---

## 📋 Table of Contents
1. [Key Features](#-key-features)
2. [Requirements & Dependencies](#-requirements--dependencies)
3. [Project Structure](#-project-structure)
4. [Build Process](#-build-process)
5. [Configuration](#-configuration)
   - [deployment_settings.json Structure](#deployment_settingsjson-structure)
   - [Connection & SSH Settings](#connection--ssh-settings)
   - [RTK & NTRIP Configuration](#rtk--ntrip-configuration)
   - [Hardware Configuration](#hardware-configuration)
   - [Communication & MAVLink](#communication--mavlink)
6. [Usage Instructions](#-usage-instructions)

---

## 🚀 Key Features

*   **Automated Deployment:** Automatically archives local source code, securely uploads it via SFTP to the Raspberry Pi 5, triggers remote Docker image builds, and spawns system containers/services.
*   **SSH Credentials Management:** Supports both simple password authentication and private SSH key authentication (including keys protected by a passphrase).
*   **Advanced Hardware Tuning:** Configure IMU drivers, interfaces, and baudrates for GPS, LiDAR, and ExpressLRS receiver directly from the Web GUI.
*   **RTK / NTRIP Integration:** Full parameterization of NTRIP base stations and RTK correction feeds for high-precision GPS coordinates.
*   **Remote Diagnostics:** Real-time monitoring of RPi 5 CPU load, temperature, memory usage, and the status of system docker containers/services.
*   **Flexible Communication:** Set communication protocols (e.g., NATIVE, MAVLINK) and customize system IDs and telemetry frequency (Hz).

---

## 🛠️ Requirements & Dependencies

Before running the deployment tool, ensure the following dependencies are installed:
*   **Python 3.8+** (Python 3.10+ recommended on Windows)
*   **Required Python Packages:**
    ```bash
    pip install flask paramiko requests cryptography
    ```
*   **For packaging the application into a standalone executable (.exe):**
    ```bash
    pip install pyinstaller pyinstaller-hooks-contrib
    ```

---

## 📂 Project Structure

```
RCSIM_deployment_tool/
├── core/
│   ├── build_deployment.py       # PyInstaller invocation script
│   ├── config_manager.py         # Handles settings management and localization
│   ├── deployment_logic.py       # Core SSH/SFTP transfer and remote command logic
│   ├── deployment_settings.json  # Saved local settings
│   └── service_monitor.py        # Background thread tracking Raspberry Pi status
├── ui/
│   ├── locales/                  # Localized translation catalogs (pl, en)
│   └── ui_components.py          # Legacy Tkinter UI components (fallback)
├── web/                          # Static Web GUI assets and templates (HTML/CSS/JS)
├── RCsimDeployment.spec          # PyInstaller spec file for compiling the EXE
├── RCsimRPi5deploymentapp.py     # Main application launcher entrypoint
├── build_deployment.bat          # Windows batch script to build the executable
├── README.md                     # Polish documentation (PL)
└── README_EN.md                  # This documentation file (EN)
```

---

## 🏗️ Build Process

The RCSIM deployment utility can be compiled into a single, standalone `.exe` executable for Windows. This lets operators run the tool without needing a Python interpreter installed on the host machine.

### Step-by-step Packaging:
1. Run the batch script **`build_deployment.bat`** (optionally as Administrator).
2. The script will automatically:
   - Verify that `PyInstaller`, `paramiko`, and `cryptography` are installed, fetching them via pip if missing.
   - Execute `core/build_deployment.py` to initiate the packaging.
   - PyInstaller parses the configuration from `RCsimDeployment.spec` to correctly bundle the static Web UI files, localization files, and libraries (like `paramiko`, `cryptography`, and `nacl`).
3. Once completed successfully, the built binary is located at:
   ```
   RCSIM_deployment_tool/dist/RCsimDeployment.exe
   ```

---

## ⚙️ Configuration

All deployment configurations and hardware preferences are saved locally inside **`core/deployment_settings.json`** (or next to the `.exe` file once compiled).

### `deployment_settings.json` Structure

Below is the template containing all available configuration fields:

```json
{
    "rpi_host": "192.168.1.100",
    "rpi_user": "rcsim",
    "rpi_pass": "ssh_password_here",
    "project_source": "C:\\Path\\To\\Your\\RCSIMDEPLOY",
    "pc_tailscale_ip": "100.x.y.z",
    "use_rtk": true,
    "ntrip_user": "ntrip_username",
    "ntrip_pass": "ntrip_password",
    "ntrip_host": "rtk2go.com",
    "ntrip_port": "2101",
    "ntrip_mount": "BaseStationMountpoint",
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
    "language": "English",
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

### Connection & SSH Settings
*   `rpi_host`: Target Raspberry Pi 5 IP address or hostname.
*   `rpi_user`: SSH login username (e.g., `rcsim` or `pi`).
*   `rpi_pass`: SSH login password.
*   `rpi_use_key`: Whether to log in using an SSH private key (`true`/`false`).
*   `rpi_key_path`: Absolute or relative path to the private key file.
*   `rpi_key_passphrase`: Optional passphrase to decrypt the private key.

### RTK & NTRIP Configuration
*   `use_rtk`: Toggles GPS RTK corrections.
*   `ntrip_host` / `ntrip_port`: URL and port of the NTRIP correction service provider.
*   `ntrip_user` / `ntrip_pass`: Credentials to authenticate against the NTRIP caster.
*   `ntrip_mount`: The specific mountpoint of the correction station.

### Hardware Configuration
*   `imu_driver`: Selected IMU sensor driver (e.g., `native_bmx160_bmp388` or `native_mpu9250`).
*   `gps_enabled` / `gps_port` / `gps_baudrate`: Hardware status and UART parameters of the GPS module.
*   `lidar_enabled` / `lidar_port` / `lidar_baudrate`: LiDAR status and serial communication speed.
*   `elrs_enabled` / `elrs_port` / `elrs_baudrate`: Configuration for the ExpressLRS remote control receiver.
*   `camera_type` / `camera_resolution` / `camera_fps` / `camera_bitrate`: CSI/USB camera module type and target stream parameters.

### Communication & MAVLink
*   `comm_mode`: Physical connection mode (e.g., `AUTO`, `UDP`, `SERIAL`).
*   `comm_protocol`: Telemetry stream format (`NATIVE` or `MAVLINK`).
*   `mavlink_system_id`: MAVLink system identifier for the vehicle.
*   `mavlink_throttle_hz`: Telemetry publishing frequency (e.g. 50 Hz).
*   `pc_udp_port` / `rpi_udp_port`: Networking UDP ports used for telemetries and command streams.

---

## 💻 Usage Instructions

### Running from source (locally):
1. Install requirements:
   ```bash
   pip install -r requirements.txt  # Or install manually: flask, paramiko, requests
   ```
2. Start the launcher:
   ```bash
   python RCsimRPi5deploymentapp.py
   ```
3. Open your favorite web browser and go to:
   ```
   http://127.0.0.1:5000
   ```

### Running the standalone executable:
1. Locate `RCsimDeployment.exe` inside the `dist/` directory and execute it.
2. The tool automatically boots the web server and opens the browser interface.
3. Configure the connection, path, and hardware fields, then click **"Start Deployment"**.
