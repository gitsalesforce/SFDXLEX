public with sharing class relatedobjects {
    @AuraEnabled(cacheable=true )
    public static list<Contact> getContacts(string searchKey){
        list<Account> lss = new list<Account>([select id from Account where name =:searchKey]);
        List<Contact> lst = new List<Contact>([SELECT Id, Name, Title, Phone, Email FROM Contact WHERE Accountid in :lss]);

        return lst;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [SELECT Id, Name, Title, Phone, Email FROM Contact LIMIT 100];
    }
    @AuraEnabled(cacheable=true )
    public static list<Contact> getContactschild(string searchKey){
        List<Contact> lst = new List<Contact>([SELECT Id, Name, Title, Phone, Email FROM Contact WHERE Accountid =:searchKey]);
        return lst;
    }

}