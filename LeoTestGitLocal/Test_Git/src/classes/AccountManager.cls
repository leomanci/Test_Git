@RestResource (urlMapping='/Accounts/*/contacts')
global class AccountManager {
    @HttpGet
    global static Account getAccount(){
        //Map<Account,List<Contact>> result=new Map<Account,List<Contact>>();
        RestRequest request = RestContext.request;

        String partialURL = request.requestURI.substring(0,request.requestURI.lastIndexOf('/'));
        String accountID = partialURL.subString(partialURL.lastIndexOf('/')+1);
        System.debug('@@@ '+accountID);
        //for(Account acc:[SELECT Id, Name, (SELECT ID, Name FROM Contacts) FROM Account WHERE ID=:accountID]){
            //result.put(acc,acc.Contacts);
        //}
        
        //return JSON.serialize(result);
        
        return [SELECT Id, Name, (SELECT ID, Name FROM Contacts) FROM Account WHERE ID=:accountID];
    }
}