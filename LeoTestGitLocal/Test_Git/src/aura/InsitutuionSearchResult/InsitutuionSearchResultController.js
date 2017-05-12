({
	updateResults : function(component,event,helper) {
        console.log("Hit this");
        try{
            var countryValue=event.getParam("country");
            var keyword=event.getParam("keyword");
            helper.updateResults(component,countryValue,keyword);
    	}catch(e){console.log(e);}	
    }
})