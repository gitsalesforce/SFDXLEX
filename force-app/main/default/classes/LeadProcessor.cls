global class LeadProcessor implements Database.Batchable<sObject> , Database.Stateful{
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            [SELECT LEADSOURCE FROM Lead]
        );
    }
    global void execute(Database.BatchableContext bc,list<Lead> ls){
        
        for(Lead ll:ls){
            ll.LeadSource='Salesforce';
        }
        update ls;
        // increment the instance member counter
        recordsProcessed = recordsProcessed + 1;
    }
    
    global void finish(Database.BatchableContext bc){
            System.debug(recordsProcessed + ' final records processed!');
            AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                                JobItemsProcessed,
                                TotalJobItems, CreatedBy.Email
                                FROM AsyncApexJob
                                WHERE Id = :bc.getJobId()];

        
    }  
}