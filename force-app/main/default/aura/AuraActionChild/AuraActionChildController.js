({
    
    childcmpMethodCall1 : function(component, event, helper) {
        var params = event.getParam('arguments');
        var callback1;
        if (params) {
            callback1 = params.callback1;
        }
        helper.getAccListCall(component,event,helper,callback1);
        
    }, childcmpMethodCall2 : function(component, event, helper) {
        var params = event.getParam('arguments');
        var callback2;
        if (params) {
            callback2 = params.callback2;
        }
        helper.getConListCall(component,event,helper,callback2);
        
    },

     childcmpMethodCall3 : function(component, event, helper) {
        var params = event.getParam('arguments');
        var callback3;
        if (params) {
            callback3 = params.callback3;
        }
        helper.getOppListCall(component,event,helper,callback3);
        
    },
 
    
})