@isTest
private class WarehouseSyncScheduleTest {
	// CRON expression: midnight on March 15.
   // Because this is a test, job executes
   // immediately after Test.stopTest().
   public static String CRON_EXP = '0 0 1 * * ?';

   static testmethod void test() {
      WarehouseCalloutServiceMock  mock=new WarehouseCalloutServiceMock();
       
      Test.startTest();
	  Test.setMock(HttpCalloutMock.class, mock);
       
      // Schedule the test job
      String jobId = System.schedule('WarehouseSyncScheduleTest',CRON_EXP, new WarehouseSyncSchedule());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the scheduled job hasn't run yet.
      Product2[] prods = [SELECT Id FROM Product2 WHERE Warehouse_SKU__c<>NULL];
      System.assertEquals(prods.size(),0);
       
      Test.stopTest();

      //prods=[SELECT Id FROM Product2 WHERE Warehouse_SKU__c<>NULL];
       
      //System.assert(prods.size()==2);

   }
}