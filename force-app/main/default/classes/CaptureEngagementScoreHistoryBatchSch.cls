global class CaptureEngagementScoreHistoryBatchSch implements Schedulable  {
 global void execute(SchedulableContext SC) {
      
        CaptureEngagementScoreHistoryBatch cESHB = new CaptureEngagementScoreHistoryBatch();
        Database.executeBatch(cESHB);
    }
      // CaptureEngagementScoreHistoryBatch schBatch = new CaptureEngagementScoreHistoryBatch(); 
        // System.schedule('Capture Engagement Score - 1st of Every Month at 12:00 AM', '0 0 1 * *', schBatch);
}