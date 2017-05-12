trigger ClosedOpportunityTrigger on Opportunity (after insert,after update) {
    List<Task> newTasks=new List<Task>();
    
    for(Opportunity opp:Trigger.new){
        if(opp.StageName.equals('Closed Won')){
    		newTasks.add(new Task(Subject='Follow Up Test Task',WhatId=opp.ID));    
        }
    }
    
    insert newTasks;
}