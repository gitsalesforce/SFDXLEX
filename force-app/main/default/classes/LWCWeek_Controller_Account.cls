public with sharing class LWCWeek_Controller_Account {
@AuraEnabled(cacheable=true)
public static list<contact> getContactList(string searchKey) {
    string sTempSearchKey = '%' + searchKey + '%';
    
    // create contact list to store search result 
    list<contact> lstContact = new list<contact>();
    
    // query contact records
    for(contact oCon : [Select id,Name,Email,FirstName,LastName,Phone
                        From Contact
                        WHERE name LIKE : sTempSearchKey]){
        lstContact.add(oCon);
    }
    
    //If there are no records found with searchKey then, throw aura exception with a message
        if(lstContact.size() == 0){
        throw new AuraHandledException('No Record Found..'); 
        }
        
    return lstContact;
}
//Account details datatable implented pagination and sorting
@AuraEnabled(Cacheable = true)
public static List<Account> fetchAccounts(){
       return [SELECT Id,Name,Phone,Type,Industry,Rating,Website FROM Account];
    }
}