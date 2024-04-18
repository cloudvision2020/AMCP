@IsTest
private class SSOMetadataFetcherImplTest {
  private static SSOMetadataFetcherImpl fetcher = new SSOMetadataFetcherImpl();
  private static List< SSOCustomFields__mdt> existingRecords;
  private static List< SSOCustomFields__mdt> fetchedRecords;

  private static void getRecordsUsingSOQL() {
    existingRecords = new List< SSOCustomFields__mdt>();
    existingRecords = new List< SSOCustomFields__mdt> ([SELECT Id FROM SSOCustomFields__mdt]);
  }

  private static void getRecordsThroughClass() {
    fetchedRecords = fetcher.getSSOCustomFieldsByIds();
  }

  @IsTest
  private static void validateRecordsWereFetchedAndProperFieldsReturned() {
    getRecordsUsingSOQL();
    System.assertNotEquals(null, existingRecords);
    System.assert(!existingRecords.isEmpty());

    Test.startTest();
    getRecordsThroughClass();
    Test.stopTest();

    System.assertNotEquals(null, fetchedRecords);
    System.assert(!fetchedRecords.isEmpty());
    System.assertEquals(existingRecords.size(), fetchedRecords.size());
  }
}