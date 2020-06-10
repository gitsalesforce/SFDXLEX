public class nytimes {
    //private static Transient String API_KEY_NYTimes_Proxy = '44579814-9584-479b-a53b-ba81c690acef';
    private static final String API_KEY_NYTimes = 'R3HzE1oj1FlGFpRb7Q0FwRW8PyBSMG0K';
    // private final static String API_KEY_NYTimes_Blocker = 'a40a92de-81b3-468e-812a-643c936f991a';
    // API Wrapper Class
    public class LatestArticle {
        @AuraEnabled
        public List<Results> results {get;set;} 
    }
    public class Multimedia {
        @AuraEnabled
        public String url {get;set;} 
        @AuraEnabled
        public String format {get;set;} 
        @AuraEnabled
        public Integer height {get;set;} 
        @AuraEnabled
        public Integer width {get;set;} 
        @AuraEnabled
        public String type_Z {get;set;} // in json: type
        @AuraEnabled
        public String subtype {get;set;} 
        @AuraEnabled
        public String caption {get;set;} 
        @AuraEnabled
        public String copyright {get;set;} 
    }
    public class Results {
        @AuraEnabled
        public String section {get;set;} 
        @AuraEnabled
        public String subsection {get;set;} 
        @AuraEnabled
        public String title {get;set;} 
        @AuraEnabled
        public String abstract_Z {get;set;} // in json: abstract
        @AuraEnabled
        public String url {get;set;} 
        @AuraEnabled
        public String uri {get;set;} 
        @AuraEnabled
        public String byline {get;set;} 
        @AuraEnabled
        public String item_type {get;set;} 
        @AuraEnabled
        public String updated_date {get;set;} 
        @AuraEnabled
        public String created_date {get;set;} 
        @AuraEnabled
        public String published_date {get;set;} 
        @AuraEnabled
        public String material_type_facet {get;set;} 
        @AuraEnabled
        public String kicker {get;set;} 
        @AuraEnabled
        public List<String> des_facet {get;set;} 
        @AuraEnabled
        public List<String> org_facet {get;set;} 
        @AuraEnabled
        public List<String> geo_facet {get;set;} 
        @AuraEnabled
        public List<Multimedia> multimedia {get;set;} 
        @AuraEnabled
        public String short_url {get;set;}
        @AuraEnabled
        public String type_Z {get;set;} 
    }
    public class ResponseMultimedia {
        @AuraEnabled
        public String url {get;set;} 
        @AuraEnabled
        public String format {get;set;} 
        @AuraEnabled
        public Integer height {get;set;} 
        @AuraEnabled
        public Integer width {get;set;} 
        @AuraEnabled
        public String type_Z {get;set;} // in json: type
        @AuraEnabled
        public String subtype {get;set;} 
        @AuraEnabled
        public String caption {get;set;} 
        @AuraEnabled
        public String copyright {get;set;} 
    }
    public class ResponseResults {
        @AuraEnabled
        public String section {get;set;} 
        @AuraEnabled
        public String subsection {get;set;} 
        @AuraEnabled
        public String title {get;set;} 
        @AuraEnabled
        public String abstract_Z {get;set;} // in json: abstract
        @AuraEnabled
        public String url {get;set;} 
        @AuraEnabled
        public String uri {get;set;} 
        @AuraEnabled
        public String byline {get;set;} 
        @AuraEnabled
        public String item_type {get;set;} 
        @AuraEnabled
        public String updated_date {get;set;} 
        @AuraEnabled
        public String created_date {get;set;} 
        @AuraEnabled
        public String published_date {get;set;} 
        @AuraEnabled
        public String material_type_facet {get;set;} 
        @AuraEnabled
        public String kicker {get;set;} 
        @AuraEnabled
        public List<String> des_facet {get;set;} 
        @AuraEnabled
        public List<String> org_facet {get;set;} 
        @AuraEnabled
        public List<String> geo_facet {get;set;} 
        @AuraEnabled
        public list<ResponseMultimedia> multimedia {get;set;} 
        @AuraEnabled
        public String short_url {get;set;}
        @AuraEnabled
        public String type_Z {get;set;} 
    }
    @AuraEnabled
    public static String ModifyJSON(String data) {
        String regexFormat = '(?m)^\\s*"{0}"\\s*:';
        String replacementFormat = '"{0}" :';
        Map<String, String> replacements = new Map<String, String> {
                'abstract' => 'abstract_Z',
                'type'=>'type_Z'
                };
        String formattedJSON = JSON.serializePretty(JSON.deserializeUntyped(data));
        for (String key : replacements.keySet()) {
            // Generate our regex based on the key
            String regex = String.format(
                regexFormat,
                new List<String> {key}
            );
            
            // Generate our replacement
            String replacement = String.format(
                replacementFormat,
                new List<String> {replacements.get(key)}
            );
            formattedJSON = formattedJSON.replaceAll(regex, replacement);
        }
        return formattedJSON;	
    }    
    @AuraEnabled
    public static list<ResponseResults> nytimesnews(){
        String outcomeMsg;
        string endpoint = 'https://api.nytimes.com/svc/topstories/v2/home.json?api-key='+API_KEY_NYTimes; // this is configured in "Remote Site Settings"
        string method = 'GET'; //method name
        set<ResponseResults> nynewswrapper = new set<ResponseResults>();
        list<ResponseResults> nynewswrapperfinal = new list<ResponseResults>();
        if (Limits.getCallouts() >= Limits.getLimitCallouts()) {
            outcomeMsg = 'Maximum more than 100 number of callouts has been reached.';
        }
        else {
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http h = new Http();
            // Configure the request
            req.setEndpoint(endpoint);
            req.setMethod(method);
            req.setTimeout(120000);
            req.setHeader('Accept', '*/*');
            req.setHeader('Content-Type', 'application/json');
            try {
                // Perform callout and set response
                res = h.send(req);
                // check response 
                if ((res.getStatusCode() == 200 || res.getStatusCode() == 201) && res.getBody() != null) {
                    LatestArticle MyMeta = (LatestArticle) JSON.deserialize(ModifyJSON(res.getBody()),LatestArticle.class);
                    for(Integer i=0;i<MyMeta.results.size();i++){
                        ResponseResults results = new ResponseResults();
                        list<ResponseMultimedia> resultsmedia = new list<ResponseMultimedia>();
                        //Result Response
                        results.section = MyMeta.results[i].section;
                        results.subsection = MyMeta.results[i].subsection;
                        results.title = MyMeta.results[i].title;
                        results.url = MyMeta.results[i].url;
                        results.item_type = MyMeta.results[i].item_type;
                        results.updated_date = MyMeta.results[i].updated_date;
                        results.created_date = MyMeta.results[i].created_date;
                        results.published_date = MyMeta.results[i].published_date;
                        results.des_facet = MyMeta.results[i].des_facet;
                        results.org_facet = MyMeta.results[i].org_facet;
                        results.geo_facet = MyMeta.results[i].geo_facet;
                        results.abstract_Z = MyMeta.results[i].abstract_Z;
                        //Multimedia Response
                        for(Integer j=0;j<MyMeta.results[i].multimedia.size();j++){
                            resultsmedia[j].url=MyMeta.results[i].multimedia[j].url;
                            resultsmedia[j].caption=MyMeta.results[i].multimedia[j].caption;
                            resultsmedia[j].copyright=MyMeta.results[i].multimedia[j].copyright;
                            results.multimedia = resultsmedia;
                        }
                        nynewswrapper.add(results);
                    }
                    //Removes Duplicate News
                    nynewswrapperfinal = new list<ResponseResults>(nynewswrapper);
                    outcomeMsg='success';
                }
            }
            catch(Exception ex){
                system.debug('failed');
            }
        }
        //Unique News List
        return nynewswrapperfinal;
    }
}