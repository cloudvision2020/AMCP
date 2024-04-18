@isTest
public class UpdateMembershipAndContactFields_SchTest {
	@isTest
    public static void testSchedule(){
        String CRON_EXP = '0 0 0 3 9 ? 2023';
        test.startTest();
        String jobId = System.schedule('TestUpdateMembershipAndContactFieldsBatch', CRON_EXP, new UpdateMembershipAndContactFields_Sch());
        test.stopTest();
        System.assertNotEquals(null, jobId);
    }
}