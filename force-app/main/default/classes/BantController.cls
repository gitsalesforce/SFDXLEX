public class BantController
{
    @AuraEnabled
        public static List<WrapperClass> fetchHeavy (){
            List<WrapperClass> wcList = new List<WrapperClass>();
            List<WrapperClass> wcList1 = new List<WrapperClass>();
            Integer cc=0;
            List<Account> accList = [SELECT Id,Name,Phone, (SELECT LastName FROM contacts) FROM Account];
                for(Account acct : accList){
                    if(acct.contacts.size() > 0){
                        WrapperClass wc = new WrapperClass(acct.contacts.size(),acct.Id,acct.Name);
                        wcList.add(wc);
                    }
                }
            wcList.sort();
           
            return wcList;
        } 
    public with sharing class WrapperClass implements Comparable{
        @AuraEnabled
        public Integer count{get;set;}  //counter of stage history
        @AuraEnabled
        public ID acc{get;set;}//opid
        @AuraEnabled
        public String accname{get;set;} //oppname
        @AuraEnabled
        public Integer Budget{get;set;}  
        @AuraEnabled
        public Integer Authority{get;set;}
        @AuraEnabled
        public Integer Need{get;set;} 
        @AuraEnabled
        public Integer Timing{get;set;} 
        //Constructor 
        WrapperClass(Integer i,ID id,String acname){
            count=i;
            acc=id;
            accname=acname;
        }
        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
            WrapperClass compareToEmp = (WrapperClass)compareTo;
            if (count> compareToEmp.count)
            { 
                return -1;
            }
            if (count== compareToEmp.count) {
                { 
                return 0;
            }
            }
            return 1;        
        }
    }
        
        //Fetching Opportunity with respective account
        @AuraEnabled
        public static List<Opportunity> fetchOpp (String recordId){
            system.debug(recordId);
            return [SELECT Id, Name, StageName FROM Opportunity WHERE AccountId=:recordId];
        }
    }