Public Class AuraActionServerCall 
{
//list of accounts
@AuraEnabled
    public static list<Account> getAccount()
    {
    return [select id,name from Account limit 10];
    }
//list of contacts
@AuraEnabled
    public static list<Contact> getlistContact()
    {
    return [select id,name from Contact limit 10];
    }
//list of ooportunity 
@AuraEnabled
    public static list<Opportunity> getlistOpportunity()
    {
    return [select id,name from Opportunity limit 10];
    }

}