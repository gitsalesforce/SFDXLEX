trigger Emailcheck on Contact (after insert,after update,after delete) {
    Map<String,ID> mapContact= new Map<String,ID>();
    list<Account> updateacc= new list<Account>();
    set<id> setid = new set<id>();
    list<Contact> cc=Trigger.isDelete?Trigger.old:Trigger.new;
    for(Contact a :cc){
        setid.add(a.AccountID);
        mapContact.put(a.Email,a.AccountID);     
    }
    list<Contact> cons = new list<Contact>([select id,name from Contact where email in :mapContact.keySet() and accountid in:setid]);
    list<Account> acclist1=new list<Account>([Select id,name,Email__c from Account where Email__c in:mapContact.keySet()]);
    if(RecursiveTriggerHandler.isFirstTime){
        RecursiveTriggerHandler.isFirstTime = false;   
        Account a = new Account();
        a.id=acclist1[0].id;
        if(acclist1.size()>0 && cons.size()>0){
            a.NumberOfEmployees=cons.size();
            updateacc.add(a);
            system.debug(updateacc);
        }
    }
    update updateacc; 
    
    
}