@isTest
private class AccountManagerTest {
    @testSetup static void setupData(){
        Account acc=new Account(name='test');
        insert acc;
        
        List<Contact> conts=new List<Contact>();
        for(Integer i=0;i<20;i++){
            conts.add(new Contact(FirstName='Test',LastName='LastN',AccountId=acc.ID));
        }
        
        insert conts;
    }
    
    @isTest static void doTest(){
        String accID=[SELECT ID FROM Account LIMIT 1].ID;
        
        Test.startTest();
        
        RestRequest req=new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri='https://leomanci2-dev-ed.my.salesforce.com/services/apexrest/Accounts/'+accID+'/contacts';
        RestContext.request=req;
        System.debug('$$$$ TEST '+accID);
		Account result = AccountManager.getAccount();
        System.debug('##### '+result);
        System.assert(result!=null);

        Test.stopTest();
    }
}