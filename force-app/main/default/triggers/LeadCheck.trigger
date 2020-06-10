trigger LeadCheck on Lead (after insert, after update,before insert,before update) {

        if(trigger.isBefore){
            Map<String, Lead> leadMap = new Map<String, Lead>();
            for (Lead lead : System.Trigger.new) {   

                //We don't treat an email address that isn't changing during an update as a duplicate. 
                if ((lead.Email != null) && (System.Trigger.isInsert || (lead.Email != System.Trigger.oldMap.get(lead.Id).Email))){
                          //Checking whether another new lead isn't also a duplicate  
                          if (leadMap.containsKey(lead.Email)) {
                              lead.Email.addError('Another new lead has the  same email address.');
                          } else {
                              leadMap.put(lead.Email, lead);
                          }
                      }
            }

            list<account> accs = new list<account>();
            //Finding all the leads in the database that have the same email address as any of the leads being inserted or updated.  
            for (Lead lead : [SELECT Name, Email, IsConverted, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId FROM Lead WHERE Email IN :leadMap.KeySet()]){
                Lead newLead = leadMap.get(lead.Email);
       /*      account acc = new account();
                acc.id = lead.ConvertedContactId;
                acc.Name =  lead.Name;
                acc.type__c = 'Prospecting';
             
               accs.add(acc);*/
                system.debug('*************ConvertedAccountId************'+lead.ConvertedAccountId);
                //newLead.Email.addError('A lead with this email address already exists.');
               }
            insert accs;
            system.debug('*************objOpportunity************'+accs);
        }

list<lead> ll = Trigger.isDelete?Trigger.old:Trigger.new;
        if(trigger.isAfter ){
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];  
           system.debug(convertStatus);
            for (Lead lead :ll) {
                //Converting those leads whose Status is equal to Web
                if (lead.isConverted == false && lead.LeadSource == 'Web'){ 
                    system.debug('************lead*************'+lead);
                    Database.LeadConvert objLeadConvert = new Database.LeadConvert();
                    objLeadConvert.setLeadId(lead.Id);      
                    String oppName =  lead.Name;
                    objLeadConvert.setOverwriteLeadSource(false);
                    objLeadConvert.setOpportunityName(oppName); 
                   	objLeadConvert.setConvertedStatus(convertStatus.MasterLabel);
                    Database.LeadConvertResult objLeadConvertResult = Database.convertLead(objLeadConvert);
                     
                }
                
      List<Account> updateAccountList = new List<Account>();  
      if (lead.IsConverted && !(Trigger.oldMap.get(lead.Id).IsConverted)){
 
          Account a = [SELECT Id, OwnerId FROM Account WHERE Id=:lead.convertedAccountId LIMIT 1];
          a.nameofnamehighpriority__c= lead.title;
          updateAccountList.add(a);
                }
                update updateAccountList;
            }
        }
    }