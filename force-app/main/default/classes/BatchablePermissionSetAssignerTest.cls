@IsTest
private class BatchablePermissionSetAssignerTest {
  private static final String profileName = 'Fonteva Customer Community Login';
  private static final String permsetName = 'Ethos_Checkout';

  @IsTest
  public static void executeBatch() {

    Test.startTest();

    BatchablePermissionSetAssigner batchJob = BatchablePermissionSetAssigner.getForProfile(permsetName, profileName);
    Database.executeBatch(batchJob);

    Test.stopTest();

  }
}