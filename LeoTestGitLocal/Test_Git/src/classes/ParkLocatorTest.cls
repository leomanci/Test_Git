@isTest
private class ParkLocatorTest {
    @isTest static void testSOAP(){
        ParkServiceMock mock=new ParkServiceMock();
        
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, mock);
        String[] result=ParkLocator.country('Japan');
        System.assert(result!=null);
        
        Test.stopTest();
    }
}