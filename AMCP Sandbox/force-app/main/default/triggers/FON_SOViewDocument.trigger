trigger FON_SOViewDocument on OrderApi__Sales_Order__c (before insert, before update) {
    {
        for(OrderApi__Sales_Order__c SO : Trigger.New) {
            if (SO.Orderapi__JSON_Data__c != null){
                SO.Orderapi__JSON_Data__c = null;
                }
        }
    }
}