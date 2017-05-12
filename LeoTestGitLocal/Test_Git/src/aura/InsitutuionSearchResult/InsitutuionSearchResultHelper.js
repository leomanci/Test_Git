({
    updateResults : function(component,countryValue,keyword) {	     
        console.log("Country " + countryValue);
        console.log("keywordSearch " + keyword);
        var action = component.get("c.getInstitutions");
        
        action.setParams({
            "country":countryValue, 
            "keyWord":keyword   
        });
        
        action.setCallback(component, function(a) {
            console.log(a.getReturnValue());
            component.set("v.institutions", a.getReturnValue());
        });
        
        $A.enqueueAction(action);     	
    }
})