# Windows 11 KVM with Ansible

This project provides a robust framework for managing Windows 11 virtual machines using Ansible, QEMU/KVM, and libvirt. It includes specialized roles for Windows 11 provisioning with UEFI, TPM 2.0, and VirtIO driver support, alongside a general Ubuntu VM manager.

---

## 🏗️ Roles Architecture

### 1. Virtualization Role (`roles/virtualization`)
**Purpose**: Prepares the host system for virtualization.

-   **System Setup**: Installs QEMU, KVM, and Libvirt packages.
-   **Security**: Adds the current user to the `libvirt` group.
-   **Networking**: Configures and starts the `default` Libvirt network (NAT).
-   **Validation**: Verifies hardware virtualization support (VT-x/AMD-V) and service health.

### 2. Windows 11 Role (`roles/windows11`)
**Purpose**: Manages the complete lifecycle of Windows 11 VMs.

-   **UEFI + TPM 2.0**: Configures q35 machine with Secure Boot and TPM emulator (required for Windows 11).
-   **VirtIO Drivers**: Auto-downloads and attaches VirtIO driver ISO for storage/network performance.
-   **Unattended Installation**: Optional `autounattend.xml` generation for automated Windows setup.
-   **Resource Management**: Creates blank qcow2 disks and manages VM workspace.
-   **Operations**: Provides status reporting, VNC connection info, and cleanup.

### 3. VM Manager Role (`roles/vm-manager`)
**Purpose**: Manages the complete lifecycle of Ubuntu virtual machines.

-   **Automated Imaging**: Downloads and caches Ubuntu cloud images.
-   **Resource Management**: Creates workspace directories and individual VM disk images (qcow2).
-   **Cloud-Init Integration**: Generates `user-data`, `meta-data`, and `network-config` ISOs for automated provisioning.
-   **Dynamic Inventory**: Automatically updates Ansible inventory files (`inventory/created_vms.yml`) with new VM details.
-   **Operations**: Provides sub-tasks for status reporting, console access, and thorough cleanup.

---

## 🚀 Quick Start

### 🛠️ Host Preparation
Run this once to configure your local machine:
```bash
make configure_virtualization
make configure_vm_manager
```

### 🖥️ Create a Windows 11 VM
```bash
# Download Windows 11 ISO from: https://www.microsoft.com/en-us/software-download/windows11
make create_win11 WIN11_ISO=/path/to/Win11_64bit.iso

# With unattended installation
make create_win11 WIN11_ISO=/path/to/Win11_64bit.iso WIN11_AUTOUNATTEND=true
```

### 🖥️ Create an Ubuntu VM
```bash
make create_vm VM_NAME=ubuntu_vm
```

---

## ⚙️ Configuration & Variables

### Virtualization Defaults (`roles/virtualization/defaults/main.yml`)
| Variable | Default | Description |
|----------|---------|-------------|
| `libvirt_group` | `libvirt` | System group for VM management |
| `vm_network_range` | `192.168.122.0/24` | Default NAT network range |

### Windows 11 Defaults (`roles/windows11/defaults/main.yml`)
Customize these in `group_vars/all.yml` or via the CLI:
| Variable | Default | Description |
|----------|---------|-------------|
| `win11_iso_path` | `""` | **Required.** Path to Windows 11 ISO |
| `vm_name` | `windows11_vm` | Name of the VM |
| `vm_ram` | `4096` | Memory in MB (minimum 4096) |
| `vm_vcpus` | `4` | Number of virtual CPUs (minimum 2) |
| `vm_disk_size` | `64G` | Disk size (minimum 64G) |
| `vm_machine_type` | `q35` | Machine type (q35 required for UEFI + TPM) |
| `win11_use_autounattend` | `false` | Enable unattended installation |
| `win11_admin_password` | `Windows11!` | Administrator password |
| `win11_locale` | `en-US` | Windows locale |
| `win11_computer_name` | `WIN11-KVM` | Hostname during install |
| `force_recreate` | `false` | Set to `true` to overwrite existing VMs |

### VM Manager Defaults (`roles/vm-manager/defaults/main.yml`)
Customize these in `group_vars/all.yml` or via the CLI:
| Variable | Default | Description |
|----------|---------|-------------|
| `vm_name` | `windows_vm` | Name of the VM |
| `vm_ram` | `2048` | Memory in MB |
| `vm_vcpus` | `1` | Number of virtual CPUs |
| `vm_disk_size` | `10G` | Disk size (e.g., 20G) |
| `ubuntu_version` | `focal` | Ubuntu release (focal, jammy) |
| `vm_static_ip` | `192.168.122.100` | Static IP assignment |
| `force_recreate` | `false` | Set to `true` to overwrite existing VMs |

---

## 📂 Project Structure

```text
.
├── inventory/
│   ├── hosts.yml             # Main host inventory
│   └── created_vms.yml       # Auto-updated list of managed VMs
├── playbooks/
│   └── configure.yml         # Primary entry point playbook
├── roles/
│   ├── virtualization/       # Infrastructure role
│   ├── windows11/            # Windows 11 VM lifecycle role
│   └── vm-manager/           # Ubuntu VM lifecycle role
└── Makefile                  # Command-line convenience wrapper
```

---

## 🛠️ Management Commands

| Action | Command |
|--------|---------|
| **Help** | `make help` |
| **Windows 11 Status** | `make win11_status` (Add `VM_NAME=xyz` for specific VM) |
| **Ubuntu VM Status** | `make vm_status` (Add `VM_NAME=xyz` for specific VM) |
| **View Workspace** | `make workspace` |
| **Delete Windows 11 VM** | `make clean_win11 VM_NAME=xyz` |
| **Delete Ubuntu VM** | `make clean VM_NAME=xyz` |
| **Full Reset** | `make clean_all` (Removes all VMs and images) |

---

## 🔑 VM Access

### Windows 11 VMs
After creation, connect via VNC to complete Windows installation:

1. **VNC**: `virsh vncdisplay windows11_vm` → connect with `vncviewer <host>:<port>`
2. **Get IP**: `virsh domifaddr windows11_vm` (after Windows is installed and network is configured)
3. **RDP**: Enable RDP in Windows (included in autounattend) and connect to the IP

> **VirtIO Drivers**: During Windows Setup, load the storage driver from the second CD-ROM at `E:\viostor\w11\amd64\`

### Ubuntu VMs
After creation, access your VM using the default `ubuntu` user and your SSH key:

1. **SSH**: `ssh ubuntu@192.168.122.100`
2. **Serial Console**: `virsh console ubuntu_vm`
3. **VNC**: `virsh vncdisplay ubuntu_vm` (Listen on `0.0.0.0`)

---

## 📝 License
MIT
