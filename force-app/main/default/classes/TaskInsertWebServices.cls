@RestResource(UrlMapping = '/TaskInsert/*')
global class TaskInsertWebServices {
	public class TaskWrapper {
		public String subject;
		public String priority;
		public String status;
        public String ActivityDate;
        public String Description;
        public String CreatedDate;
        public String LastModifiedDate;
		private transient Case con;
        public Task getTask(String CaseID){
            Task tt =[Select Id, Subject, ActivityDate, Status, Priority, OwnerId, Description, IsDeleted, IsClosed, CreatedDate, LastModifiedDate, LastModifiedById From Task where WhatId = :CaseID];
			return new Task(
				Subject = this.subject,
				Priority = this.priority,
				Status = this.status,
				WhoId = con.Id
			);
		}
    }
     @HttpGet 
    global static list<Case> getCaseById() {
        RestRequest request = RestContext.request;
      // String caseId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        String caseId = request.params.get('id');
        list<Case> caselist = new list<Case>();
        //check if the string is not empty
        if(String.isNotEmpty(caseId)){
            Task tt =[Select Id, Subject, ActivityDate, Status, Priority, OwnerId, Description, IsDeleted, IsClosed, CreatedDate, LastModifiedDate, LastModifiedById From Task where WhatId = :caseId];
            system.debug(tt);
            for(Case result :  [SELECT CaseNumber,Subject,Status,Origin,Priority FROM Case WHERE Id = :caseId])
            {
                caselist.add(result);
            }
        }
        //check if the string is empty
        else if(String.isEmpty(caseId)){
            for(Case result :  [SELECT CaseNumber,Subject,Status,Origin,Priority FROM Case]){
                caselist.add(result);
                system.debug(caselist);
            } 
        }
        return caselist;
    }
}