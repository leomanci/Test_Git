({
	doSearch : function(component, event, helper) {
        var countryInpuField = component.find("country");
        var countryValue = countryInpuField.get("v.value");  
        
        var keywordInpuField = component.find("keywordSearch");
        var keyword = keywordInpuField.get("v.value"); 
        
		helper.getInstitutions(component,countryValue,keyword);
	},
    doClear : function(component, event, helper) {
    	helper.clearResults(component);
    }    
})