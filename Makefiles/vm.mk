# General / Ubuntu VM Lifecycle Targets

.PHONY: create_vm vm_status workspace clean clean_all check status

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

# Legacy compatibility targets
check: vm_status
status: vm_status
