@isTest
public class AddPrimaryContactTest {
    
    @testSetup
    static void setup() {
        List<Account> insertAccount = new List<Account>();
        for(integer i=0; i<=100; i++) {
            if(i <=50) {
                insertAccount.add(new Account(Name='Acc'+i, BillingState = 'NY'));
            } else {
                insertAccount.add(new Account(Name='Acc'+i, BillingState = 'CA'));
            }
        }
        insert insertAccount;
    }
    
    static testMethod void testAddPrimaryContact() {
        Contact con = new Contact(LastName = 'LastName');
        AddPrimaryContact addPC = new AddPrimaryContact(con, 'CA');
        Test.startTest();
        system.enqueueJob(addPC);
        Test.stopTest();
        
        system.assertEquals(50, [select count() from Contact]);
    }
    
}