@isTest
public class CalculateRemainingToBeRecognizedTest {
	@testSetUp
    static void setup(){
     OrderApi__Sales_Order__c salesOrder = new  OrderApi__Sales_Order__c(Remaining_to_be_Recognized__c = 20000);
     insert salesOrder;
     List<OrderApi__Transaction__c> transactionList = new List<OrderApi__Transaction__c>();    
     for(Integer i=0;i<5;i++){ 
     	OrderApi__Transaction__c trans = new OrderApi__Transaction__c(
			OrderApi__Type__c = 'Revenue Recognition',
			OrderApi__Date__c = System.today().addMonths(i-1),
			OrderApi__Sales_Order__c = salesOrder.Id
		);
		transactionList.add(trans);
     }
     insert transactionList;
     List<OrderApi__Transaction_Line__c>transactionLineList = new List<OrderApi__Transaction_Line__c>();  
     for(Integer i=0;i<5;i++){ 
     	OrderApi__Transaction_Line__c transactionLine = new OrderApi__Transaction_Line__c(
			OrderApi__Transaction__c = transactionList[i].Id,
			OrderApi__Credit__c = 4000
		);
		transactionLineList.add(transactionLine);
     }
	 insert transactionLineList;
    }
    
	@isTest
    static void test(){
        Test.startTest();
        CalculateRemainingToBeRecognizedBatch tobeRecognized = new CalculateRemainingToBeRecognizedBatch();
		Id batchId = Database.executeBatch(tobeRecognized);
        Test.stopTest();
        OrderApi__Sales_Order__c result = [SELECT Remaining_to_be_Recognized__c FROM OrderApi__Sales_Order__c LIMIT 1];
        Assert.areEqual(16000, result.Remaining_to_be_Recognized__c);
    }
}