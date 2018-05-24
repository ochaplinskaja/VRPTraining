public with sharing class ProductListPageController {
    public  List<Product_table__c> ProductList {get; set;}
    public String clickedProductId {get; set;} 
    public String chosenProductId {get; set;} 
    
    public ProductListPageController(){
        ProductList  =  new List<Product_table__c> ([SELECT  Id, Name, Units_Available__c, Title__c, Product_Description__c, Image_Url__c, Unit_Price__c
                                                     FROM Product_Table__c 
                                                     LIMIT 100]);
        for(Product_table__c ProductItem : ProductList){ 
            if(ProductItem.Product_Description__c.length() >= 100){
                ProductItem.Product_Description__c = ProductItem.Product_Description__c.substring(0, 96)+'...';
            }
        } 
    }
    
    public PageReference goToDescriptionDetailPage(){
        PageReference pageRef = Page.ProductDescriptionDetailPage;
        pageRef.setRedirect(true);
        pageRef.getParameters().put('clickedProductId', clickedProductId);
        return pageRef;  
    }
    
    public PageReference goToOrderPage(){
        system.debug('chosenProductId = ' + chosenProductId);
        PageReference pageRef2 =  new PageReference('/apex/OrderPage?ProductId=' + chosenProductId);
        pageRef2.setRedirect(true);
        return pageRef2;  
    }
}