//Batch to Create contract under the opportunities which are created in current week and their stage is closed won.
global class BatchContract  implements Database.Batchable<sObject>, Database.Stateful{
    global Map<Id, String> errorMap {get; set;}
    global Map<Id, SObject> IdToSObjectMap {get; set;}
    global list<Contract> conttoinsert {get;set;}
    global final String Query;
    global final list<Contract> lss;//store next contract list to update operation
    
    global BatchContract(String q,list<Contract> lss){
        errorMap = new Map<Id, String>();
        IdToSObjectMap = new Map<Id, SObject>();
        conttoinsert = new list<Contract>();
        Query=q; //passing from Schedular class 
        lss=lss;//passing user list query
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(!String.isEmpty(Query)){
            return Database.getQueryLocator(Query);
        }
        else{
            return Database.getQueryLocator(
                [SELECT id,OwnerId,Owner.name,Owner.alias,name,CloseDate,AccountId FROM Opportunity where StageName='Closed Won' and CreatedDate > LAST_WEEK]
            );}
    }
    global void execute(Database.BatchableContext bc,list<Opportunity> ls){
        System.debug(LoggingLevel.INFO, '== List size ==' + ls.size());
        if(!ls.isEmpty()){
            for(Opportunity opp:ls){
                Contract con = new Contract();
                con.Status='Draft';//required
                con.StartDate=system.today();//required
                con.ContractTerm=21;//required
                con.AccountId=opp.AccountId;//required
                con.SBQQ__Opportunity__c=opp.id;
                conttoinsert.add(con);
                if(conttoinsert.size() > 0) {
                    Database.SaveResult [] dsrs = Database.insert(conttoinsert, false);
                    for(Database.SaveResult dsr : dsrs){
                        if(!dsr.isSuccess()){
                            String errMsg = dsr.getErrors()[0].getMessage();
                            errorMap.put(opp.Id, errMsg);
                            IdToSObjectMap.put(opp.Id, opp);
                            system.debug(errMsg);
                            
                        }
                    }
                }
            }
        }
    }
    global void finish(Database.BatchableContext BC) { 
        //check if the user query is empty and conttoinsert list is not empty,then execute the default query
        if(lss.isEmpty() && (!conttoinsert.isEmpty())){
            //calling the next batch for contactterm updation Default
            Database.executeBatch(new UpdateContractBatch(conttoinsert));
        }
        //else fire the user query list
        else{
            //If the query is passed in schedular class
            Database.executeBatch(new UpdateContractBatch(lss));
        }
        //Send an email to the User after your batch completes 
        AsyncApexJob a = [SELECT id, ApexClassId,
                          JobItemsProcessed, TotalJobItems,
                          NumberOfErrors, CreatedBy.Email
                          FROM AsyncApexJob
                          WHERE id = :BC.getJobId()];
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  
        
        Messaging.EmailFileAttachment emailinst = new Messaging.EmailFileAttachment();
        String body = 'The batch job '
            + 'BatchApexContractInsert '
            + 'has finished. \n' 
            + 'There is'
            + errorMap.size()
            + ' errors. find the error list or success list attached to the Case.';
        
        // Creating the CSV file of error Records
        String finalstr = 'Id, Name, Error \n';
        String subject = 'Opportunity to Contract - Apex Batch Error List';
        String attName = 'Contract Errors.csv';
        for(Id id  : errorMap.keySet()){
            string err = errorMap.get(id);
            //mapping the errormap fileds
            Opportunity opps = (Opportunity) IdToSObjectMap.get(id);
            string recordString = '"'+id+'","'+opps.Name+'","'+err+'"\n';
            finalstr = finalstr +recordString;
        } 
        //Error Report Email
        if(!errorMap.isEmpty()){
            emailinst.setFileName(attName);
            emailinst.setBody(Blob.valueOf(finalstr));
            email.setToAddresses( new String[] {a.CreatedBy.Email} );
            // Sets the paramaters of the email
            email.setSubject( subject );
            email.setPlainTextBody( body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {emailinst});
            // Sends the email
            Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
            
        }
        
        
    }
}