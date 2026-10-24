.DEFAULT_GOAL := help
.PHONY: help

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
	@echo "  snapshot               - Create a snapshot of a VM (alias: snapshot_create)"
	@echo "  snapshot_list          - List snapshots for a VM"
	@echo "  snapshot_revert        - Revert a VM to a snapshot (requires SNAPSHOT_NAME)"
	@echo "  snapshot_delete        - Delete a VM snapshot (requires SNAPSHOT_NAME)"
	@echo "  snapshot_clone         - Create a new VM from a snapshot (requires SNAPSHOT_NAME, NEW_VM_NAME)"
	@echo "  create_win11           - Create a Windows 11 64-bit VM (requires WIN11_ISO)"
	@echo "  win11_status           - Check status of the Windows 11 VM"
	@echo "  clean_win11            - Destroy and remove the Windows 11 VM"
	@echo "  win11_snapshot         - Create a snapshot of the Windows 11 VM (alias: win11_snapshot_create)"
	@echo "  win11_snapshot_list    - List snapshots for the Windows 11 VM"
	@echo "  win11_snapshot_revert  - Revert the Windows 11 VM to a snapshot (requires SNAPSHOT_NAME)"
	@echo "  win11_snapshot_delete  - Delete a Windows 11 VM snapshot (requires SNAPSHOT_NAME)"
	@echo "  win11_snapshot_clone   - Create a new Windows 11 VM from a snapshot (requires SNAPSHOT_NAME, NEW_VM_NAME)"

include Makefiles/setup.mk
include Makefiles/vm.mk
include Makefiles/win11.mk
include Makefiles/snapshot.mk
