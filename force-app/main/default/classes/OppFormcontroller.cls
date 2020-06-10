public with sharing class OppFormcontroller {
    @AuraEnabled
    public static List<Opportunity> GetOpportunity() {
        return [SELECT Id, Name,CloseDate,ExpectedRevenue,Amount,Type, StageName FROM Opportunity order by LastModifiedDate desc LIMIT 5];
    }
    @AuraEnabled
    public static list<OpportunityLineItem> getproduct(String recordId){
        system.debug(recordId);
        return [select id,Name, Quantity,ProductCode, Listprice from OpportunityLineItem where OpportunityId =:recordId];
    }
    @AuraEnabled
    public static Opportunity deleteopps(Opportunity op) {
        delete op;
        return op;
    }
}