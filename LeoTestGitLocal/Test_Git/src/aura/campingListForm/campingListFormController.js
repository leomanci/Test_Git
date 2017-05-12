({
	submitForm : function(component, event, helper) {
        if($A.util.isEmpty(component.find("nameField").get("v.value")) ||
           $A.util.isEmpty(component.find("priceField").get("v.value")) ||
           $A.util.isEmpty(component.find("qField").get("v.value"))){
            
			$A.createComponents([
                ["ui:message",{
                    "title" : "Invalid input",
                    "severity" : "error",
                }],
                ["ui:outputText",{
                    "value" : "Please check your inputs"
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
        else{
            /*var listItems=component.get("v.items");   
            listItems.push(JSON.stringify(myNewItem)); 
            component.set("v.items",listItems);*/
            //helper.createItem(component,myNewItem);
            
            helper.createItem(component);
        }
	}
})