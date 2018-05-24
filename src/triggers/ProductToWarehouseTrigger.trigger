trigger ProductToWarehouseTrigger on Product_Table__c (before insert) {

    if (Trigger.isBefore && Trigger.isInsert) {
      TriggerHandler.beforeInsert(Trigger.new);
    }
    
}