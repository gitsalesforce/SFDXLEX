({
       //getConListCall
    getConListCall : function(component,event,helper,callback2) {
        
        try
        {
            var action = component.get("c.getlistContact");
            action.setCallback(this, function(response) {
                if(response.getState() == 'SUCCESS')
                {
                    if(callback2) callback2(response.getReturnValue());    
                }
            });
            $A.enqueueAction(action);
        }
        catch(e)
        {
            console.log('Exception '+e);
        }
    },
       //getOppListCall
    getOppListCall : function(component,event,helper,callback3) {
        
        try
        {
            var action = component.get("c.getlistOpportunity");
            action.setCallback(this, function(response) {
                if(response.getState() == 'SUCCESS')
                {
                    if(callback3) callback3(response.getReturnValue());    
                }
            });
            $A.enqueueAction(action);
        }
        catch(e)
        {
            console.log('Exception '+e);
        }
    },
    getAccListCall : function(component,event,helper,callback1) {
        
        try
        {
            var action = component.get("c.getAccount");
            action.setCallback(this, function(response) {
                if(response.getState() == 'SUCCESS')
                {
                    if(callback1) callback1(response.getReturnValue());      
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " +
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);
        }
        catch(e)
        {
            console.log('Exception '+e);
        }
    },
    
})