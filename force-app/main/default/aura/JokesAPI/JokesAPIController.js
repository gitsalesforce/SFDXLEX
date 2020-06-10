({
    handleClick : function(component, event, helper) {
        const number = component.find('number').get('v.value');

        if (number) {
            component.set('v.number', number);
            helper.handleAjaxRequest(component, event, helper);
        }

    },
    handleClick1 : function(component, event, helper) {
        const number = component.find('string').get('v.value');

        if (number) {
            component.set('v.string', number);
            helper.handleAjaxRequest1(component, event, helper);
        }

    }
})