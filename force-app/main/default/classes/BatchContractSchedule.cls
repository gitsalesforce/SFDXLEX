global class BatchContractSchedule implements Schedulable
{
    //Parameter for Opportunities
    public string createddate;
    public string oppstatus;
    //Paramter for Updated Contracts Batch
    public string status;
    public Integer term;
    //Schedular String
  	Public static string sch = '0 46 18 6 5 ? 2021'; // Today only 12:13 PM schedule interval time 
    //constructor
    public BatchContractSchedule(string createddate,string oppstatus, string status,Integer term){
        this.createddate=createddate;
        this.oppstatus=oppstatus;
        this.status=status;
        this.term=term;
    }  
    global static String scheduleMe() {
        BatchContractSchedule SC = new BatchContractSchedule('LAST_WEEK','Closed Won','Draft',36); //custom Query
        return System.schedule('My batch Job2', sch, SC);
    }
    global void execute(SchedulableContext sc) {
        CronTrigger ct = [SELECT Id,StartTime,EndTime, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :sc.getTriggerId()];
        //First Custom Query for Batch Contract
        String query = 'SELECT Id, StageName,AccountId, CreatedDate FROM Opportunity WHERE StageName =\''+oppstatus+'\' AND CreatedDate >= '+createddate;
        //Second Custom Update Query for Next Batch & Building custom list for contract Updation
        list<Contract> ls = new list<Contract>();
        for(Contract cc:[SELECT Id, Status,AccountId, ContractTerm FROM Contract WHERE Status =:status and ContractTerm =:term]){
            ls.add(cc);
        }
        system.debug(ls);
        ID batchprocessid = Database.executeBatch(new BatchContract(query,ls)); 
        //sending the mail
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string [] toaddress= New string[]{'amitgrazitti@gmail.com'};
            email.setSubject('Testing Apex Scheduler-BatchContract');
        String body = 'The Schedulable batch job '
            + 'BatchApexContract '
            + 'has finished. \n' 
            + 'This is executed at'
            + ct.StartTime+ 'and ended at'+ ct.EndTime;
        email.setPlainTextBody('Batch Class Executed at>'+body);
        email.setToAddresses(toaddress);
        Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
    } 
}