global class GenericBatchDMLOperation implements Database.Batchable<sObject>,Database.Stateful {
    
    public Set<String> possibleDmlOperation = new Set<String>{'Insert','Update','Delete','Upsert','Undelete'};
    public String dmlOperation;
    public List<SObject> sobjList = new List<SObject>();
    public SObject statusSObject;
    public String statusSObjectFieldName;
    public AsyncApexJob aAJ;
    public Boolean updateQuote;
    
    global GenericBatchDMLOperation(List<SObject> sobjListPassed, 
                                                             String dmlOperationPassed,
                                                             Id statusSObjectIdPassed, 
                                                             String statusSObjectFieldNamePassed){
		Schema.SObjectType sobjectType = statusSObjectIdPassed.getSObjectType();
		String sobjectName = sobjectType.getDescribe().getName();
		statusSObject = Database.query('Select '+ statusSObjectFieldNamePassed +' From ' + sobjectName + ' Where Id = :statusSObjectIdPassed');
		statusSObjectFieldName = statusSObjectFieldNamePassed;
		 
        sobjList = sobjListPassed;  
        if(possibleDmlOperation.contains(dmlOperationPassed)) 
        	dmlOperation = dmlOperationPassed;        	                            
    }

    global List<SObject> start(Database.BatchableContext BC) {
    	aAJ = [ SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email
                FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        if(aAJ != null && statusSObject!=null && statusSObjectFieldName!=null) {
        	statusSObject.put(statusSObjectFieldName,aAJ.Status);
            update statusSObject;
        } 
        return sobjList;    
    }
   
    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        if(dmlOperation == 'Insert')
            Insert scope;
        else if(dmlOperation == 'Update')
            Update scope;    
        else if(dmlOperation == 'Delete')
            Delete scope;    
        else if(dmlOperation == 'Upsert')
            Upsert scope;    
        else if(dmlOperation == 'Undelete')
            Undelete scope;                
    }   
    
    global void finish(Database.BatchableContext BC) {
    	aAJ = [ SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email
                FROM AsyncApexJob WHERE Id = :BC.getJobId()];
    	if(aAJ != null && statusSObject!=null && statusSObjectFieldName!=null) {
        	statusSObject.put(statusSObjectFieldName,aAJ.Status);
            update statusSObject;
        }          
    }
}