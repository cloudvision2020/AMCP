public class CalculateRemainingToBeRecognizedBatch implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext bc) {
          return Database.getQueryLocator('SELECT Id,OrderApi__Sales_Order__c FROM OrderApi__Transaction__c WHERE OrderApi__Type__c = \'Revenue Recognition\' AND OrderApi__Sales_Order__r.Remaining_to_be_Recognized__c != null ORDER BY OrderApi__Sales_Order__c');
    }
    
    public void execute(Database.BatchableContext bc, List<OrderApi__Transaction__c> scope){
        Set<Id> transactions = new Set<Id>();
        Set<Id> salesOrderIds = new Set<Id>();
        for(OrderApi__Transaction__c trans: scope){
            transactions.add(trans.Id);
            salesOrderIds.add(trans.OrderApi__Sales_Order__c);
        }
        
        List<AggregateResult> transactionsPendingXSalesOrder = [SELECT OrderApi__Sales_Order__c, Sum(OrderApi__Total_Credits__c) sumOfPendingCredits FROM OrderApi__Transaction__c WHERE Id IN:transactions AND OrderApi__Date__c >= TODAY GROUP BY OrderApi__Sales_Order__c ];
        Map<Id,Decimal> remainingXSalesOrderMap = new Map<Id,Decimal>();
        for(AggregateResult transactionLine : transactionsPendingXSalesOrder){
            String salesOrderId = String.valueOf(transactionLine.get('OrderApi__Sales_Order__c'));
            Decimal toBeRecognized = Decimal.valueOf(String.valueOf(transactionLine.get('sumOfPendingCredits')));
            remainingXSalesOrderMap.put(salesOrderId, toBeRecognized);
        }
        
        for(Id SOId : salesOrderIds){
            if(!remainingXSalesOrderMap.keySet().contains(SOId)){
                remainingXSalesOrderMap.put(SOId,0);
            }
        }
		
        List<OrderApi__Sales_Order__c> salesOrdersToUpdate = new List<OrderApi__Sales_Order__c>();
        for(OrderApi__Sales_Order__c salesOrder : [SELECT Id,Remaining_to_be_Recognized__c, OrderApi__Amount_Refunded__c, 
                                                   OrderApi__Credits_and_Adjustments__c, OrderApi__Credits_Applied__c, OrderApi__Overall_Total__c  
													FROM OrderApi__Sales_Order__c 
                                                   	WHERE Id IN :remainingXSalesOrderMap.keySet() ]){
           	Decimal soAmount = 0;
        	if(salesOrder.OrderApi__Amount_Refunded__c != null && salesOrder.OrderApi__Amount_Refunded__c != 0){
            	soAmount = soAmount - salesOrder.OrderApi__Amount_Refunded__c;
            }
            if(salesOrder.OrderApi__Credits_and_Adjustments__c != null && salesOrder.OrderApi__Credits_and_Adjustments__c != 0){
            	soAmount = soAmount + salesOrder.OrderApi__Credits_and_Adjustments__c;
            }
            /*if(salesOrder.OrderApi__Credits_Applied__c != null && salesOrder.OrderApi__Credits_Applied__c != 0){
            	soAmount = soAmount - salesOrder.OrderApi__Credits_Applied__c;
            }*/
                                                        
            if(soAmount != 0 && (remainingXSalesOrderMap.get(salesOrder.Id) + soAmount) <= 0){
            	salesOrder.Remaining_to_be_Recognized__c = 0;
            } else if((remainingXSalesOrderMap.get(salesOrder.Id) + soAmount) > 0){
            	salesOrder.Remaining_to_be_Recognized__c = remainingXSalesOrderMap.get(salesOrder.Id) + soAmount;
            }
            salesOrdersToUpdate.add(salesOrder); 
        }
        
        if(!salesOrdersToUpdate.isEmpty()){
            update salesOrdersToUpdate;
        }        
    }
    public void finish(Database.BatchableContext bc){
        
    }
    

}