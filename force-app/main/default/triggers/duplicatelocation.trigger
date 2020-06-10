//Trigger on duplicate contact corresponding location.
//Master -Contact(standerd)
//Master -Location(custom)
//Junction Object is [LocationContact](custom)
//Task is to prevent creating duplicate locationcontact record on same location and contact
//Task is to Count the total number of contact on specified location.
//Task is to Show the contact names on the location object
trigger duplicatelocation on location_Contact__c (after insert,after update,after delete) 
{
    if(trigger.isAfter && (trigger.isInsert || Trigger.isUpdate)){
        list<location__c> locupdatelist = new list<location__c>();
        Set<Id> setLocationId = new set<Id>();
        Set<Id> setContactId = new set<Id>();
        Set<Id> setlocid = new set<Id>();
        list<location_Contact__c> newloclist = Trigger.isDelete?Trigger.old:Trigger.new;
        for (location_Contact__c ci : newloclist) {
            //Master Contact Latest ID
            if(ci.Contact__c != null )
            {
                setContactId.add(ci.Contact__c);
            }
            //Master Location Latest ID
            if(ci.location__c != null)
            {
                setLocationId.add(ci.location__c);
            }
            if(ci.id != null)
            {
                setlocid.add(ci.id);
            }
        }
        Integer count=0;
        map<id,Contact> conmap = new map<id,Contact>();
        for(location_Contact__c ss:newloclist){
            location_Contact__c[] cons = [select id,Location__c,Contact__c from location_Contact__c where Location__c=:ss.Location__c and id=:ss.id];
            map<id,location_Contact__c> newmap = new map<id,location_Contact__c>([SELECT Id,Name,Location__c,Contact__c from location_Contact__c WHERE Location__c=:ss.Location__c and id=:ss.id]);
            map<id,Contact> newcon = new map<id,Contact>([select id,LastName from Contact where id =:ss.Contact__c]);
            for(ID coo:newcon.keySet()){
                conmap.put(coo,newcon.get(coo));
            }
             if(newmap.size()>0){
            ss.addError('Dups detecte');
        }
            
        }
       
        if(conmap.size()>0 && count>0){
            for(id nn:conmap.keySet()){
                
            }
            
        }  
        /*
        Set<Id> setLocationId = new set<Id>();
        Set<Id> setContactId = new set<Id>();
        list<location_Contact__c> newloclist = Trigger.isDelete?Trigger.old:Trigger.new;
        for (location_Contact__c ci : newloclist) {
            //Master Contact Latest ID
            if(ci.Contact__c != null)
            {
                setContactId.add(ci.Contact__c);
            }
            //Master Location Latest ID
            if(ci.location__c != null)
            {
                setLocationId.add(ci.location__c);
            }
        }
        
        List<location_Contact__c> lstLC =  [ SELECT id,location__c,Contact__c FROM location_Contact__c WHERE  Location__c = :setLocationId  AND Contact__c = :setContactId];
        system.debug(lstLC);
        Map<String,location_Contact__c> mapLC = new Map<String,location_Contact__c>();
        
        
        for(location_Contact__c LC : lstLC)
        {
            String key = LC.location__c+'_'+LC.Contact__c;
            mapLC.put(key,LC);
        }
        system.debug(mapLC);
        for (location_Contact__c ci : trigger.new) {
            String key = ci.location__c+'_'+ci.Contact__c;
            if ( mapLC.containsKey(key) ){
                ci.addError('Duplicate record, a location contact already exists');
            }
        }*/
    }
}