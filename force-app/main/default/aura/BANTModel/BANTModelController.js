({
    doinit : function(component, event, helper) {
        document.title = "Account Warpper Picklist";
        var action = component.get('c.fetchAcc');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();
                //console.log("allValues--->>> " + allValues);
                component.set('v.mydata', allValues);
                component.set("v.sortAsc", true);
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
     sortByAmount: function(component, event, helper) {
        helper.sortBy(component, "Phone");
    },
     onChange: function (component, evt, helper) {
         if(component.find('select').get('v.value')=='Recently_Modified'){
        var action = component.get('c.fetchAccrecently');
             component.set("v.heavy",false);
              component.set("v.light",true);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();
                console.log("allValues--->>> " + allValues);
                component.set('v.mydata', allValues);
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
         }
         else if(component.find('select').get('v.value')=='Heavy_Weight'){
             component.set("v.heavy",true);
             component.set("v.light",false);
            var action = component.get('c.fetchHeavy');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();
               /* var list1 = component.get('v.mydata');
                for(var i=0;i<10;i++){
                    list1.push(allValues[i]);
                }*/
                component.set('v.mydata', allValues);
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action); 
         }
            else if(component.find('select').get('v.value')=='None'){
            var action = component.get('c.fetchNone');
                component.set("v.heavy",false);
                 component.set("v.light",true);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();
                console.log("allValues--->>> " + allValues);
                component.set('v.mydata', allValues);
                
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action); 
         }
    },
    
    showCon : function(component, event, helper){
        component.set("v.show",true);
        component.set("v.heavy",true);
        var idxx = event.target.getAttribute('data-index');
        console.log('idx---->>> ' + idxx);
        var rowRecord = component.get("v.mydata")[idxx];
        console.log('rowRecord---->>> ' + (rowRecord));
        //fetching contact related account
        var action = component.get('c.fetchCon');
        //fetching opportunity related account
        var actionopp = component.get('c.fetchOpp');
         //fetching cases related account
        var actioncase = component.get('c.fetchCase');
        action.setParams({recordId : rowRecord.Id});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();
                console.log("allValues of contact--->>> " + JSON.stringify(allValues));
                component.set('v.mydata2', allValues);
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        //Enque the action for the contact respective to account
        $A.enqueueAction(action);
        //Callback for the Opportunity Object with respect to account
         actionopp.setCallback(this, function(response){
             //check for the state for the response
            var state = response.getState();
            if(state === "SUCCESS"){
                //Getting result from the apex class dml query
                var allValues = response.getReturnValue();
                console.log("allValues of opportunity--->>> " + JSON.stringify(allValues));
                component.set('v.mydata3', allValues);
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(actionopp);
        //Callback for the case Object with respect to account
         actioncase.setCallback(this, function(response){
             //check for the state for the response
            var state = response.getState();
            if(state === "SUCCESS"){
                //Getting result from the apex class dml query
                var allValues = response.getReturnValue();
                console.log("allValues of Cases--->>> " + JSON.stringify(allValues));
                component.set('v.mydata4', allValues);
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(actioncase);
    },
  
})