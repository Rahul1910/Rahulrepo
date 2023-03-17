@isTest
public class CreateActivityTest {
    
    private static testMethod void doTest() {
        
        Test.startTest();
        
        Account acc = new Account(name='TestAccount');
        insert acc;
        Contact con = new contact(accountid = acc.Id, firstname = 'SampleDemoTestOpportunity', lastname = 'Test');
        insert con;
        CreateActivity.CreateActivityContact(Con.Id);
        Test.stopTest();
    }
}