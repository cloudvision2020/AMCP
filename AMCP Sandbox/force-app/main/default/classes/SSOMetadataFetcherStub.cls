@IsTest
public class SSOMetadataFetcherStub implements SSOMetadataFetcher {
  private List<SSOCustomFields__mdt> testRecords { get; set; }
  public SSOMetadataFetcherStub(List<SSOCustomFields__mdt> testRecords) {
    this.testRecords = testRecords;
  }
  public List<SSOCustomFields__mdt> getSSOCustomFieldsByIds() {
    return testRecords;
  }
}