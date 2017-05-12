({
	createItem : function(component) {
       var addItem=component.getEvent('addItem');
	   var newItem=component.get("v.newItem");
       addItem.setParams({'item':newItem});
       addItem.fire();	
        
       component.set("v.newItem",{ 'sobjectType': 'Camping_Item__c',
                                   'Quantity__c': 0,
                                   'Price__c': 0,
                                   'Name': '',
                                  'Packed__c':false
                                  });
        
		$A.createComponents([
                ["ui:message",{
                    "title" : "Item added",
                    "severity" : "information",
                }],
                ["ui:outputText",{
                    "value" : "Have fun!"
                }]
                ],
                function(components, status){
                    if (status === "SUCCESS") {
                        var message = components[0];
                        var outputText = components[1];
                        // set the body of the ui:message to be the ui:outputText
                        message.set("v.body", outputText);
                        var errorDiv = component.find("errors");
                        // Replace div body with the dynamic component
                        errorDiv.set("v.body", message);
                    }
                }
            );            
	}
})