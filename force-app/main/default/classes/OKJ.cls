public class OKJ {
    public static list<Opportunity> nn(){
        String createddate='LAST_WEEK';
        String p = 'Closed Won';
        String query = 'SELECT Id, StageName,AccountId, CreatedDate FROM Opportunity WHERE StageName =\''+p+'\' AND CreatedDate >= '+createddate;
        list<Opportunity> ls = Database.query(query);
        return ls;
    }
}