public with sharing class LightningButtonServerController {
	@AuraEnabled
    public static boolean buttonEnable(ID recordID, string field, string value, string objectString, string theFieldValue){
        //if there is no field value defined then the button should always be rendered
        if(theFieldValue == null) return true;
        
        errorMessage theRecord = returnRecord(recordID,field,value,objectString);
        system.debug('returned result: ' + theRecord);
        if(theRecord.success){
            sobject theSobj = theRecord.theSobj;
            system.debug('returned sobj: ' + theSobj);
            system.debug('theFieldValue = ' + theFieldValue);
            if(theFieldValue != null && field != null && theSobj.get(field) == theFieldValue){
                system.debug('Should render');
                return true;
            }
            else{
                system.debug('Do Not render');
                return false;
            }
        }
        //if it fails then render the button anyway
        else{
            system.debug('Failure - Should render');
            return true;
        }
    }
    
    public static errorMessage returnRecord(ID recordID, string field, string value, string objectString){
        //check if any of the properties are blank and therefore return error
        if(recordID == null || field == null || value == null || objectString == null){
            return new errorMessage(false, 'Not All Parameters defined');
        }
        
        //build query for field update
        string query = 'select id ,' + field + ' from ' + objectString + ' where id = \'' + recordID + '\'';
        system.debug('query = ' + query);
        
        //query the records
        list<sobject> sobjList;
        try{
        	sobjList = database.query(query);
            if(sobjList.size() == 1){
                return new errorMessage(true, '', sobjList[0]);
            }
            else{
                return new errorMessage(false, 'Record Not Found');
            }
            
        }
        catch(queryException q){
            return new errorMessage(false, q.getMessage());
        }
    }
    
    @AuraEnabled
    public static errorMessage updateCaseStatus(ID recordID, string field, string value, string objectString){
        errorMessage theRecord = returnRecord(recordID,field,value,objectString);
        
        //check query was successful
        if(theRecord.success){
            sobject theSobj = theRecord.theSobj;
			//set the field
            theSobj.put(field, value);
            
            //update the record with the new field value + catch any errors
            try{
                update theSobj;
                return new errorMessage(true, 'Success');
            }
            catch(DMLexception d){
                return new errorMessage(false, d.getDmlMessage(0));
            }
        }
        else{
            return theRecord;
        }
    }
    
    //Class for success and error messages
    public class errorMessage{
        @AuraEnabled public boolean success;
        @AuraEnabled public string errorMessage;
        public sobject theSobj;
        
        public errorMessage(boolean succ, string errMsg){
            success = succ;
            errorMessage = errMsg;
        }
        public errorMessage(boolean succ, string errMsg, sobject sobj){
            success = succ;
            errorMessage = errMsg;
            theSobj = sobj;
        }
    }
}