({
    doInit : function(component, event, helper) {
        document.title = "News-Fi";      
    },
    Search: function(component, event, helper) {
        var country= component.find('statusPicklist').get('v.value');
        // else call helper function 
        helper.preproductdetails(component);
    },
    SearchAnything: function(component, event, helper) {
        helper.searchanything(component);
        
    },
    //onchange Search controller
    performSearch: function(component, event, helper) {
        var searchInput = component.find("searchInput");
        var searchValue = searchInput.get("v.value");
        var action1= component.get("c.makeSearchAnything");
        action1.setParams({
            anyword: searchValue,//SETTING THE CLASS ARGUMENT name setting
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
      handlesports : function (component, event, helper) {
        var category_button = component.find("category_button_sports");
        category_button = Array.isArray(category_button) ? category_button[0].get("v.title") : category_button.get("v.title");
        helper.categorynewslauncher(component,category_button);
    },
    handlebusiness : function (component, event, helper) {
         var category_button = component.find("category_button_business");
        category_button = Array.isArray(category_button) ? category_button[0].get("v.title") : category_button.get("v.title");
        helper.categorynewslauncher(component,category_button);
    },
    handlegeneral : function (component, event, helper) {
         var category_button = component.find("category_button_general");
        category_button = Array.isArray(category_button) ? category_button[0].get("v.title") : category_button.get("v.title");
        helper.categorynewslauncher(component,category_button);
    },
    handlehealth : function (component, event, helper) {
         var category_button = component.find("category_button_health");
        category_button = Array.isArray(category_button) ? category_button[0].get("v.title") : category_button.get("v.title");
        helper.categorynewslauncher(component,category_button);
    },
    handlescience : function (component, event, helper) {
         var category_button = component.find("category_button_science");
        category_button = Array.isArray(category_button) ? category_button[0].get("v.title") : category_button.get("v.title");
        helper.categorynewslauncher(component,category_button);
    },
    handletechnology : function (component, event, helper) {
        var category_button = component.find("category_button_technology");
        category_button = Array.isArray(category_button) ? category_button[0].get("v.title") : category_button.get("v.title");
        helper.categorynewslauncher(component,category_button);
    },//handleentertainment
    handleentertainment : function (component, event, helper) {
        var category_button = component.find("category_button_entertainment");
        category_button = Array.isArray(category_button) ? category_button[0].get("v.title") : category_button.get("v.title");
        helper.categorynewslauncher(component,category_button);
    },//
})