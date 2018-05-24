public with sharing class ProductDescriptionDetailPageController {
    public Product_Table__c Product {get; set;} 
    public String clickedProductId {get; set;}
    public String selectedProductIdPage2 {get; set;}
    public String chosenProductId {get; set;} 
    
    public ProductDescriptionDetailPageController(){
        selectedProductIdPage2 = ApexPages.currentPage().getParameters().get('clickedProductId');
        Product = [SELECT Id, Name, Units_Available__c, Unit_Price__c, Title__c, Product_Description__c, Image_Url__c 
                   FROM Product_Table__c 
                   WHERE Id =: selectedProductIdPage2];
    }
    
    public PageReference goToOrderPage(){
        PageReference pageRef =  new PageReference('/apex/OrderPage?ProductId=' + chosenProductId);
        pageRef.setRedirect(true);
        chosenProductId = selectedProductIdPage2;
        return pageRef;   
    }
    
    public PageReference BackToShopping(){
        PageReference pageRef2 = Page.Product_list_OChap;
        pageRef2.setRedirect(true);
        return pageRef2;
    }
}