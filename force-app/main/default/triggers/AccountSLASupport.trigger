trigger AccountSLASupport on Account (before insert,before update) {
    if(Trigger.isInsert || Trigger.isUpdate){
        set<ID> latestid = new set<ID>();
        list<Account> latestacc = Trigger.isDelete?Trigger.old:Trigger.new;
        for(Account a:latestacc){
            latestid.add(a.ParentId);
        }
        system.debug(latestid);
        map<id,Account> mapacc= new map<id,Account>([select id,ParentId,SLASerialNumber__c from Account where id in:latestid]);
        system.debug(mapacc);
        for(Account accupdate:latestacc){
            if(mapacc.size()+Limits.getDmlRows()>Limits.getLimitDmlRows()){
                for(ID a:mapacc.keySet()){
                    accupdate.SLASerialNumber__c=mapacc.get(a).SLASerialNumber__c;
                    accupdate.SLAExpirationDate__c=mapacc.get(a).SLAExpirationDate__c;
                }
            }
            else{
                accupdate.SLASerialNumber__c=null;
                accupdate.SLAExpirationDate__c=null;
            }
        }
    }
}