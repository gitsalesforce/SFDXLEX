public with sharing class leadsearchcontroller {
    @AuraEnabled(cacheable=true)
    public static List<Lead> searchLeads( String searchTerm ) {
        List<Lead> leads = new List<Lead>();
        if ( String.isNotBlank( searchTerm ) ) {
            List<List<SObject>> searchResults = [
                FIND :searchTerm
                RETURNING Lead(
                    Id, Name, Title, Company,
                    Street, City,
                    State, PostalCode
                    ORDER BY Name
                    LIMIT 10
                )
            ];
            leads = searchResults[0];
        }
        return leads;
    }


    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccount( String searchTerm ) {
        List<Account> acc = new List<Account>();
        if ( String.isNotBlank( searchTerm ) ) {
            List<List<SObject>> searchResults = [
                FIND :searchTerm
                RETURNING Account(
                    Id, Name,Rating
                    ORDER BY Name
                    LIMIT 10
                )
            ];
            acc = searchResults[0];
        }
        return acc;
    }
}