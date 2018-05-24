public class TriggerHandler {
    
    public static  void beforeInsert(List<Product_Table__c> Products) {
        Set<Warehouse__c> newWarehouseSet = new Set<Warehouse__c>();
        List<Warehouse__c> newWarehouseList = new List<Warehouse__c>();
        
        List<Product_Table__c> ProductQueueList = new List<Product_Table__c>();
        
        Org_Configuration__c orgConf = Org_Configuration__c.getOrgDefaults();
        Integer Term = orgConf.Period_Term__c.intValue(); 
        
        
        List<Warehouse__c> WarehouseList = [SELECT Id, Period_Start__c, Period_End__c
                                            FROM Warehouse__c
                                           ];
        
        If(!WarehouseList.isEmpty()){
            for(Product_Table__c ProductItem : Products) {
                if(ProductItem.Added_Date__c == Null) {
                    ProductItem.Added_Date__c = Date.Today();
                }
                Integer i=0;
                While(ProductItem.Warehouse__c == NULL && i<= WarehouseList.size()){
                    i++;
                    for (Warehouse__c  WarehouseItem : WarehouseList){
                        if(WarehouseItem.Period_Start__c <=  ProductItem.Added_Date__c
                           && WarehouseItem.Period_End__c >=  ProductItem.Added_Date__c){
                               ProductItem.Warehouse__c = WarehouseItem.Id; 
                           } 
                    }
                }
                if (ProductItem.Warehouse__c == null){
                    ProductQueueList.add(ProductItem);
                }
            }
        } else {  
            for(Product_Table__c ProductItem : Products) {
                if(ProductItem.Added_Date__c == Null) {
                    ProductItem.Added_Date__c = Date.Today();
                } 
                ProductQueueList.add(ProductItem);
            }
        } 
        
        
        
        
        if (!ProductQueueList.isEmpty()){
            For(Product_Table__c ProductQueueItem: ProductQueueList){
                Warehouse__c  newWarehouse = new Warehouse__c (Name = 'Warehouse '+ ProductQueueItem.Added_Date__c + ' ' + ProductQueueItem.Added_Date__c.addDays(Term),
                                                               Period_Start__c = ProductQueueItem.Added_Date__c,
                                                               Period_End__c = ProductQueueItem.Added_Date__c.addDays(Term));
                newWarehouseSet.add(newWarehouse);  
                
            }
            
            if(!newWarehouseSet.isEmpty()) {
                newWarehouseList.addAll(newWarehouseSet);
                insert newWarehouseList;
            }
            
            if (!ProductQueueList.isEmpty()){
                for(Product_Table__c ProductQueueItem : ProductQueueList) {
                    for (Warehouse__c  newWarehouseItem : newWarehouseList){
                        if(newWarehouseItem.Period_Start__c <=  ProductQueueItem.Added_Date__c
                           && newWarehouseItem.Period_End__c >=  ProductQueueItem.Added_Date__c){
                               ProductQueueItem.Warehouse__c = newWarehouseItem.Id;         
                           }
                    }
                }
            }
        }  
    }
}