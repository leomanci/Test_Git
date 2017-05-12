@isTest
private class TestRestrictContactByName {
    @isTest static void testTrigger(){
        List<Contact> cons=new List<Contact>();
        
        for(Integer i=0;i<200;i++){
            if(Math.mod(i, 2)==0){
            	cons.add(new Contact(LastName='INVALIDNAME'));
            }
            else{
                cons.add(new Contact(LastName='OTHER'));
            }
        }
        
        Test.startTest();
        
        Database.insert(cons,false);
        
        System.assert([SELECT COUNT() FROM Contact WHERE LastName='OTHER']==100);
        
        Test.stopTest();
    }
}