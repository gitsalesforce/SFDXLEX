({
    //method calling for account details
    AccountDetailMethodCall : function(component, event, helper) {
        var params = event.getParam('arguments');
        var callbackaccount;
        if (params) {
            callback1 = params.callbackaccount;
        }
        helper.getAccdetails(component,event,helper,callback1);
        
        //method calling for contact details
    }, ContactDetailMethodCall : function(component, event, helper) {
        var params = event.getParam('arguments');
        var callbackcontact;
        if (params) {
            callback2 = params.callbackcontact;
        }
        helper.getCondetails(component,event,helper,callback2);
        
    },
    //method calling for opps details
    OppsDetailMethodCall : function(component, event, helper) {
        var params = event.getParam('arguments');
        var callbackopps;
        if (params) {
            callback3 = params.callbackopps;
        }
        helper.getOppdetails(component,event,helper,callback3);
        
    },
    
    
})