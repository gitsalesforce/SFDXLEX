public with sharing class AccountWrapper
{
    @AuraEnabled
    public Account acc {get; set;}
     
    @AuraEnabled
    public Boolean selected {get; set;}
}