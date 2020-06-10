public with sharing class dtablecontroller {
    @AuraEnabled(cacheable=true)
    public static List < Account > fetchAccounts() {
        return [ SELECT Id, Name, Industry, ( SELECT Id, FirstName, LastName FROM Contacts ) FROM Account limit 20];
       
    }
}