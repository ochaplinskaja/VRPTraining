public with sharing class OrderPageController {
    
    public Integer UnitCount {get; set;}
    public Product_Table__c ChosenProduct {get; set;}
    public Integer TotalAmount {get; set;}
    public String  BuyersEmail {get; set;}
    public String BuyersFirstName {get; set;}
    public String BuyersLastName {get; set;}
    public String selectedProductIdPage3{get; set;}
    public ApexPages.Message Message {get; set;}
    private Order_Table__c newOrder;
    private Contact BuyersContact;
    private Contact ContactVerification;
    private String ContactId;
    public PageReference pageRef2;
    public Integer TotalAmountValue {get;set;}
    
    public OrderPageController(){
        selectedProductIdPage3 = ApexPages.currentPage().getParameters().get('ProductId');
        ChosenProduct = [SELECT Id, Name, Unit_Price__c, Units_Available__c
                         FROM Product_Table__c
                         WHERE Id =: selectedProductIdPage3
                        ];
    }
    
    public PageReference Buy(){
        if (String.isBlank(BuyersEmail) || String.isBlank(BuyersFirstName) || String.isBlank(BuyersLastName) || UnitCount == NULL || UnitCount <= 0 || system.Math.Mod(UnitCount, 1)!=0){
            ApexPages.Message Message = new ApexPages.Message(ApexPages.Severity.ERROR,'Please, check if the next fields are filled in: Email, First Name and Last Name, Unit Count. Unit Count value has to be more then zero integer.Please,  fill in the fields below on the page and try again. ');    // вывести сообщение о том, что поля не заполнены 
            ApexPages.addMessage(Message); 
            return null;   
        }else{
            Map<Id, Contact> ContactMap = new Map<Id,Contact>([SELECT Id, Email FROM Contact]);
            if(!ContactMap.isEmpty()){
                for (String ItemKey : ContactMap.keyset() ){
                    if(ContactMap.get(ItemKey).Email!=NULL && ContactMap.get(ItemKey).Email.equalsIgnoreCase(BuyersEmail)){
                        ContactId = ItemKey;
                    }
                }
            }
            
            if(String.isBlank(ContactId)){
                Contact newContact = new Contact (Email = BuyersEmail,
                                                  FirstName = BuyersFirstName,
                                                  LastName = BuyersLastName); 
                try{
                    insert newContact;
                } catch (DMLException e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please, enter valid Email.'));
                    return null;
                }
                
                BuyersContact = newContact;
                system.debug('BuyersContact new =  ' + BuyersContact);
            }else{
                ContactVerification = [SELECT Id, FirstName, LastName, Email
                                       FROM Contact
                                       WHERE Id = : ContactId] ;
                if(ContactVerification.FirstName != BuyersFirstName || ContactVerification.LastName != BuyersLastName){
                    if(ContactVerification.FirstName != BuyersFirstName){
                        ContactVerification.FirstName = BuyersFirstName;
                    }
                    if(ContactVerification.LastName != BuyersLastName){
                        ContactVerification.LastName = BuyersLastName;  
                    }
                    update ContactVerification;
                    BuyersContact = ContactVerification;   
                }
            }
        }
        
        Savepoint sp = Database.setSavepoint();
        
        Order_Table__c newOrder = new Order_Table__c (Name = Date.today() + '  '  + ChosenProduct.Name,
                                                      Product__c = ChosenProduct.Id,
                                                      Units__c = UnitCount,
                                                      Order_Amount__c = UnitCount * ChosenProduct.Unit_Price__c,
                                                      Contact__c =  BuyersContact.Id);
        insert newOrder;
        
        if (ChosenProduct.Units_Available__c - newOrder.Units__c < 0 ){
            Database.rollback(sp);
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There are not enough products at the warehouse to complete your order.');
            ApexPages.addMessage(errorMsg);  
        }else{ 
            ChosenProduct.Units_Available__c -= newOrder.Units__c ;
            Update ChosenProduct;
            
            BuyersEmail = NULL;
            BuyersFirstName = NULL;
            BuyersLastName = NULL;  
            UnitCount = NULL;
            ChosenProduct = NULL;
            TotalAmountValue = NULL;
                
            ApexPages.Message successMsg = new ApexPages.Message(ApexPages.Severity.INFO,'The order was successfully completed.');
            ApexPages.addMessage(successMsg);
        }
        return null; 
    }
    
    
    
    public pageReference setTotalAmount() {     
        if(UnitCount == NULL) {
            TotalAmount = NULL;
        }else{ 
            TotalAmount =  ChosenProduct.Unit_Price__c.intValue() * UnitCount;
        }
        return null;
    }
    
    public PageReference BackToShopping(){
        PageReference pageRef2 = Page.Product_list_OChap;
        pageRef2.setRedirect(true);
        return pageRef2;  
    }
}