public class AddPrimaryContact implements Queueable {
    public contact c;
    public String state;
    
    public AddPrimaryContact(Contact c, String state) {
        this.c = c;
        this.state = state;
    }
    
    public void execute(QueueableContext qc) {
        List<Account> accList = new List<account>([select id, name, BillingState from account where account.BillingState = :this.state limit 200]);
        List<contact> insertContact = new List<contact>();
        for(account a: accList) {
            contact c = new contact();
            c = this.c.clone(false, false, false, false);
            c.AccountId = a.Id;
            insertContact.add(c);
        }
        insert insertContact;
    }
    
}