@isTest (seeAllData = false)
public class LightningButtonServerTests {
    
	@isTest static void testButtonRendering() {
        account acc = createTestAccount();
        ID recordID = acc.id;
        string field = 'BillingStreet';
        string value = 'the new street';
        string objectString = 'Account';
        string theFieldValue = 'test';	//the value if the button should be rendered
        
        //button should be enabled because value is the same
		boolean buttonRender = LightningButtonServerController.buttonEnable(recordID, field, value, objectString, theFieldValue);
        system.assert(buttonRender);
        
        //value is not the same so should not be rendered
        theFieldValue = 'test NO';	
        boolean buttonRender2 = LightningButtonServerController.buttonEnable(recordID, field, value, objectString, theFieldValue);
        system.assert(!buttonRender2);
        
        //try without a field
        Field = null;	
        boolean buttonRender3 = LightningButtonServerController.buttonEnable(recordID, field, value, objectString, theFieldValue);
        system.assert(buttonRender3);	//true because should render if failed
        
        //try wrong ID
        Field = 'BillingStreet';
        recordID = '500p0000002C0xEAAS';
        boolean buttonRender4 = LightningButtonServerController.buttonEnable(recordID, field, value, objectString, theFieldValue);
        system.assert(buttonRender4);	//true because should render if failed
        
        //try no field value defined
        theFieldValue = null;
        recordID = acc.id;
        boolean buttonRender5 = LightningButtonServerController.buttonEnable(recordID, field, value, objectString, theFieldValue);
        system.assert(buttonRender5);	//true because should render if failed
    }
    
    
	@isTest static void testUpdateRecordSuccessfully() {
        account acc = createTestAccount();
        ID recordID = acc.id;
        string field = 'BillingStreet';
        string value = 'the new street';
        string objectString = 'Account';
        
        //successful Button press
        LightningButtonServerController.errorMessage success = LightningButtonServerController.updateCaseStatus(recordID, field, value, objectString);
        system.assert(success.success);	//successful
        Account successAccount = [select id, billingstreet from account where id = :recordID];
        system.assert(successAccount.BillingStreet == 'the new street');
        
        //Failed update due to street too long
        value = 'TEdaushfuahfuiewbfuirbfouibrf yeoruibg oigyb aoiueb goryuabi yiurqe byoiu qrwgoyiu rgoui yofiuwbfoiuwbyfioruwbyrgoiuwbygroiugrybogqriubygqreioubgyoiqeruyb grieub qoygryguueieub rwqib gqrwiuqwrguby pqgriuwb ygpqrwiuyb gqrwpiub wrypqgrwib gqrwpiurwgb EEQWERQWERFWEQFQWREWREQ';
        LightningButtonServerController.errorMessage fail = LightningButtonServerController.updateCaseStatus(recordID, field, value, objectString);
        system.assert(!fail.success);	//failed
        Account failAccount1 = [select id, billingstreet from account where id = :recordID];
        system.debug('Account street = ' +failAccount1.BillingStreet );
        system.assert(failAccount1.BillingStreet == 'the new street');	//street should not have changed
        
        //test invalid object
        value = 'Test 2';
        objectString = null;
        LightningButtonServerController.errorMessage fail2 = LightningButtonServerController.updateCaseStatus(recordID, field, value, objectString);
        system.assert(!fail2.success);	//failed
        Account failAccount2 = [select id, billingstreet from account where id = :recordID];
        system.debug('Account street = ' +failAccount2.BillingStreet );
        system.assert(failAccount2.BillingStreet == 'the new street');	//street should not have changed
        
        //test invalid object
        value = 'Test 2';
        objectString = 'adskgfuiuewh';
        LightningButtonServerController.errorMessage fail3 = LightningButtonServerController.updateCaseStatus(recordID, field, value, objectString);
        system.assert(!fail3.success);	//failed
        Account failAccount3 = [select id, billingstreet from account where id = :recordID];
        system.debug('Account street = ' +failAccount3.BillingStreet );
        system.assert(failAccount3.BillingStreet == 'the new street');	//street should not have changed
    }
    
    private static Account createTestAccount(){
		Account acc = new Account(name = 'test', Billingstreet = 'test');
        insert acc;
        return acc;
    }
}