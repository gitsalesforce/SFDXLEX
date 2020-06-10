@isTest
public class LeadProcessorTest {
    //Below is a method with @testsetup annotation, the name can be anything like setup(), oneTimeData(), etc.
    @testSetup static void setup() {
        // Create common test accounts
        List<Lead> testlead = new List<Lead>();
        for(Integer i=0;i<1000;i++) {
            testlead.add(new Lead(FirstName = 'TestLead',LastName='Last'+i,Company='Grazitti'));
        }
        insert testlead;
    }
    @isTest static void testMethod1() {
        // Here, we will see if test data created in setup method is available or not, Get the first test account by using a SOQL query
        list<Lead> acct = [SELECT Id FROM Lead WHERE Company='Grazitti'];
        system.debug(acct.size());
        // Modify first account
        Test.startTest();
        LeadProcessor L = new LeadProcessor();
        Database.executeBatch(L);
        Test.stopTest();
        
        // Perform some testing
    }
    
}