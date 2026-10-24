# VM Snapshot Management Targets (Ubuntu & Windows 11)

.PHONY: snapshot snapshot_create snapshot_list snapshot_revert snapshot_delete snapshot_clone create_vm_from_snapshot \
	win11_snapshot win11_snapshot_create win11_snapshot_list win11_snapshot_revert win11_snapshot_delete win11_snapshot_clone create_win11_from_snapshot

# --- Ubuntu / General VM Snapshots ---

snapshot: snapshot_create

snapshot_create:
	@echo "Creating VM snapshot..."
	ansible-playbook playbooks/configure.yml --tags create-vm \
		-e "vm_action=snapshot_create" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",) \
		$(if $(SNAPSHOT_NAME),-e "snapshot_name=$(SNAPSHOT_NAME)",) \
		$(if $(SNAPSHOT_DESC),-e "snapshot_description='$(SNAPSHOT_DESC)'",)

snapshot_list:
	@echo "Listing VM snapshots..."
	ansible-playbook playbooks/configure.yml --tags create-vm \
		-e "vm_action=snapshot_list" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)

snapshot_revert:
	@echo "Reverting VM to snapshot..."
	@if [ -z "$(SNAPSHOT_NAME)" ]; then echo "ERROR: SNAPSHOT_NAME is required. Usage: make snapshot_revert SNAPSHOT_NAME=my_snap [VM_NAME=my_vm]"; exit 1; fi
	ansible-playbook playbooks/configure.yml --tags create-vm \
		-e "vm_action=snapshot_revert" \
		-e "snapshot_name=$(SNAPSHOT_NAME)" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)

snapshot_delete:
	@echo "Deleting VM snapshot..."
	@if [ -z "$(SNAPSHOT_NAME)" ]; then echo "ERROR: SNAPSHOT_NAME is required. Usage: make snapshot_delete SNAPSHOT_NAME=my_snap [VM_NAME=my_vm]"; exit 1; fi
	ansible-playbook playbooks/configure.yml --tags create-vm \
		-e "vm_action=snapshot_delete" \
		-e "snapshot_name=$(SNAPSHOT_NAME)" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)

create_vm_from_snapshot: snapshot_clone

snapshot_clone:
	@echo "Creating new VM from snapshot..."
	@if [ -z "$(SNAPSHOT_NAME)" ] || [ -z "$(NEW_VM_NAME)" ]; then echo "ERROR: SNAPSHOT_NAME and NEW_VM_NAME are required. Usage: make snapshot_clone SNAPSHOT_NAME=my_snap NEW_VM_NAME=cloned_vm [VM_NAME=source_vm]"; exit 1; fi
	ansible-playbook playbooks/configure.yml --tags create-vm \
		-e "vm_action=snapshot_clone" \
		-e "snapshot_name=$(SNAPSHOT_NAME)" \
		-e "new_vm_name=$(NEW_VM_NAME)" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)

# --- Windows 11 VM Snapshots ---

win11_snapshot: win11_snapshot_create

win11_snapshot_create:
	@echo "Creating Windows 11 VM snapshot..."
	ansible-playbook playbooks/configure.yml --tags create-win11 \
		-e "vm_action=snapshot_create win11_iso_path=dummy" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",) \
		$(if $(SNAPSHOT_NAME),-e "snapshot_name=$(SNAPSHOT_NAME)",) \
		$(if $(SNAPSHOT_DESC),-e "snapshot_description='$(SNAPSHOT_DESC)'",)

win11_snapshot_list:
	@echo "Listing Windows 11 VM snapshots..."
	ansible-playbook playbooks/configure.yml --tags create-win11 \
		-e "vm_action=snapshot_list win11_iso_path=dummy" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)

win11_snapshot_revert:
	@echo "Reverting Windows 11 VM to snapshot..."
	@if [ -z "$(SNAPSHOT_NAME)" ]; then echo "ERROR: SNAPSHOT_NAME is required. Usage: make win11_snapshot_revert SNAPSHOT_NAME=my_snap [VM_NAME=my_vm]"; exit 1; fi
	ansible-playbook playbooks/configure.yml --tags create-win11 \
		-e "vm_action=snapshot_revert win11_iso_path=dummy" \
		-e "snapshot_name=$(SNAPSHOT_NAME)" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)

win11_snapshot_delete:
	@echo "Deleting Windows 11 VM snapshot..."
	@if [ -z "$(SNAPSHOT_NAME)" ]; then echo "ERROR: SNAPSHOT_NAME is required. Usage: make win11_snapshot_delete SNAPSHOT_NAME=my_snap [VM_NAME=my_vm]"; exit 1; fi
	ansible-playbook playbooks/configure.yml --tags create-win11 \
		-e "vm_action=snapshot_delete win11_iso_path=dummy" \
		-e "snapshot_name=$(SNAPSHOT_NAME)" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)

create_win11_from_snapshot: win11_snapshot_clone

win11_snapshot_clone:
	@echo "Creating new Windows 11 VM from snapshot..."
	@if [ -z "$(SNAPSHOT_NAME)" ] || [ -z "$(NEW_VM_NAME)" ]; then echo "ERROR: SNAPSHOT_NAME and NEW_VM_NAME are required. Usage: make win11_snapshot_clone SNAPSHOT_NAME=my_snap NEW_VM_NAME=win11_clone [VM_NAME=source_vm]"; exit 1; fi
	ansible-playbook playbooks/configure.yml --tags create-win11 \
		-e "vm_action=snapshot_clone win11_iso_path=dummy" \
		-e "snapshot_name=$(SNAPSHOT_NAME)" \
		-e "new_vm_name=$(NEW_VM_NAME)" \
		$(if $(VM_NAME),-e "vm_name=$(VM_NAME)",)
