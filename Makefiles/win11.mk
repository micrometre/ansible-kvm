# Windows 11 VM Lifecycle Targets

.PHONY: create_win11 win11_status clean_win11

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
