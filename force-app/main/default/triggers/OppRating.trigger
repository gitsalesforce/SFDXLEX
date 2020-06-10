//Apex trigger to update account rating when the opportunity stage equals closed won
trigger OppRating on Opportunity (before insert,before update) {
    if(Trigger.isInsert || Trigger.isUpdate){
        list<Account> ls = new list<Account>();
        list<Opportunity> latestacc = Trigger.isDelete?Trigger.old:Trigger.new;
        map<id,Opportunity> mapopp = new map<id,Opportunity>();
        for(Opportunity opp :latestacc){
            mapopp.put(opp.AccountID,opp);
        }
        System.debug('Number of Queries used in this apex code so far:'+Limits.getQueries());
        System.debug('Number of rows queried in this apex code so far:'+Limits.getDMLRows());
        System.debug('Number of DML statment used so far:'+Limits.getDmlStatements());
        System.debug('Amount of CPU time (in ms) used so far:'+Limits.getCpuTime());
        if(mapopp.size()+Limits.getDmlRows()>Limits.getLimitDmlRows()){
            for(ID oid :mapopp.keySet()){
                Account a = new Account();
                a.Id=oid;
                if(mapopp.get(oid).stageName=='Closed Won'){
                    a.Rating='Hot';
                    ls.add(a);
                } 
                else{
                    a.Rating=null;
                    ls.add(a);
                }
            } 
        }
        update ls;
    }
}