trigger oppcount on Opportunity (after insert, after delete, after update) {
    if(Trigger.isInsert){
        {
            Set<Id> AccountIds = new Set<Id>();
            
            list<Account> accList = new List<Account>();
            for(Opportunity op : trigger.new)
            {
                AccountIds.add(op.AccountId);
            }
            
            List<AggregateResult> lstResult = [SELECT AccountId, COUNT(Id) countId 
                                               FROM Opportunity 
                                               WHERE AccountId IN:AccountIds
                                               GROUP BY AccountId];
            
            List<Account> lstAccount = new List<Account>();
            for(AggregateResult result:lstResult)
            {
                Account acct = new Account (Id=(Id)result.get('AccountId'), 
                                            total_opportunity__c = (Integer)result.get('countId'));
                
                lstAccount.add(acct);
            }
            
            update lstAccount; 
        }
    }
}