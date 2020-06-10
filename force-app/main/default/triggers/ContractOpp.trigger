trigger ContractOpp on Opportunity (after insert,after update) {
    if(Trigger.isInsert || Trigger.isUpdate){
        list<Opportunity> opp = Trigger.isDelete?Trigger.old:Trigger.new;
        List<Contract> conttoinsert = new List<Contract>();
        for(Opportunity op:opp){
            Contract con = new Contract();
            con.AccountId = op.accountID;
            con.Status = 'Draft';
            con.StartDate=system.today();
            con.ContractTerm=7;
            conttoinsert.add(con);
        }
        //pass the list to serialize the list
        createcontractfuture.prepare(conttoinsert);
    }
}