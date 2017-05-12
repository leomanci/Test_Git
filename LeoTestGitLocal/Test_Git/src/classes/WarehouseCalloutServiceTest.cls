@isTest
private class WarehouseCalloutServiceTest {
      @isTest static void testCallout(){
        WarehouseCalloutServiceMock  mock=new WarehouseCalloutServiceMock();
         
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, mock);
        WarehouseCalloutService.runWarehouseEquipmentSync();
        
        Test.stopTest();
          
        System.assert([SELECT COUNT() FROM Product2 WHERE Warehouse_SKU__c LIKE '10000%']==2);
    }
}