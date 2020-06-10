public class createcontractfuture {
     public static void prepare(List<SObject> sObjs) {
        try {
            insertSObjects(JSON.serialize(sObjs));
        } catch (Exception e) {
            System.debug('Error in SObject List serialization');
        }
    }
    // insert the Contract
    @future
    public static void insertSObjects(String jsonString) {
        List<SObject> sObjs = new List<SObject>();
        try {
            sObjs = (List<SObject>) JSON.deserialize(jsonString, List<SObject>.class);
        } catch (Exception e) {
            System.debug('Error in JSON deserialization');
        }
        if(!sObjs.isEmpty()) {
            try {
                insert sObjs;//insert the contract
            } catch (Exception e) {
                System.debug('Error inserting Contract');
            }
            
        } 
        
    }
}