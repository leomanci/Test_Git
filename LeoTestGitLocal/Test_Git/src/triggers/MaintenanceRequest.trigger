trigger MaintenanceRequest on Case (after insert, before update, after update) {
	MaintenanceRequestHelper.updateWorkOrders();
}