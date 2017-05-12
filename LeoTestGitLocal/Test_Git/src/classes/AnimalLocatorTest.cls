@isTest
private class AnimalLocatorTest {
    @isTest static void testCallout(){
        AnimalLocatorMock  mock=new AnimalLocatorMock();
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, mock);
        String result=AnimalLocator.getAnimalNameById(1);
        System.debug('TEST RESULT '+result);
        System.assert(String.isNotBlank(result));
        Test.stopTest();
    }
}