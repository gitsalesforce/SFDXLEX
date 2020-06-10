//Check for the Contact Email which are equal to the Account Email and counts the number of contacts under account 
trigger emailnewcheck on Account (before update) {
    if(Trigger.isUpdate){
        map<id,Contact> mm = new map<id,Contact>([select id,Email from Contact where AccountId =:Trigger.new[0].Id and Email =:Trigger.new[0].Email__c]);
        for(Account acc:Trigger.new){
            acc.NumberOfEmployees=mm.size(); 
        }
    }    
}