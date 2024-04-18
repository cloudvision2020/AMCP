trigger FON_SOViewDocumentReceipt on OrderApi__Receipt__c (before insert, before update) {
    {
        for(OrderApi__Receipt__c RC : Trigger.New) {
            if (RC.OrderApi__Action_Information__c != null){
                RC.OrderApi__Action_Information__c = null;
                }
        }
    }
}