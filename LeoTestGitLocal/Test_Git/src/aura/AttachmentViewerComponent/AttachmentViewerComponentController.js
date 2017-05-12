({
 	openTableMenu: function(component, event, helper) {
        try{
        var cmpTarget = component.find('dropDownMenu');
            console.log('IN '+cmpTarget);
        $A.util.addClass(cmpTarget, 'slds-hide');
        }catch(e){console.log(e);}
       
    }
})