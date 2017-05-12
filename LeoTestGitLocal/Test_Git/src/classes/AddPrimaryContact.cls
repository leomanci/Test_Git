public class AddPrimaryContact implements Queueable{
    private Contact myContact {get;set;}
    private String myState {get;set;}
    
    public AddPrimaryContact(Contact c,String state){
        myContact=c;
        myState=state;
    }
    public void execute(QueueableContext context) {
        List<Contact> clonedContacts=new List<Contact>();
        
        Contact tmp=null;
        
        for(Account acc:[SELECT ID FROM Account
                         WHERE BillingState=:myState]){
            tmp=myContact.clone(false,true,false,false);
            tmp.AccountID=acc.ID;
        	clonedContacts.add(tmp);
        }
        
        insert clonedContacts;
    }
}