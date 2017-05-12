@isTest
private class TestMaintenanceRequest {
    @testSetup static void setData(){
        /*Vehicle__c v=new Vehicle__c(Name='Vehicle 1');
        insert v;
        
        List<Product2> prods=new List<Product2>();
        
        for(Integer i=0;i<10;i++){
            prods.add(new Product2(Cost__c=1,Current_Inventory__c=1,
                                   Lifespan_Months__c=i ,Maintenance_Cycle__c=Integer.valueOf((Math.random()+1)*1000),
                                   Replacement_Part__c=true, Name='Equipment '+i,Warehouse_SKU__c=String.valueOf(i)));
        }
        
        insert prods;
        
        List<Case> c=new List<Case>();
        
        for(Integer i=0;i<600;i++){
            if(i<=199){
                c.add(new Case(Subject=String.valueOf(i),Vehicle__c=v.ID,Equipment__c =prods[Integer.valueOf(i/60)].ID,Type='Repair',Status='New'));
            }
            else if(i>199&&i<=399){
                c.add(new Case(Subject=String.valueOf(i),Vehicle__c=v.ID,Equipment__c =prods[Integer.valueOf(i/60)].ID,Type='Routine Maintenance',Status='New'));
            }
            else if(i>399&&i<=599){
                c.add(new Case(Subject=String.valueOf(i),Vehicle__c=v.ID,Equipment__c =prods[Integer.valueOf(i/60)].ID,Type='Electrical',Status='New'));
            }
        }    
        
        insert c;
        
        List<Work_Part__c> wp=new List<Work_Part__c>();
        
        for(Integer i=0;i<600;i++){
            wp.add(new Work_Part__c(Maintenance_Request__c=c[i].ID,Equipment__c=prods[Integer.valueOf(i/60)].ID,Quantity__c=1));
            if(Integer.valueOf(i/30)<9){
                wp.add(new Work_Part__c(Maintenance_Request__c=c[i].ID,Equipment__c=prods[Integer.valueOf(i/60)+1].ID,Quantity__c=1));
            }
            else{
                wp.add(new Work_Part__c(Maintenance_Request__c=c[i].ID,Equipment__c=prods[Integer.valueOf(i/60)].ID,Quantity__c=1));
            }
        }
        
        insert wp; */
    }
    
    @isTest static void testTrigger(){
       /* List<Case> c=[SELECT ID, Status FROM Case];
        for(Case cc:c){
            cc.Status='Closed';
        }
        
        Test.startTest();
        
        update c;
        
        Test.stopTest();
        
        System.assertEquals(400,[SELECT COUNT() FROM Case WHERE Type='Routine Maintenance' AND Status='New']);
        System.assertEquals(600,[SELECT COUNT() FROM Case WHERE Status='Closed']);*/
    }
}