({
    //function for enabling/disabling the button on particular values of a field
    doInit: function(component, event, helper) {
        console.log("Start Init Method");
        
        //get the field value propery
        var fieldVal = component.get("v.ShowButtonOnFieldValue");
        
        console.log("Field Value = " + fieldVal);
        if(fieldVal == null || fieldVal == ''){
            console.log("Enable the Button as field not defined");
            component.set("v.disabled", "false");
            return;
        }
        
        //create instance of the controller method
        var action = component.get("c.buttonEnable");
        console.log("Before setting the parameters");
        
        //initialise the parameters
        action.setParams({ 
            recordID : component.get("v.RecordID"),
            field : component.get("v.Field"),
            value : component.get("v.Value"),
            objectString : component.get("v.objectString"),
            theFieldValue : fieldVal
        });
        
        console.log("Before Callback");

		//create callback - excecutes after the server side action returned 
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnVal = response.getReturnValue();   
            
            console.log("Should render button? = " + returnVal);
            //console.log("Value = " + returnVal.get("status"));
            //console.log("status = " + returnVal.status);
        
            if(state === "SUCCESS"){
                if(returnVal){
                    console.log("Enable the Button");
                    component.set("v.disabled", "false");
                }
                else{
                    console.log("Disable the Button");
                    component.set("v.disabled", "true");
                }
            }
            
        });
        
        //enqueue
        $A.enqueueAction(action);
    },
    
    
    //function for updating the value of the record
    recordUpdate : function(component, event, helper) {
		console.log("Start button press");
        console.log("Vrecord = ");
        console.log(component.get("v.recordId"));
        
        //create instance of the controller method
        var action = component.get("c.updateCaseStatus");
        
        //set parameters
        action.setParams({ 
            recordID : component.get("v.recordId"),
            field : component.get("v.Field"),
            value : component.get("v.Value"),
            objectString : component.get("v.objectString")
        });
        
        //create callback - excecutes after the server side action returned 
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnVal = response.getReturnValue();
            
            console.log("Server Side result: " + returnVal.success);
            console.log("Server Side message: " + returnVal.errorMessage);
            
            //if the server request was successful
            if(state === "SUCCESS"){
                try{
					if(returnVal.success){
                        console.log("Success! Refresh page");
                        if($A.get('e.force:refreshView') != null){
                            $A.get('e.force:refreshView').fire();	//refresh the page - only works within page/community
                        }
                    }
                    else{
                        console.log('ERROR from server result found');
                        throw new Error(returnVal.errorMessage);
                    }                    
                }
                catch(e){
                    //create message component
                	console.log('Catching Error');
                    $A.createComponents([
                        ["ui:message",{
                            "title" : "Review the errors on this page.",
                            "severity" : "error",
                            "closable"  : "true",
                        }],
                        ["ui:outputText",{
                            "value" : e.message
                        }]
                        ],
                        function(components, status){
                            console.log('function for building the error message');
                            
                            if (status === "SUCCESS") {
                                console.log('function successful');
                                
                                var message = components[0];
                                var outputText = components[1];
                                
                                // set the body of the ui:message to be the ui:outputText 
                                message.set("v.body", outputText);
                                
                                //Get the div from the page
                                var div1 = component.find("div1");
                                
                                // Replace div body with the dynamic component
                                div1.set("v.body", message);
                            }
                        }
                    );
                }
	
            }
			//handle incomplete
			else if (state === "INCOMPLETE") {
                // do something
            }
            //error with the server request
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                        
                        $A.error(errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
			
        });
        
        //enqueue
        $A.enqueueAction(action);
		
        console.log("End button press");
        //console.log("enter show details");
        //$A.warning("This is a warning message.");
        
    }
    
    
    
})