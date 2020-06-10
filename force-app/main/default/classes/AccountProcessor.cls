public class AccountProcessor {
 @future
  public static void countContacts(List<Id> recordIds) {
    List<Account> accounts = [Select Id, Name,Number_of_Contacts__c,(Select id from Contacts) from Account Where Id IN :recordIds];
      for(Account acc:accounts){
          list<Contact> cc = acc.Contacts;
          acc.Number_of_Contacts__c=cc.size();
      }
      update accounts;
  }
}