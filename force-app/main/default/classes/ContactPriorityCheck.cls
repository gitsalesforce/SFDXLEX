@isTest
public class ContactPriorityCheck {
    @testSetup static void setup(){
        List<Account> accts = new List<Account>();
        for(Integer i=0;i<1;i++) {
            accts.add(new Account(Name='TestAccount' + i));
        }
        insert accts;
        system.debug(accts);
        List<Contact> opps = new List<Contact>();
        for (Integer j=0;j<1;j++) {
            Account acct = accts[j];
            // For each account just inserted, add Contact
            for (Integer k=0;k<1;k++) {
                opps.add(new Contact(LastName=acct.Name + 'ContactHigh' + k,Customer_Priority__c='High',
                                     AccountId=acct.Id));
            }
        }
        system.debug(opps);
        // Insert all Contact for all accounts.
        insert opps;
    }
    @isTest static void testmethod1(){
        Account opp1 = [select id,Name,CustomerPriority__c from Account where Name ='TestAccount0' LIMIT 1];
        system.debug(opp1);
        Contact cc1 = [select id,LastName,Customer_Priority__c from Contact where LastName='TestAccount0ContactHigh0'];
        system.debug(cc1);
        System.assertEquals(opp1.CustomerPriority__c,cc1.Customer_Priority__c);
        cc1.Customer_Priority__c='Medium';
        update cc1;
        System.assertEquals('High',opp1.CustomerPriority__c);//High Account after Medium
        cc1.Customer_Priority__c='Low';
        update cc1;
        System.assertEquals('High',opp1.CustomerPriority__c);//High Account after Low
        
    }
     @isTest static void testmethod3(){
        Account opp1 = [select id,Name,CustomerPriority__c from Account where Name ='TestAccount0' LIMIT 1];
        system.debug(opp1);
        Contact cc1 = [select id,LastName,Customer_Priority__c from Contact where LastName='TestAccount0ContactHigh0'];
        system.debug(cc1);
        System.assertEquals(cc1.Customer_Priority__c,opp1.CustomerPriority__c);
        cc1.Customer_Priority__c='Medium';
        update cc1;
        System.assertEquals('High',opp1.CustomerPriority__c);//High Account after Medium
        cc1.Customer_Priority__c='Low';
        update cc1;
        System.assertEquals('Medium',opp1.CustomerPriority__c);//High Account after Low
        cc1.Customer_Priority__c='High';
        update cc1;
        System.assertEquals('High',opp1.CustomerPriority__c);//High Account after Low
        cc1.Customer_Priority__c='Low';
        update cc1;
        System.assertEquals('High',opp1.CustomerPriority__c);//High Account after Low
        
    }
     @isTest static void testmethod2(){
        Account opp1 = [select id,Name,CustomerPriority__c from Account where Name ='TestAccount0' LIMIT 1];
        system.debug(opp1);
        Contact cc1 = [select id,LastName,Customer_Priority__c from Contact where LastName='TestAccount0ContactHigh0'];
        system.debug(cc1);
        delete cc1;
        System.assertEquals(null,opp1.CustomerPriority__c);        
    }
   
}