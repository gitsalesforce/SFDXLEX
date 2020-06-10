({
    childcmpMethodCall : function(component, event, helper) {
       component.find("childCmp").childcmpMethodCall1(function(response){component.set("v.myText1",response)});
       component.find("childCmp").childcmpMethodCall2(function(response){component.set("v.myText2",response)});
       component.find("childCmp").childcmpMethodCall3(function(response){component.set("v.myText3",response)});
       var loadTime = window.performance.timing.domContentLoadedEventEnd- window.performance.timing.navigationStart;
       var consume = window.performance;
       component.set("v.infojs",consume.memory);
        
        
    },
       closeModal:function(component,event,helper){    
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    openmodal: function(component,event,helper) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    }
})