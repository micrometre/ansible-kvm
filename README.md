# Ansible KVM VM Management

This project provides a robust framework for managing virtual machines using Ansible, QEMU/KVM, and libvirt. It is organized into two primary roles that separate infrastructure setup from individual VM lifecycle management.

---

## 🏗️ Roles Architecture

### 1. Virtualization Role (`roles/virtualization`)
**Purpose**: Prepares the host system for virtualization.

-   **System Setup**: Installs QEMU, KVM, and Libvirt packages.
-   **Security**: Adds the current user to the `libvirt` group.
-   **Networking**: Configures and starts the `default` Libvirt network (NAT).
-   **Validation**: Verifies hardware virtualization support (VT-x/AMD-V) and service health.

### 2. VM Manager Role (`roles/vm-manager`)
**Purpose**: Manages the complete lifecycle of virtual machines.

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

### 🖥️ Create Your First VM
```bash
make create_vm VM_NAME=hal9000
```

---

## ⚙️ Configuration & Variables

### Virtualization Defaults (`roles/virtualization/defaults/main.yml`)
| Variable | Default | Description |
|----------|---------|-------------|
| `libvirt_group` | `libvirt` | System group for VM management |
| `vm_network_range` | `192.168.122.0/24` | Default NAT network range |

### VM Manager Defaults (`roles/vm-manager/defaults/main.yml`)
Customize these in `group_vars/all.yml` or via the CLI:
| Variable | Default | Description |
|----------|---------|-------------|
| `vm_name` | `hal9000` | Name of the VM |
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
│   └── vm-manager/           # VM lifecycle role
└── Makefile                  # Command-line convenience wrapper
```

---

## 🛠️ Management Commands

| Action | Command |
|--------|---------|
| **Help** | `make help` |
| **Status Check** | `make vm_status` (Add `VM_NAME=xyz` for specific VM) |
| **View Workspace** | `make workspace` |
| **Delete VM** | `make clean VM_NAME=xyz` |
| **Full Reset** | `make clean_all` (Removes all VMs and images) |

---

## 🔑 VM Access

After creation, access your VM using the default `ubuntu` user and your SSH key:

1. **SSH**: `ssh ubuntu@192.168.122.100`
2. **Serial Console**: `virsh console hal9000`
3. **VNC**: `virsh vncdisplay hal9000` (Listen on `0.0.0.0`)

---

## 📝 License
MIT
