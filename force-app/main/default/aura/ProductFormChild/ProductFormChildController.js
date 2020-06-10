({
    doAction : function(component, event, helper) {
        var params = event.getParam('arguments');
        if(params){
            var param = params.param;//prodcut
            var param1 = params.param1;//price
            component.set('v.mydata3',param);
        }
    }
})