@isTest
private class SDAddToMassMergeTest {
    @isTest
    private static void SDAddToMassMergeTest() {
        Integer numJobsToCreate = 20;
        List<OrderApi__Subscription__c> selectedSubscriptions = [
            SELECT Id, Name
            FROM OrderApi__Subscription__c
            LIMIT :numJobsToCreate
        ];
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(selectedSubscriptions);
        ssc.setSelected(selectedSubscriptions);                                                                
        SDAddToMassMerge sdatmm = new SDAddToMassMerge(ssc);
        String objectNameTest = '[SDAddToMassMerge Test]';
        sdatmm.createMassMergeJobs();
        Integer numJobsCreated = Database.countQuery(
            'SELECT COUNT() '
            + 'FROM SDOC__SDJob__c '
            + 'WHERE SDOC__ObjApiName__c=\'' + objectNameTest + '\''
        );
        // System.assert(numJobsCreated == numJobsToCreate);
    }
}