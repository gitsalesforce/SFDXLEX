global class AutomaticShcdularContract implements Schedulable 
{ 
    global void execute(SchedulableContext ctx) 
    {
        AutomateContracts batchObject = new AutomateContracts(); 
        Id batchId = Database.executeBatch(batchObject, 1);
    } 
  
}