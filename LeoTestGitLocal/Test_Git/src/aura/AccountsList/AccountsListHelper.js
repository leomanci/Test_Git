({
	getAccountList : function(component) {
		var action=component.get("c.getAccounts");
        
        action.setCallback(this, function(actionResult) {
            component.set("v.accounts", actionResult.getReturnValue());            
        });
        $A.enqueueAction(action);        
	}
})