//Trigger to Count Contact Sibling
trigger contactsib on Contact (before insert,before update,before delete) {
    set<id> conset = new set<id>();
    list<Contact> ccs=Trigger.isDelete?Trigger.old:Trigger.new;
    for(Contact lss:ccs){
        conset.add(lss.AccountID);
    }
    list<Contact> ll=new list<Contact>();
    map<id,Contact> map1 = new map<id,Contact>([select id,LastName,Sibling__c from Contact where AccountID IN:conset]);
    
    for(Contact cc:ccs){
        for(ID cccs:map1.keySet()){
            if(map1.containsKey(cccs)){
                cc.Sibling__c = map1.size()-1;
            }
        }
    }
}