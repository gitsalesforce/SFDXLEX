trigger concreate on Account (after insert,after update,after delete) {
    map<Id,Account> accmap = new map<Id,Account>();//account
    list<Account> aop = Trigger.isDelete?Trigger.old:Trigger.new;
    set<id> lss = new set<id>();
    
    list <Contact> newaccsg = new list<Contact>();
    for(Account accs :aop){
        
        accmap.put(accs.Id,accs);
        lss.add(accs.id);
    }
    SYSTEM.debug(lss);
    map<id,Contact> acccop = new map<id,Contact>([select id,LastName,Split_Amount__c from Contact where AccountID in:lss]);
    system.debug(acccop.size());
    for(ID ac:accmap.keySet()){
        if(acccop.size()>0){
            for(ID con:acccop.keySet()){
                
                newaccsg.add(new Contact(ID=con,AccountId=ac,Split_Amount__c=accmap.get(ac).AnnualRevenue/acccop.size()));
            }
        }
        else if(accmap.containsKey(ac) &&acccop.size()==0 )
        {
            newaccsg.add(new Contact(AccountId=ac,lastname=accmap.get(ac).name,Split_Amount__c=accmap.get(ac).AnnualRevenue));
        }
    }
    update newaccsg;
}