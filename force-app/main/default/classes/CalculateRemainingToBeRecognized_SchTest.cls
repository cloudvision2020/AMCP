@isTest
public class CalculateRemainingToBeRecognized_SchTest {
	@isTest
    public static void testSchedule(){
        String CRON_EXP = '0 0 0 3 9 ? 2023';
        test.startTest();
        String jobId = System.schedule('TestCalculateRemainingToBeRecognizedBatch', CRON_EXP, new CalculateRemainingToBeRecognized_Sch());
        test.stopTest();
        System.assertNotEquals(null, jobId);
    }
}