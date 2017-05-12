public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    @future (callout=true)
    public static void runWarehouseEquipmentSync(){
        HttpRequest req=new HttpRequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse resp=http.send(req);
        
        if(resp.getStatusCode()==200 && String.isNotBlank(resp.getBody())){
            System.debug('@@CALLOUT');
            
            List<WareHouseWrapper> result=(List<WareHouseWrapper>)JSON.deserialize(resp.getBody(),List<WareHouseWrapper>.class);
            
            for(WareHouseWrapper obj:result){
                System.debug(obj);
            }
            
            if(!result.isEmpty()){
                List<Product2> products=new List<Product2>();
                
                for(WareHouseWrapper wrap:result){
                    products.add(new Product2(Cost__c=wrap.cost,Current_Inventory__c=wrap.quantity,
                                              Lifespan_Months__c=wrap.lifespan ,Maintenance_Cycle__c=wrap.maintenanceperiod,
                                              Replacement_Part__c=true, Name=wrap.name,Warehouse_SKU__c=wrap.sku));
                }
                
                Database.upsert(products, Product2.Fields.Warehouse_SKU__c, true);
            }
        }          
    }
	
    class WareHouseWrapper{
    	//public String _id;
        public Boolean replacement;
        public Integer quantity;
        public String name;
        public Integer maintenanceperiod;
        public Integer lifespan;
        public Double cost;
        public String sku;
   	}
}