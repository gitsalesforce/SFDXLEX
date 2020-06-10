trigger OpportunityContactTrigger on OpportunityContactRole (after insert,after update,after delete) {
    list<Opportunity> opps = new list<Opportunity>();
    set<id> oppid = new set<id>();
    list<OpportunityContactRole> newos = Trigger.isDelete?Trigger.old:Trigger.new;
    if(trigger.isInsert || trigger.isUpdate){ 
        for(OpportunityContactRole oos :newos){
            Opportunity oo = new Opportunity();
            oo.Id=oos.OpportunityId;
            if(oos.IsPrimary==true ){
                oo.Primary_Contact_Name__c=oos.ContactId;
                opps.add(oo);
                system.debug(opps);
            }
        }
    }    
    else if(trigger.isDelete){
        for(OpportunityContactRole oos :newos){
            if(oos.IsPrimary==true){
                Opportunity oo = new Opportunity();
                oo.Id=oos.OpportunityId;
                oo.Primary_Contact_Name__c=null;
                opps.add(oo);
                system.debug(opps);
            }
        }
    }
    if(opps.size()>0){
        update opps;
    }
}