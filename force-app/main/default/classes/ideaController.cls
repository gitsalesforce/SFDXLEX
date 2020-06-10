public class ideaController {
    
    @AuraEnabled
    public static list<wrapperList> selectidea(list<string> parameter)
    {
        List<wrapperList> ideass = new list<wrapperList>();
        Set<String> Categories = new Set<String>();    
        List<Idea> Idealist = new list<Idea>();
        if(parameter.size()>0){
            Idealist = [select id, Title,Status,Body,Categories from idea where Categories in : parameter];
        }
        else{
            Idealist =[select id, Title,Status,Body,Categories from idea];
        }
        for(idea ii: Idealist){
            Categories.add(ii.Categories);
            
            wrapperList obj = new wrapperList(ii,ii.Categories);
            ideass.add(obj);
        }
        system.debug(ideass);
        return ideass;
    }
    public class wrapperList{
        
        @AuraEnabled public string selected {get;set;} 
        @AuraEnabled public idea hit {get;set;} 
        public wrapperList(idea ii ,string  sel)
        {
            hit = ii;
            selected=sel;
        }
        
    }
}