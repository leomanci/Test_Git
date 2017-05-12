@isTest
private class LeadProcessorTest {
    @testSetup static void dataSetup(){
        List<Lead> leads=new List<Lead>();
        
        for(Integer i=0;i<200;i++){
            leads.add(new Lead(LeadSource='Web',LastName='Test '+i,Company='Company '+i,Status='Open - Not Contacted'));
        }
        
        insert leads;
    }
    
    @isTest static void runTest(){
        Test.startTest();
        
        LeadProcessor lp=new LeadProcessor();
        Id batchId=Database.executeBatch(lp,200);
        
        Test.stoptest();
        
        System.assertEquals(200,[SELECT count() FROM Lead WHERE LeadSource='Dreamforce']);
    }
}