@isTest
private class ProductToWarehouseTriggerTest {
    @isTest static void CreateNewProducts(){
        List<Product_Table__c> TestProductList1 = new List<Product_Table__c>();
Product_Table__c TestProduct1 =	new Product_Table__c(Name='TestProduct1', Added_Date__c =Date.newInstance(2018,1,30));
Product_Table__c TestProduct2 =	new Product_Table__c(Name='TestProduct2', Added_Date__c =Date.newInstance(2018,5,10));
Product_Table__c TestProduct3 =	new Product_Table__c(Name='TestProduct3', Added_Date__c =Date.newInstance(2018,12,31));
TestProductList1.add(TestProduct1);
TestProductList1.add(TestProduct2);
TestProductList1.add(TestProduct3);

insert TestProductList1;
        
        List<Product_Table__c> TestProductList2 = new List<Product_Table__c>();
                for(Integer i=4; i<=200; i++){
            Product_Table__c TestProduct = new  Product_Table__c (Name = 'TestProduct' + i);
            TestProductList2.add(TestProduct); 
        }
        insert TestProductList2;
    }
}