public class AutomateContractClass {
    public void createcontract(list<Opportunity> ls){
        list<Opportunity> ammend_opps = new list<Opportunity>();//Amended Opportunity
        list<Contract> con = new list<Contract>();//Contracted Opps Contract
        for(Opportunity os:ls){
            if(os.StageName=='Closed Won' && os.SBQQ__Contracted__c==true && os.AccountId!=null){
                Contract cc=new Contract();//New Contract
                cc.AccountId=os.AccountId;
                cc.ContractTerm=10;
                cc.SBQQ__Opportunity__c=os.id;
                cc.AccountId=os.AccountId;
                cc.StartDate = os.CloseDate;//required
                //Generating Renewal Opportunity link after Activate 
                cc.SBQQ__RenewalForecast__c=true;
                cc.SBQQ__RenewalOpportunityStage__c='Proposal/Price Quote';
                //Reneewal Quote 
                cc.SBQQ__RenewalQuoted__c=true;
                con.add(cc);
            }
        }
        system.debug('contract list'+con);
        insert con;
    }
}