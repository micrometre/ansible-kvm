# windows11 Role

Creates a Windows 11 64-bit KVM virtual machine with UEFI, Secure Boot support, and TPM 2.0.

## Requirements

- KVM/libvirt host already configured (run `make configure_virtualization` first)
- **Windows 11 64-bit ISO** — must be provided by you at runtime  
  Download: <https://www.microsoft.com/en-us/software-download/windows11>
- Internet access to download the VirtIO drivers ISO (~300 MB, one-time)

### Packages installed automatically

`ovmf`, `swtpm`, `swtpm-tools`, `mtools`, `dosfstools`

## Quick start

```bash
make create_win11 WIN11_ISO=/path/to/Win11_64bit.iso
```

## Key variables

| Variable | Default | Description |
|---|---|---|
| `win11_iso_path` | `""` | **Required.** Path to the Windows 11 ISO |
| `vm_name` | `windows11_vm` | libvirt VM name |
| `vm_ram` | `4096` | RAM in MB (minimum 4096) |
| `vm_vcpus` | `4` | vCPU count (minimum 2) |
| `vm_disk_size` | `64G` | Disk size (minimum 64G) |
| `vm_graphics` | `vnc,listen=0.0.0.0` | Display output |
| `win11_use_autounattend` | `false` | Generate unattended answer file |
| `win11_admin_password` | `Windows11!` | Local Administrator password |
| `win11_locale` | `en-US` | Windows locale |
| `win11_timezone` | `UTC` | Windows timezone |
| `win11_computer_name` | `WIN11-KVM` | Hostname set during install |
| `force_recreate` | `false` | Destroy and recreate existing VM |

## After the VM starts

Connect via VNC to complete the Windows installation:

```bash
virsh vncdisplay windows11_vm
vncviewer <host>:<port>
```

During installation, load the VirtIO storage driver from the second CD-ROM (E:\ or D:\):  
`E:\viostor\w11\amd64\`

Check the VM IP after boot:
```bash
virsh domifaddr windows11_vm
```

## Unattended installation

Set `win11_use_autounattend=true` to auto-generate an `autounattend.xml` and attach it as a
virtual disk. Adjust `win11_admin_password`, `win11_locale`, `win11_timezone`, and
`win11_computer_name` as needed. A valid product key can be set via `win11_product_key`.

> **Note:** `win11_image_index` selects which edition to install from the ISO (1 = Home, 2 = Pro in most ISOs). Verify with `wiminfo sources/install.wim` on the ISO.

## Cleanup

```bash
make clean_win11
# or with a custom name:
make clean_win11 VM_NAME=my_windows11_vm
```
