//Trigger to track Number of Contact and Contact names,Setting Priority on repective accounts.
trigger ContactTrack on Contact (after insert,after update,after delete) {
        set<id> latestcon = new set<id>();
        list<Account> acc = new list<Account>();//Account list
        Integer count=0;//Count total contact
        String ContactNames=', ';
        list<Contact> cc=Trigger.isDelete?Trigger.old:Trigger.new;
        for(Contact lss:cc){
            latestcon.add(lss.AccountID);
        }
        //map of account and related contacts
        map<id,Account> lscon = new map<id,Account>([select id,(select id,LastName,Customer_Priority__c from Contacts) from Account where id in:latestcon]);
        map<id,list<Contact>> finalmap = new map<id,list<Contact>>();
        //Filling the map values
        for(ID acid:lscon.keySet()){
            finalmap.put(acid,lscon.get(acid).Contacts);
            count=lscon.get(acid).Contacts.size();//getting size
        }
        system.debug(lscon);
        system.debug(finalmap);
        /*System.debug('Number of Queries used in this apex code so far:'+Limits.getQueries());
System.debug('Number of rows queried in this apex code so far:'+Limits.getDMLRows());
System.debug('Number of DML statment used so far:'+Limits.getDmlStatements());
System.debug('Amount of CPU time (in ms) used so far:'+Limits.getCpuTime());
*///Proactively determine if there are too many Account to update and avoid governor limits
        Account a = new Account();//Instance account
        if(count>0){
            
            //Updating Account Field
            for(id nn:finalmap.keySet()){
                a.Id=nn;//Map account id 
                a.Total_Contact__c=count;//count to contact
                //iterate inside the map value
                for(Contact ss:finalmap.get(nn)){
                    a.Contact_Names__c+=ss.LastName+' ,';//concatenate the last name
                    if(ss.Customer_Priority__c=='High'){
                        a.CustomerPriority__c=ss.Customer_Priority__c;
                        break;
                        
                    }
                    else if(ss.Customer_Priority__c=='Medium'){
                        a.CustomerPriority__c=ss.Customer_Priority__c;
                    }
                    else if(ss.Customer_Priority__c=='Low' && a.CustomerPriority__c!='Medium' ){
                        a.CustomerPriority__c=ss.Customer_Priority__c;
                    }
                }
                acc.add(a);//add account to list
            }
        }
        else if(count<=0){
            for(id nn:finalmap.keySet()){
                
                a.Id=nn;//Map account id 
                a.Total_Contact__c=count;//count to contact
                a.Contact_Names__c=null;//concatenate the last name
                a.CustomerPriority__c=null;
                acc.add(a);//add account to list
            }
        }
        system.debug(acc);
        if(acc.size()>0){
            update acc;
        }
}