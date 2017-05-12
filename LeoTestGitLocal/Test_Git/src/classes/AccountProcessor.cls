public class AccountProcessor {
	@future (callout=false)
    public static void countContacts(List<ID> accounts){
        List<Account> contactCount=new List<Account>();
        Account tmpAcc=null;
        
        for(Account acc:[SELECT ID,Number_of_Contacts__c,(SELECT ID FROM Contacts)
                         FROM Account WHERE ID IN:accounts]){
           tmpAcc=new Account(ID=acc.ID,Number_of_Contacts__c=acc.Contacts.size());
		   System.debug('TMP '+tmpAcc);
           contactCount.add(tmpAcc);                  
		}
        
        update contactCount;
    }
}