public class GuardianNews {
    private static final string API_KEY = '689aae25-d6ce-41a1-a02e-2f5b372c9c80';
//contents
//Tags
//Section
//Single Item
    public class guardianwrapper{
        @AuraEnabled
        public list<results> results{get;set;}
    }
    public class guardiansectionwrapper{
        @AuraEnabled
        public list<editions> editions{get;set;}
    }
    //Wrapper for Section API
    public class editions{
        @AuraEnabled
        public string webTitle{get;set;}
        @AuraEnabled
        public string id{get;set;}
        @AuraEnabled
        public string webUrl{get;set;}
        
    }
    //Wrapper for contents API
    public class results{
        @AuraEnabled
        public string id{get;set;}
        @AuraEnabled
        public string sectionName{get;set;}
        @AuraEnabled
        public string webPublicationDate{get;set;}
        @AuraEnabled
        public string webTitle{get;set;}
        @AuraEnabled
        public string webUrl{get;set;}
        @AuraEnabled
        public string pillarName{get;set;}
    }
    //Wrapper for contents API
    public class ResposneContentResults{
        @AuraEnabled
        public string id{get;set;}
        @AuraEnabled
        public string sectionName{get;set;}
        @AuraEnabled
        public string webPublicationDate{get;set;}
        @AuraEnabled
        public string webTitle{get;set;}
        @AuraEnabled
        public string webUrl{get;set;}
        @AuraEnabled
        public string pillarName{get;set;}
    }
    @AuraEnabled
    public static list<ResposneContentResults> GuradianContentsResponse(){
       //https://content.guardianapis.com/search?from-date=2020-04-09&to-date=2020-04-22&order-by=newest&page=1&page-size=10&q=INDIA&api-key=test
       //https://content.guardianapis.com/tags?q=green
       //https://content.guardianapis.com/sections?q=news&api-key=689aae25-d6ce-41a1-a02e-2f5b372c9c80
        String outcomeMsg;
        String from_date;
        String tags;
        String section;
        String to_date;
        String order_by;
        Integer page;
        Integer page_size;
        String query;
        string endpoint = 'https://content.guardianapis.com/search?from-date='+from_date+'&to-date='+to_date+'&order-by='+order_by+'&page='+page+'&page-size='+page_size+'&q='+query+'&api-key='+API_KEY;
        string method = 'GET'; //method name
        list<ResposneContentResults> nynewswrapper = new list<ResposneContentResults>();
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
                if ((res.getStatusCode() == 200 || res.getStatusCode() == 201) && res.getBody() != null && res.getBody() != null) {
                    guardianwrapper nynews = new guardianwrapper();
                    guardiansectionwrapper nynewsection = new guardiansectionwrapper();
                    
                    guardianwrapper MyMeta = (guardianwrapper) JSON.deserialize(res.getBody(),guardianwrapper.class);
                    for(Integer i=0;i<MyMeta.results.size();i++){
                        ResposneContentResults results = new ResposneContentResults();
                        
                        //Result Response
                        results.webPublicationDate = MyMeta.results[i].webPublicationDate;
                        results.webTitle = MyMeta.results[i].webTitle;
                        results.webUrl = MyMeta.results[i].webUrl;
                        results.pillarName = MyMeta.results[i].pillarName;
                        results.sectionName = MyMeta.results[i].sectionName;
                        results.webPublicationDate = MyMeta.results[i].webPublicationDate;
                        nynewswrapper.add(results);
                    }
                    outcomeMsg='success';
                }
            }
            catch(Exception ex){
                system.debug('failed');
            }
        }
        system.debug(nynewswrapper);
        return nynewswrapper;
    }

}