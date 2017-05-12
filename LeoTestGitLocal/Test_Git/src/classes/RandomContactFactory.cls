public class RandomContactFactory {
    public static List<Contact> generateRandomContacts (Integer num,String lastname){
        List<Contact> result=new List<Contact>();
        
        for(Integer i=0;i<num;i++){
        	result.add(new Contact(FirstName='Name '+i,LastName=lastname));    
        }
        
        return result;
    }
}