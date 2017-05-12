@isTest
private class DailyLeadProcessorTest {
    @testSetup static void dataSetup(){
        List<Lead> leads=new List<Lead>();
        
        for(Integer i=0;i<200;i++){
            leads.add(new Lead(LastName='Test '+i,Company='Company '+i,Status='Open - Not Contacted'));
        }
        
        insert leads;
    }
    @isTest static void runTest(){
        Test.startTest();
        
        DailyLeadProcessor lp=new DailyLeadProcessor();
        System.schedule('Proc Test', '0 0 0 * * ?', lp);
        
        Test.stoptest();
        
        System.assertEquals(200,[SELECT count() FROM Lead WHERE LeadSource='Dreamforce']);
    }
}