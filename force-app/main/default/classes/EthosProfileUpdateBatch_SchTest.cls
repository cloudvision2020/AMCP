@isTest
public class EthosProfileUpdateBatch_SchTest {
	@isTest
    public static void testSchedule(){
        String CRON_EXP = '0 0 0 2 11 ? 2024';
        test.startTest();
        String jobId = System.schedule('TestEthosProfileUpdateBatch', CRON_EXP, new EthosProfileUpdateBatch_Sch());
        test.stopTest();
        System.assertNotEquals(null, jobId);
    }
}