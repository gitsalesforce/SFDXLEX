trigger ContractAuto on Opportunity (after insert,after update,before insert, before update,after delete,before delete) {
    AutomateContractClass nn = new AutomateContractClass();//calling class
    list<Opportunity> ls  =Trigger.isDelete?Trigger.old:TRigger.new;
    //Creation of Contract
    if(trigger.isInsert && trigger.isAfter){
    	nn.createcontract(ls);//creates new contract on opportunity
    }
   
}