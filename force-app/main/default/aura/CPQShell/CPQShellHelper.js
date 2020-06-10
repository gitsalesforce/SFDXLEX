({
    getCardsLoad: function(component, event, helper) {
        var action = component.get('c.CardsCount');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.CardsWrapper', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getopps: function(component, event, helper) {
        var action =component.get("c.GetOpportunity");
        action.setCallback(this, function(response){ 
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.OpportunityCPQ', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})