public class AsyncFutureService {
    // insert sobjects
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
                insert sObjs;
            } catch (Exception e) {
                System.debug('Error inserting SObjects');
            }
            
        } 
        
    }
    // upsert sobjects
    @future
    public static void upsertSObjects(String jsonString) {
        
        List<SObject> sObjs = new List<SObject>();
        
        try {
            sObjs = (List<SObject>) JSON.deserialize(jsonString, List<SObject>.class);
        } catch (Exception e) {
            System.debug('Error in JSON deserialization');
        }
        
        if(!sObjs.isEmpty()) {
            try {
                upsert sObjs;
            } catch (Exception e) {
                System.debug('Error upserting SObjects');
            }
            
        } 
        
    }
    // update sobjects
    @future
    public static void updateSObjects(String jsonString) {
        
        List<SObject> sObjs = new List<SObject>();
        
        try {
            sObjs = (List<SObject>) JSON.deserialize(jsonString, List<SObject>.class);
        } catch (Exception e) {
            System.debug('Error in JSON deserialization');
        }
        
        if(!sObjs.isEmpty()) {
            try {
                update sObjs;
            } catch (Exception e) {
                System.debug('Error updating SObjects');
            }
            
        } 
        
    }
    // delete sobjects
    @future
    public static void deleteSObjects(String jsonString) {
        
        List<SObject> sObjs = new List<SObject>();
        
        try {
            sObjs = (List<SObject>) JSON.deserialize(jsonString, List<SObject>.class);
        } catch (Exception e) {
            System.debug('Error in JSON deserialization');
        }
        
        if(!sObjs.isEmpty()) {
            try {
                delete sObjs;
            } catch (Exception e) {
                System.debug('Error deleting SObjects');
            }
            
        } 
        
    }
    @future(callout=true)
    public static void checknumber(id recordid){
        Contact cc=[select id,Name,Phone from Contact where id=:recordid];
        verifyphone(cc);
    }
    public static HttpResponse makeCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.androidhive.info/contacts/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'contacts' key as a list
            List<Object> contacts = (List<Object>) results.get('contacts');
            System.debug('Received the following contacts:');
            for (Object contact: contacts) {
                System.debug(contact);
            }
        }
        return response;
    }
    public static void verifyphone(sObject sobj){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
            List<Object> animals = (List<Object>) results.get('animals');
            System.debug('Received the following animals:');
            for (Object animal: animals) {
                System.debug(animal);
            }
        }
    }
    // list of sobjects
    public static String prepare(List<SObject> sObjs) {
        
        try {
            return JSON.serialize(sObjs);
        } catch (Exception e) {
            System.debug('Error in SObject List serialization');
        }
        return null;
        
    }
    // single sobject
    public static String prepare(SObject sObj) {
        
        try {
            return JSON.serialize(new List<SObject>{sObj});
        } catch (Exception e) {
            System.debug('Error in SObject serialization');
        }
        return null;
        
    }
}