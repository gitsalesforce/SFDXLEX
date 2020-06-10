public class ApexCPQController {
    //Tracker for Opportunity,Product,Renewals,Amended Contracts 
    @AuraEnabled
    public static CardsWrapper CardsCount(){
        CardsWrapper accWrapper = new CardsWrapper();
        string dd = system.today().format();
        accWrapper.ProductCount=(new list<Product2>([SELECT Id FROM Product2])).size();
        accWrapper.OppsCount=(new list<Opportunity>([SELECT Id FROM Opportunity])).size();
        accWrapper.ContractsCount=(new list<Contract>([SELECT Id FROM Contract])).size();
        accWrapper.AmendCount = (new list<Contract>([select id from Contract where SBQQ__RenewalForecast__c!=null and SBQQ__RenewalOpportunity__c!=null])).size();
        
        accWrapper.ContractToday=(new list<Contract>([SELECT Id FROM Contract where CreatedDate = TODAY])).size();
        accWrapper.OppsToday=(new list<Opportunity>([SELECT Id FROM Opportunity where CreatedDate = TODAY])).size();
        accWrapper.AmendToday = (new list<Contract>([select id from Contract where SBQQ__RenewalForecast__c!=null and SBQQ__RenewalOpportunity__c!=null AND CreatedDate = TODAY])).size();
        return accWrapper;
    }
    //Display all the Opportunity
  	@AuraEnabled
    public static list<Opportunity> GetOpportunity(){
        return [select id,name,stagename,closedate,Account.Name,Amount,ExpectedRevenue,SBQQ__PrimaryQuote__c,SBQQ__Contracted__c,SBQQ__RenewedContract__c,SBQQ__Renewal__c from Opportunity];
    }
    public class CardsWrapper{
        //All Tracker
        @AuraEnabled
        public Integer ContractsCount{get;set;}
        @AuraEnabled
        public Integer ProductCount{get;set;}
        @AuraEnabled
        public Integer AmendCount{get;set;}
        @AuraEnabled
        public Integer OppsCount{get;set;}
        //Today Tracker
        @AuraEnabled
        public Integer ContractToday{get;set;}
        @AuraEnabled
        public Integer AmendToday{get;set;}
        @AuraEnabled
        public Integer OppsToday{get;set;}
    }
    public class Quotedetails{
        @AuraEnabled
        public String QuoteNumber{get;set;}
        
        
    }
    public class Contractdetails{
        
    }
    public class Steelbreickinfo{
        @AuraEnabled
        public string primaryquote{get;set;}
        @AuraEnabled
        public boolean contracted{get;set;}
        @AuraEnabled
        public boolean renewalquote{get;set;}
        @AuraEnabled
        public string amendedquote{get;set;} 
    }
    public static Steelbreickinfo steeloppinfo(string recordid){
        Steelbreickinfo oppsteel = new Steelbreickinfo();
       	list<Opportunity> ls = new list<Opportunity>([select id,SBQQ__PrimaryQuote__c,SBQQ__Contracted__c,SBQQ__RenewedContract__c,SBQQ__Renewal__c from Opportunity where id=:recordid]);
        oppsteel.primaryquote=ls.get(0).SBQQ__PrimaryQuote__c;
        return oppsteel;
    }
}