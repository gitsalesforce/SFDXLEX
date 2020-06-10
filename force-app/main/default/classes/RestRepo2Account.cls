@RestResource(urlMapping='/Account/*')
global with sharing class RestRepo2Account {
    @HttpGet 
    global static list<Account> getAccountById() {
        RestRequest request = RestContext.request;
        String accId = request.params.get('id');
        list<Account> acclist = new list<Account>();
        //check if the string is not empty
        if(String.isNotEmpty(accId)){
            for(Account result :  [SELECT id,name,phone FROM Account WHERE Id = :accId])
            {
                acclist.add(result);
            }
        }
        //check if the string is empty
        else if(String.isEmpty(accId)){
            for(Account result :  [SELECT id,name,phone FROM Account]){
                acclist.add(result);
            } 
        }
        return acclist;
    }
    //Wrapper fro Post Method
    global class GenericResponse
    {
        public Integer status;
        public String Message;
        
    }
    global class CustomReq
    {
        public CustomAccount account;
        
    }
    global class CustomAccount
    {
        public String name;
        public String phone;
        public list<CustomOpportunity> Opportunity; //Use list here
    }
    global class CustomOpportunity
    {
        public String name;
        public String CloseDate;
        public String StageName;
    }
    @HttpPost
    global static GenericResponse createNewAccountRecords() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Blob body = req.requestBody;
        String requestString = body.toString();
        CustomAccount deswrap = (CustomAccount) JSON.deserialize(requestString, CustomAccount.class);
        Savepoint savePoint = Database.setSavepoint();
        GenericResponse response= new GenericResponse();
        try
        {
            Account accountRecord = new Account ();
            accountRecord.Name = deswrap.name;
            accountRecord.Phone = deswrap.phone;
            response.status=RestContext.response.statusCode;//status
            insert accountRecord;
            //insert opportunity
            list<Opportunity> oppsnew = new list<Opportunity>();
            for(integer i=0;i<deswrap.Opportunity.size();i++){
                Opportunity oopsRecord = new Opportunity ();
                oopsRecord.AccountId = accountRecord.Id;
                oopsRecord.Name = deswrap.Opportunity.get(i).name;
                oopsRecord.CloseDate = Date.valueOf(deswrap.Opportunity.get(i).CloseDate);
                oopsRecord.StageName = deswrap.Opportunity.get(i).StageName;
                oppsnew.add(oopsRecord);
            }
            if(oppsnew.size()>0){
                insert oppsnew;
                response.message='Success'+oppsnew.size()+' Opportunity Added';//message
                response.status=RestContext.response.statusCode;//status
            }
            
        }
        catch (Exception e)
        {
            Database.rollback(savePoint);
            response.message='Failed';
            
        }
        return response;
    }   
    @HttpDelete
    global static void deleteAccount() {
        RestRequest request = RestContext.request;
        String accid = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Account thisaccount = [SELECT Id FROM account WHERE Id = :accid];
        delete thisaccount;
    }     
    @HttpPut
    global static ID upsertaccount(String accname,String accphone, String id) {
        Account thisacc = new Account(
            Id=id,
            name=accname,
            phone=accphone);
        upsert thisacc;
        // Return the Account ID.
        return thisacc.Id;
    }
    @HttpPatch
    global static ID updateaccountFields() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Account thisaccount = [SELECT Id FROM account WHERE Id = :accountId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            thisaccount.put(fieldName, params.get(fieldName));
        }
        update thisaccount;
        return thisaccount.Id;
    }    
}