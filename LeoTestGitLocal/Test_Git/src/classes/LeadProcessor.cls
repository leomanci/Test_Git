global class LeadProcessor implements Database.Batchable<sObject>{
	global Database.QueryLocator start(Database.BatchableContext bc) {
    	 return Database.getQueryLocator([SELECT ID, LeadSource FROM Lead]);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope){

        List<Lead> updateLeads=new List<Lead>();
        Integer info=0;
        for(Lead l:scope){
            l.LeadSource='Dreamforce';
            updateLeads.add(l);
            System.debug('PROCESSED '+info++);
        }
        
        update updateLeads;
    }
    
    global void finish(Database.BatchableContext bc){
    }
}