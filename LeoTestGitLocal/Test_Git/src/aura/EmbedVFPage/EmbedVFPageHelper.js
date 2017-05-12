({
	getInstitutions : function(component, countryValue, keyword) {	          	  
        var searchEvent = $A.get("e.c:SearchPaths");
      	searchEvent.setParams({ "country":countryValue,"keyword":keyword}).fire();		
        console.log("Event fired");
        /*console.log("Country "+countryValue);
        console.log("keywordSearch "+keyword);
		var action = component.get("c.getInstitutions");

       action.setParams({
            "country":countryValue,
            "keyWord":keyword   
       });
        
        action.setCallback(component, function(a) {
            console.log(a.getReturnValue());
            component.set("v.institutions", a.getReturnValue());
        });
        $A.enqueueAction(action); */   
	},
    clearResults : function(component) {	     
		var action = component.get("c.getInstitutions");
        var self = this;
        action.setCallback(this, function(a) {
            component.set("v.institutions", null);
        });
        $A.enqueueAction(action);       	
    }
})