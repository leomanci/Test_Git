public class MaintenanceRequestHelper {

    public static void updateWorkOrders(){
        if(Trigger.isExecuting){
            if(Trigger.isAfter){
                List<Case> newRequests=new List<Case>();
                Map<ID,Integer> serviceCycles=new Map<ID,Integer>();
                
                for(Work_Part__c wp:[SELECT Maintenance_Request__c, Equipment__r.Maintenance_Cycle__c  
                 					 FROM Work_Part__c 
                                     WHERE Maintenance_Request__c IN:Trigger.newMap.keySet()]){
                                         
                   	if(!serviceCycles.containsKey(wp.Maintenance_Request__c)){
                        serviceCycles.put(wp.Maintenance_Request__c,(Integer)wp.Equipment__r.Maintenance_Cycle__c);                   
                   	}
              		else{
                        if((Integer)wp.Equipment__r.Maintenance_Cycle__c<serviceCycles.get(wp.Maintenance_Request__c)){
                            serviceCycles.put(wp.Maintenance_Request__c,(Integer)wp.Equipment__r.Maintenance_Cycle__c);
                        }                         
               		}
                }
                
                for(Case c:(List<Case>)Trigger.new){
                    if(c.Status.equals('Closed') && (c.Type.equals('Repair')||c.Type.equals('Routine Maintenance'))){
                        Date dueDate=System.today();
                        
                        if(serviceCycles.containsKey(c.ID)){
                            dueDate=System.today().addDays(serviceCycles.get(c.ID));
                        }
                        
                        newRequests.add(new Case(Subject=c.Subject, Vehicle__c=c.Vehicle__c,
                                                 Equipment__c=c.Equipment__c,Type='Routine Maintenance',
                                                 Date_Reported__c=System.today(),
                                                 Date_Due__c=dueDate));
                    }
                }
                
                if(!newRequests.isEmpty()){
                    insert newRequests;
                }
            }
    	}
    }        
    
}