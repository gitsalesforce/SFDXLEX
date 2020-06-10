({
    //fetching the list of news by Country-wise
    preproductdetails : function( component) {
        var action1= component.get("c.makeCalloutnews");
        var country= component.find('statusPicklist').get('v.value');//country selected
        action1.setParams({
            countryapex: country,
        });
        action1.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.newsresponse", response.getReturnValue());  // Adding values in Aura attribute variable.   
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted,Records are large');
            }});
        
        $A.enqueueAction(action1);
    },
    //fetching the list of news
    searchanything : function( component ) {
        var action1= component.get("c.makeSearchAnything");
        var word= component.get("v.searchanything");
        action1.setParams({
            anyword: word,//SETTING THE CLASS ARGUMENT name setting
        });
        action1.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.newsresponse", response.getReturnValue());  // Adding values in Aura attribute variable.   
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted,Records are large');
            }});
        
        $A.enqueueAction(action1);
    },
    //fetching the list of category news 
    categorynewslauncher : function( component,category_button ) {
        var action1= component.get("c.categorynewslauncherapex");
         action1.setParams({
            categorynameserver: category_button,//SETTING THE CLASS ARGUMENT name setting
        });
        action1.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.newsresponse", response.getReturnValue());  // Adding values in Aura attribute variable.   
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted,Records are large');
            }});
        
        $A.enqueueAction(action1);
    },
    
})