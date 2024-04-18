global class FON_As_Of_Batchable implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, OrderApi__Total__c, (SELECT Id, OrderApi__Date__c, OrderApi__Type__c, OrderApi__Debit__c FROM OrderApi__Transaction_Lines__r 
                                            WHERE (OrderApi__Type__c = 'Cash' OR OrderApi__Type__c = 'Reimbursement' OR OrderApi__Type__c = 'Credit Memo Applied'
                                            OR OrderApi__Type__c = 'Adjustment') AND OrderApi__Debit__c != 0 AND OrderApi__Debit__c != null)
            FROM OrderApi__Sales_Order__c WHERE OrderApi__Sales_Order_Status__c != 'Draft'
        ]);
        
    }
    
    global void execute(Database.BatchableContext bc, List<OrderApi__Sales_Order__c> scope) {
        
        Map<Id, List<OrderApi__Transaction_Line__c>> transactionLineMap = new Map<Id, List<OrderApi__Transaction_Line__c>>();
        for (OrderApi__Sales_Order__c order : scope) {
            transactionLineMap.put(order.Id, order.OrderApi__Transaction_Lines__r);
        }
        
        Integer currentYear = System.today().year();
        Date LastJan = Date.newInstance(currentYear-1, 1, 1);
        List<OrderApi__Sales_Order__c> SOstoup = new List<OrderApi__Sales_Order__c>();
        
        for (OrderApi__Sales_Order__c order : scope) {
            Map<Integer,Decimal> monthxamountmap = new Map<integer,decimal>();
            Integer remaining = 25;
            
            for (OrderApi__Transaction_Line__c tl : transactionLineMap.get(order.Id)) {
                if(tl.OrderApi__Type__c != 'Cash'){
                    tl.OrderApi__Debit__c = 0-tl.OrderApi__Debit__c;
                }
                
                Integer monthsBetween = LastJan.monthsBetween(tl.OrderApi__Date__c)+1;
                
                
                for(integer i = monthsBetween; i <= 24; i++){
                    if(monthxamountmap.containsKey(i)){
                        decimal current = monthxamountmap.get(i);
                        current += tl.OrderApi__Debit__c;
                        monthxamountmap.put(i, current);
                    }else{
                        monthxamountmap.put(i, tl.OrderApi__Debit__c);
                    }
                    if(monthsBetween < remaining){
                       remaining = monthsBetween; 
                    }
                    System.debug('i: '+i);
                }
            }
            for(integer j = 1; j < remaining; j++){
                if(!monthxamountmap.containsKey(j)){
                    monthxamountmap.put(j, 0);
                }
            }
            
            order.Amount_Due_as_of_Last_January__c = order.OrderApi__Total__c - monthxamountmap.get(1);
            order.Amount_Due_as_of_Last_February__c = order.OrderApi__Total__c - monthxamountmap.get(2);
            order.Amount_Due_as_of_Last_March__c = order.OrderApi__Total__c - monthxamountmap.get(3);
            order.Amount_Due_as_of_Last_April__c = order.OrderApi__Total__c - monthxamountmap.get(4);
            order.Amount_Due_as_of_Last_May__c = order.OrderApi__Total__c - monthxamountmap.get(5);
            order.Amount_Due_as_of_Last_June__c = order.OrderApi__Total__c - monthxamountmap.get(6);
            order.Amount_Due_as_of_Last_July__c = order.OrderApi__Total__c - monthxamountmap.get(7);
            order.Amount_Due_as_of_Last_August__c = order.OrderApi__Total__c - monthxamountmap.get(8);
            order.Amount_Due_as_of_Last_September__c = order.OrderApi__Total__c - monthxamountmap.get(9);
            order.Amount_Due_as_of_Last_October__c = order.OrderApi__Total__c - monthxamountmap.get(10);
            order.Amount_Due_as_of_Last_November__c = order.OrderApi__Total__c - monthxamountmap.get(11);
            order.Amount_Due_as_of_Last_December__c = order.OrderApi__Total__c - monthxamountmap.get(12);
            order.Amount_Due_as_of_Current_January__c = order.OrderApi__Total__c - monthxamountmap.get(13);
            order.Amount_Due_as_of_Current_February__c = order.OrderApi__Total__c - monthxamountmap.get(14);
            order.Amount_Due_as_of_Current_March__c = order.OrderApi__Total__c - monthxamountmap.get(15);
            order.Amount_Due_as_of_Current_April__c = order.OrderApi__Total__c - monthxamountmap.get(16);
            order.Amount_Due_as_of_Current_May__c = order.OrderApi__Total__c - monthxamountmap.get(17);
            order.Amount_Due_as_of_Current_June__c = order.OrderApi__Total__c - monthxamountmap.get(18);
            order.Amount_Due_as_of_Current_July__c = order.OrderApi__Total__c - monthxamountmap.get(19);
            order.Amount_Due_as_of_Current_August__c = order.OrderApi__Total__c - monthxamountmap.get(20);
            order.Amount_Due_as_of_Current_September__c = order.OrderApi__Total__c - monthxamountmap.get(21);
            order.Amount_Due_as_of_Current_October__c = order.OrderApi__Total__c - monthxamountmap.get(22);
            order.Amount_Due_as_of_Current_November__c = order.OrderApi__Total__c - monthxamountmap.get(23);
            order.Amount_Due_as_of_Current_December__c = order.OrderApi__Total__c - monthxamountmap.get(24);
            SOstoup.add(order);
            
        }
        Database.update(SOstoup, false);
        
    }
    
    global void finish(Database.BatchableContext bc) {
        // Do any additional processing or cleanup here
    }
}