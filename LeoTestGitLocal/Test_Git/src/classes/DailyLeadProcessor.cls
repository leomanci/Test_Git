global class DailyLeadProcessor implements Schedulable{
	global void execute(SchedulableContext ctx) {
        List<Lead> myLeads=new List<Lead>();
        
        for(Lead l:[SELECT ID, LeadSource FROM Lead
                    WHERE LeadSource='' LIMIT 200]){
            l.LeadSource='Dreamforce';
            myLeads.add(l);
        }
        
        update myLeads;
    }
}