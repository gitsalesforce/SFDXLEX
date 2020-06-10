/*NewsAPI V0.1*/
public class newsfi {
    private static final String API_KEY = '30774dadf4b64b75b6d8c5f9acb34201';//Callout limit 100 request
    //Main Wrapper
    public class newsresponse{
        @AuraEnabled
        public list<articles> articles{get;set;}//article's list 
    }
    //Category News Wrapper
    public class categorynews{
        @AuraEnabled
        public string source{get;set;}
        @AuraEnabled
        public string author{get;set;}
        @AuraEnabled
        public string title{get;set;}
        @AuraEnabled
        public string description{get;set;}
        @AuraEnabled
        public string url{get;set;}
        @AuraEnabled
        public string urltoImage{get;set;}
        @AuraEnabled
        public string publishedAt{get;set;}
        @AuraEnabled
        public string content{get;set;}
        @AuraEnabled
        public Integer TotalNumberOfRecord{get;set;}
        @AuraEnabled
        public callouttracker callout{get;set;}
    }
    //Article Wrapper
    public class articles{
        @AuraEnabled
        public string author{get;set;}
        @AuraEnabled
        public string title{get;set;}
        @AuraEnabled
        public string description{get;set;}
        @AuraEnabled
        public string url{get;set;}
        @AuraEnabled
        public string urltoImage{get;set;}
        @AuraEnabled
        public string publishedAt{get;set;}
        @AuraEnabled
        public string content{get;set;}
    }
    // Method to perform callouts
    public class callouttracker{
        @AuraEnabled
        public Integer RequestPerformed{get;set;}
    }
    @AuraEnabled
    public static list<categorynews> makeCalloutnews(string countryapex){
        // define a response to caller
        String outcomeMsg;
        string endpoint = 'https://newsapi.org'; // this is configured in "Remote Site Settings"
        string resource = '/v2/top-headlines?country='+countryapex+'&apiKey='+API_KEY;
        string method = 'GET'; //method name
        
        list<categorynews> wrapnews = new list<categorynews>();//final sending list to Aura Component
        set<categorynews> uniquewrapnews = new set<categorynews>();//Unique news selection
        if (Limits.getCallouts() >= Limits.getLimitCallouts()) {
            outcomeMsg = 'Maximum more than 100 number of callouts has been reached.';
        }
        else {
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http h = new Http();
            // Configure the request
            req.setEndpoint(endpoint + resource);
            req.setMethod(method);
            req.setTimeout(120000);
            req.setHeader('Accept', '*/*');
            req.setHeader('Content-Type', 'application/json');
            try {
                // Perform callout and set response
                res = h.send(req);
                // check response 
                if ((res.getStatusCode() == 200 || res.getStatusCode() == 201) && res.getBody() != null && res.getBody() != null) {
                    newsresponse MyMeta = (newsresponse) JSON.deserialize(res.getBody(),newsresponse.class);
                    //Iterating through the JSON Response from Server
                    for(Integer i=0;i<MyMeta.articles.size();i++){
                        categorynews news = new categorynews();
                        news.callout.RequestPerformed = Limits.getLimitCallouts();
                        news.author = MyMeta.articles[i].author;
                        news.title = MyMeta.articles[i].title;
                        news.description = MyMeta.articles[i].description;
                        news.url = MyMeta.articles[i].url;
                        news.urltoImage=MyMeta.articles[i].urltoImage;
                        news.publishedAt = MyMeta.articles[i].publishedAt;
                        news.content = MyMeta.articles[i].content;
                        news.TotalNumberOfRecord=MyMeta.articles.size();
                        uniquewrapnews.add(news);
                        
                    }
                    wrapnews = new list<categorynews>(uniquewrapnews);
                    
                }else {
                    outcomeMsg = 'Error: Verify key not found in response';
                }
            } 
            catch (DMLexception e) {
                // Unexpected exceptions will be caught here, like a deserialization error.
                outcomeMsg = 'Error: An exception has been encountered while calling out to Integration:  ' + e.getMessage();
            }
        }
        return wrapnews;//Sending the wrapped News
    }
    //Handling Anything List News
    @AuraEnabled
    public static list<categorynews> makeSearchAnything(string anyword){
        // define a response to caller
        String outcomeMsg;
        // define basic information for later, store these in a protected custom setting
        String endpoint = 'https://newsapi.org'; // this is configured in "Remote Site Settings"
        String resource = '/v2/everything?q='+anyword+'&apiKey='+API_KEY;
        String method = 'GET'; //method name
        list<categorynews> wrapnews = new list<categorynews>();//final sending list to Aura Component
        set<categorynews> uniquewrapnews = new set<categorynews>();//Unique news selection
        if (Limits.getCallouts() >= Limits.getLimitCallouts()) {
            outcomeMsg = 'Maximum more than 100 number of callouts has been reached.';
        }
        else {
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http h = new Http();
            // Configure the request
            req.setEndpoint(endpoint + resource);
            req.setMethod(method);
            req.setTimeout(120000);
            req.setHeader('Accept', '*/*');
            req.setHeader('Content-Type', 'application/json');
            try {
                // Perform callout and set response
                res = h.send(req);
                // check response 
                if ((res.getStatusCode() == 200 || res.getStatusCode() == 201) && res.getBody() != null && res.getBody() != null) {
                    newsresponse MyMeta = (newsresponse) JSON.deserialize(res.getBody(),newsresponse.class);
                    //Iterating through the JSON Response from Server
                    for(Integer i=0;i<MyMeta.articles.size();i++){
                        categorynews news = new categorynews();
                        //news.source=MyMeta.articles[i].source[i].name;
                        news.author = MyMeta.articles[i].author;
                        news.title = MyMeta.articles[i].title;
                        news.urltoImage=MyMeta.articles[i].urltoImage;
                        news.description = MyMeta.articles[i].description;
                        news.url = MyMeta.articles[i].url;
                        news.publishedAt = MyMeta.articles[i].publishedAt;
                        news.content = MyMeta.articles[i].content;
                        news.TotalNumberOfRecord=MyMeta.articles.size();
                        uniquewrapnews.add(news);
                        
                    }
                    wrapnews = new list<categorynews>(uniquewrapnews);
                    
                }else {
                    outcomeMsg = 'Error: Verify key not found in response';
                }
            } 
            catch (DMLexception e) {
                // Unexpected exceptions will be caught here, like a deserialization error.
                outcomeMsg = 'Error: An exception has been encountered while calling out to Integration:  ' + e.getMessage();
            }
        }
        return wrapnews;//Sending the wrapped News
    }
    //Handling Category List News
    @AuraEnabled
    public static list<categorynews> categorynewslauncherapex(string categorynameserver){
        // define a response to caller
        String outcomeMsg;
        String endpoint = 'https://newsapi.org'; // this is configured in "Remote Site Settings"
        String resource = '/v2/top-headlines?category='+categorynameserver+'&apiKey='+API_KEY;
        String method = 'GET'; //method name
        list<categorynews> wrapnews = new list<categorynews>();//final sending list to Aura Component
        set<categorynews> uniquewrapnews = new set<categorynews>();//Unique news selection
        if (Limits.getCallouts() >= Limits.getLimitCallouts()) {
            outcomeMsg = 'Maximum more than 100 number of callouts has been reached.';
        }
        else {
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http h = new Http();
            // Configure the request
            req.setEndpoint(endpoint + resource);
            req.setMethod(method);
            req.setTimeout(120000);
            req.setHeader('Accept', '*/*');
            req.setHeader('Content-Type', 'application/json');
            try {
                // Perform callout and set response
                res = h.send(req);
                // check response 
                if ((res.getStatusCode() == 200 || res.getStatusCode() == 201) && res.getBody() != null && res.getBody() != null) {
                    newsresponse MyMeta = (newsresponse) JSON.deserialize(res.getBody(),newsresponse.class);
                    //Iterating through the JSON Response from Server
                    for(Integer i=0;i<MyMeta.articles.size();i++){
                        categorynews news = new categorynews();
                        news.author = MyMeta.articles[i].author;
                        news.title = MyMeta.articles[i].title;
                        news.description = MyMeta.articles[i].description;
                        news.url = MyMeta.articles[i].url;
                        news.urltoImage=MyMeta.articles[i].urltoImage;
                        news.publishedAt = MyMeta.articles[i].publishedAt;
                        news.content = MyMeta.articles[i].content;
                        news.TotalNumberOfRecord=MyMeta.articles.size();
                        uniquewrapnews.add(news);
                    }
                    wrapnews = new list<categorynews>(uniquewrapnews);
                }else {
                    outcomeMsg = 'Error: Verify key not found in response';
                }
            } 
            catch (DMLexception e) {
                // Unexpected exceptions will be caught here, like a deserialization error.
                outcomeMsg = 'Error: An exception has been encountered while calling out to Integration:  ' + e.getMessage();
            }
        }
        return wrapnews;//Sending the wrapped News
    }
    
}