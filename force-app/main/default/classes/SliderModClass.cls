public class SliderModClass {
    @AuraEnabled
    Public static List<Account> Accdata(){
        List<Account> alist=[Select Name,Billingcity,Type,BillingState from Account order by createddate];
            return alist;
    }
}