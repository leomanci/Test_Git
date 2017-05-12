@isTest
private class AddPrimaryContactTest {
    @testSetup static void dataSetup(){
        List<Account> accs=new List<Account>();
        Account tmp=null;
        
        for(Integer i=0;i<100;i++){
            tmp=new Account(Name='Test '+i);
            
            if(Math.mod(i, 2)==0){
                tmp.BillingState='CA';
            }
            else{
                tmp.BillingState='NY';
            }
            
            accs.add(tmp);
        }
        
        insert accs;
    }
    
    @isTest static void doTest(){
        Test.startTest();
        
        Contact c=new Contact(LastName='Test');
        AddPrimaryContact apc=new AddPrimaryContact(c,'CA');
        System.enqueueJob(apc);
        
        Test.stopTest();
        
        System.assertEquals(50, 
                           [SELECT count() FROM Contact WHERE Account.BillingState='CA']);
    }
}