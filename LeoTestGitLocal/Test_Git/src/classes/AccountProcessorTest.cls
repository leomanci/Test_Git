@isTest
private class AccountProcessorTest {
    @testSetup static void setupData(){
        Account acc=new Account(Name='Test', Number_of_Contacts__c=0);
        insert acc;
        
        List<Contact> conts=new List<Contact>();
        for(Integer i=0;i<20;i++){
            conts.add(new Contact(FirstName='EE',LastName=String.valueOf(i),AccountID=acc.ID));
        }
        
        insert conts;
    }
    
    @isTest static void runTest(){
        List<ID> accID=new List<ID>{[SELECT ID FROM Account LIMIT 1].ID};
            System.debug('TEST ACC '+[SELECT ID,Number_of_Contacts__c,(SELECT ID FROM Contacts)
                         FROM Account WHERE ID IN:accID]);
        Test.startTest();
        
        AccountProcessor.countContacts(accID);
        
        Test.stopTest();
        
        Double count=[SELECT Number_of_Contacts__c FROM Account WHERE ID=:accID[0]].Number_of_Contacts__c;
        System.assertEquals(20.0,count);
        
        
    }
}