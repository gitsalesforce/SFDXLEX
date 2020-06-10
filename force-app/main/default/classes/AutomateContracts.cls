///***Batch Apex Class**
global class AutomateContracts implements Database.Batchable<SObject>, Database.Stateful 
{ 
    global Integer recordsProcessed = 0; 
    global Database.QueryLocator start(Database.BatchableContext bc)
    { 
        return Database.getQueryLocator( 'SELECT SBQQ__RenewalForecast__c, SBQQ__RenewalQuoted__c, Id FROM Contract WHERE SBQQ__RenewalForecast__c = FALSE AND SBQQ__RenewalQuoted__c = FALSE' ); 
    } 
    global void execute(Database.BatchableContext bc, List<Contract> scope)
    { 
        for(Contract contract:scope)
        { contract.SBQQ__RenewalForecast__c = TRUE;
         recordsProcessed = recordsProcessed + 1;
        } 
        update scope;
    } global void finish(Database.BatchableContext bc)
    { 
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        String[] toAddresses = new String[] {a.CreatedBy.Email}; 
            mail.setToAddresses(toAddresses);
        mail.setSubject('Contract Renewal Batch ' + a.Status);
        mail.setPlainTextBody ('The batch Apex job processed ' + a.TotalJobItems);
    }
}