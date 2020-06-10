public class KB_MOD_47 {
    public STATIC list <Knowledge__kav> ll(){
        list<Knowledge__kav> nn = new list<Knowledge__kav>([select id,ArticleNumber,Summary from Knowledge__kav]);
        system.debug(nn);
        return nn;
    }
public class articleFAQ{
    public String Title{get;set;}
    public string url{get;set;}
    public string question{get;set;}
    public string answer{get;set;} 
}
public class articleHOW{
    public String Title{get;set;}
    public string url{get;set;}
    public string Publication_status{get;set;}
    public string Validation_status{get;set;}
    public string summary{get;set;}  
}    
}