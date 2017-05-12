@isTest
private class TestVerifyDate {
    @isTest static void testCheckDates(){
        Test.startTest();
        
        Date date1=Date.newInstance(2016,1,1);
        Date date2=Date.newInstance(2016,01,15);
        
        Date result=VerifyDate.CheckDates(date1, date2);
        System.assertEquals(Date.newInstance(2016,01,15),result);
        
        date2=Date.newInstance(2016,02,15);
 		result=VerifyDate.CheckDates(date1, date2);
        System.assertEquals(Date.newInstance(2016,01,31),result);       
        
        Test.stopTest();
    }
}