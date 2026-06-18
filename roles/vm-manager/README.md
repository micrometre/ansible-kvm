# Ansible Role: VM Manager

This role manages the full lifecycle of Ubuntu-based virtual machines on a Libvirt/KVM host using Cloud-Init.

## Features

- **Automated Imaging**: Downloads and maintains a local cache of official Ubuntu cloud images.
- **Dynamic Provisioning**: Uses `qemu-img` with backing files for near-instant VM creation.
- **Cloud-Init Configuration**:
    - **User Data**: Configures default user, shell, and SSH keys.
    - **Network Config**: Supports static IP assignment within the Libvirt network range.
    - **Meta Data**: Sets hostnames and instance IDs.
- **Inventory Integration**: Automatically populates `inventory/created_vms.yml` with host details and connection parameters.
- **Lifecycle Management**: Includes tasks for creation, status monitoring, and thorough cleanup (including storage and ISOs).

## Role Variables

Defined in `defaults/main.yml`:

| Variable | Default | Description |
|----------|---------|-------------|
| `vm_name` | `windows_vm` | Identifier for the VM |
| `vm_ram` | `2048` | Memory allocation in MB |
| `vm_vcpus` | `1` | CPU core allocation |
| `vm_disk_size` | `10G` | Storage capacity |
| `ubuntu_version` | `focal` | Ubuntu release (e.g., `jammy`) |
| `vm_static_ip` | `192.168.122.100` | Target IP address |
| `force_recreate` | `false` | If `true`, existing VM with same name will be deleted |

## Usage

### Create a VM
```yaml
- hosts: localhost
  roles:
    - role: vm-manager
      vars:
        vm_name: my-server
        vm_static_ip: 192.168.122.101
```

### Check Status
```bash
ansible-playbook playbooks/configure.yml --tags create-vm -e "vm_action=status vm_name=my-server"
```

## Dependencies

- `virtualization`: The host must have Libvirt/KVM configured and running.
