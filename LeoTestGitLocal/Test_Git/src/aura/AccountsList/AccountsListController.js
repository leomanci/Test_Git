({
	doInit : function(component, event, helper) {
		helper.getAccountList(component);
	},
    showDetails: function(component,event,helper){
  	//Get data via "data-data" attribute from button (button itself or icon's parentNode)
        var id = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data")
        alert(id + " was passed");       
    }
})