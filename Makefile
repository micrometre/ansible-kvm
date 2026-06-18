.PHONY: help configure_virtualization configure_vm_manager create_vm vm_status workspace clean clean_all create_win11 win11_status clean_win11

help:
	@echo "Ansible Infrastructure Management"
	@echo ""
	@echo "Available targets:"
	@echo "  configure_virtualization - Configure virtualization support"
	@echo "  configure_vm_manager   - Configure VM manager"
	@echo "  create_vm              - Create a new VM (default: windows_vm)"
	@echo "  vm_status              - Check status of VMs"
	@echo "  workspace              - Show VM workspace overview"
	@echo "  clean                  - Cleanup a specific VM (default: windows_vm)"
	@echo "  clean_all              - Remove all VM images and workspace"
	@echo "  create_win11           - Create a Windows 11 64-bit VM (requires WIN11_ISO)"
	@echo "  win11_status           - Check status of the Windows 11 VM"
	@echo "  clean_win11            - Destroy and remove the Windows 11 VM"



configure_virtualization:
	@echo "Configuring virtualization on ${HOST_NAME}..."
	ansible-playbook playbooks/configure.yml --tags virtualization
	@echo ""
	@echo "✅ ${HOST_NAME} configured with virtualization!"

configure_vm_manager:
	@echo "Configuring VM manager on ${HOST_NAME}..."
	ansible-playbook playbooks/configure.yml --tags vm-manager
	@echo ""
	@echo "✅ ${HOST_NAME} configured with VM manager!"

create_vm:
	@echo "Creating VM..."
	ansible-playbook playbooks/configure.yml --tags create-vm $(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)

vm_status:
	@echo "Checking VM status..."
	ansible-playbook playbooks/configure.yml --tags create-vm -e "vm_action=status" $(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)

workspace:
	@echo "VM Workspace Overview..."
	ansible-playbook playbooks/configure.yml --tags create-vm -e "vm_action=overview"

clean:
	@echo "Cleaning up VM..."
	ansible-playbook playbooks/configure.yml --tags create-vm -e "vm_cleanup=true" $(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)

clean_all:
	@echo "Cleaning all VMs and images..."
	@# Remove the workspace and images directories as defined in role defaults
	rm -rf $(HOME)/vm-workspace
	rm -rf $(HOME)/vm-images
	@echo "✅ All VM data cleaned!"

create_win11:
	@echo "Creating Windows 11 VM..."
	@if [ -z "$(WIN11_ISO)" ]; then echo "ERROR: WIN11_ISO is required. Usage: make create_win11 WIN11_ISO=/path/to/Win11_64bit.iso"; exit 1; fi
	ansible-playbook playbooks/configure.yml --tags create-win11 -vv \
		-e "win11_iso_path=$(WIN11_ISO)" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",) \
		$(if $(WIN11_AUTOUNATTEND),-e "win11_use_autounattend=$(WIN11_AUTOUNATTEND)",)

win11_status:
	@echo "Checking Windows 11 VM status..."
	ansible-playbook playbooks/configure.yml --tags create-win11 \
		-e "vm_action=status win11_iso_path=dummy" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)

clean_win11:
	@echo "Cleaning up Windows 11 VM..."
	ansible-playbook playbooks/configure.yml --tags create-win11 \
		-e "vm_cleanup=true win11_iso_path=dummy" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)

# Legacy compatibility targets
check: vm_status
status: vm_status
