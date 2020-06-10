//Second Batch to Update the contract which were created by another batch
global class UpdateContractBatch implements Database.batchable<SObject>, Database.Stateful{
    global Map<Id, String> errorMap {get; set;}
    global Map<Id, SObject> IdToSObjectMap {get; set;}
    global final List<Contract> lstContractId;
    global UpdateContractBatch(List<Contract> lstContractId) {
        this.lstContractId = lstContractId;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([select id,OwnerId,AccountId,ContractTerm,CustomerSignedTitle,Description from Contract where id in:lstContractId]);
    }
    global void execute(Database.BatchableContext bc,list<Contract> ls){
        list<Contract> ll = new list<Contract>();
        //Map of Accountid-Contract
        map<id,Contract> mops = new map<id,Contract>();
        for(Contract cc:ls){
            mops.put(cc.AccountId,cc);
        }
        system.debug(mops);
        //list of Ownerid of opportunity of same accountid of contract.
        list<Opportunity> ls0 = new list<Opportunity>([select ownerid,contractid from Opportunity where AccountId in :mops.keySet()]);
        if(ls.size()>0){
            for(Contract opp:ls){
                opp.Ownerid= ls0.get(0).ownerid;
                opp.ContractTerm=89;//update the contractterm in months
                opp.CustomerSignedTitle='Amit Kumar';
                opp.Description='This is updated Batch Record';
                ll.add(opp);
            }
        }
        try{
            update ll;
        }
        catch(Exception ex){
            system.debug(ex);
        }
    }
    global void finish(Database.BatchableContext BC) { 
        //Send an email to the User after your batch completes 
        AsyncApexJob a = [SELECT id, ApexClassId,
                          JobItemsProcessed, TotalJobItems,
                          NumberOfErrors, CreatedBy.Email
                          FROM AsyncApexJob
                          WHERE id = :BC.getJobId()];
        
        //Sending the error report
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  
        
        Messaging.EmailFileAttachment emailinst = new Messaging.EmailFileAttachment();
        String body = 'The batch job '
            + 'BatchApexContractUpdateOperation '
            + 'has finished. \n' 
            + 'There is'
            + errorMap.size()
            + ' errors. find the error list attached to the Case.Unbale to Update the Contracts aRecords';
        
        // Creating the CSV file of error Records
        String finalstr = 'Id, Name, Error \n';
        String subject = 'ContractUpdation Failed Report - Apex Batch Error List';
        String attName = 'Contract Update Errors.csv';
        for(Id id  : errorMap.keySet()){
            string err = errorMap.get(id);
            //mapping the errormap fileds
            Contract opps = (Contract) IdToSObjectMap.get(id);
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