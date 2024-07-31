@isTest
public class JoinProcessServiceTest {
    @testSetup
    static void setup() {
        // Setup any common test data if needed
    }

    @isTest
    static void testGoToNextStep() {
        // Mock the parameter
        Test.setCurrentPage(new PageReference('/apex/somePage?id=testStepId'));
        
        // Create a test instance of the service
        JoinProcessService service = new JoinProcessService();
        
        // Mocking the joinUtil dependency (simplified)
        joinApi.JoinUtils joinUtilMock = new joinApi.JoinUtils('testStepId');
        joinUtilMock.navStepsMap.put('Next', 'http://test.domain.go/next');
        Test.setMock(joinApi.JoinUtils.class, joinUtilMock);
        
        Test.startTest();
        PageReference result = service.goToNextStep();
        Test.stopTest();

        // Validate the result
        System.assertNotEquals(null, result);
        System.assertEquals('http://test.domain.go/next', result.getUrl());
    }

    @isTest
    static void testCancel() {
        // Mock the parameter
        Test.setCurrentPage(new PageReference('/apex/somePage?id=testStepId'));
        
        // Create a test instance of the service
        JoinProcessService service = new JoinProcessService();
        
        // Mocking the joinUtil dependency (simplified)
        joinApi.JoinUtils joinUtilMock = new joinApi.JoinUtils('testStepId');
        joinUtilMock.navStepsMap.put('First', 'http://test.domain.go/first');
        Test.setMock(joinApi.JoinUtils.class, joinUtilMock);
        
        Test.startTest();
        PageReference result = service.cancel();
        Test.stopTest();

        // Validate the result
        System.assertNotEquals(null, result);
        System.assertEquals('http://test.domain.go/first', result.getUrl());
    }
}