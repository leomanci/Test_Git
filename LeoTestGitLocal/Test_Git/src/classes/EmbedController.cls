public class EmbedController {
	@AuraEnabled
    public static List<University__c> getInstitutions(String country, String keyWord) {
        System.debug('Called '+country+'--'+keyWord);
        return [select id, name,Image_URL__c from University__c where Country__c LIKE:country and name like:keyword];
    }
}