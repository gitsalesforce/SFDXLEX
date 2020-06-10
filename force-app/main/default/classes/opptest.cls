@isTest
public class opptest {
    @testSetup static void setup(){
        List<Account> accts = new List<Account>();
        for(Integer i=0;i<1;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer j=0;j<1;j++) {
            Account acct = accts[j];
            // For each account just inserted, add opportunities
            for (Integer k=0;k<1;k++) {
                opps.add(new Opportunity(Name=acct.Name + ' TestOpp' + k,
                                         StageName='Prospecting',
                                         CloseDate=System.today().addMonths(1),
                                         AccountId=acct.Id));
            }
        }
        // Insert all opportunities for all accounts.
        insert opps;
    }
  
    @isTest static void testmethod1(){
        Opportunity opp1 = [select id,StageName from Opportunity where Name ='TestOpp1' LIMIT 1];
        opp1.StageName='Closed Won';
		update opp1;
        Account a = [select id,total_opportunity__c from Account where name='TestAccount1' LIMIT 1 ];
        System.assertEquals(1,a.total_opportunity__c);
    }
}