@isTest
private class captureEngagementScoreHistoryBatchTest {

    @testSetup static void setup() {
     Contact contact = new Contact();
     contact.FirstName = 'Test First';
     contact.LastName = 'Test';
     insert contact;
    }
    @isTest
    private static void batchTest() {
        CaptureEngagementScoreHistoryBatch cESHB = new CaptureEngagementScoreHistoryBatch();
        Database.executeBatch(cESHB);
    }
    @isTest
    private static void scheduleBatch() {
      	CaptureEngagementScoreHistoryBatchSch schBatch = new CaptureEngagementScoreHistoryBatchSch(); 
     	String sch = '20 30 8 10 2 ?';
       	System.schedule('Capture Engagement Score', sch, schBatch);
    }

}