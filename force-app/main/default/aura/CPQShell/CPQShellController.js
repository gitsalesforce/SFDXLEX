({
    initData: function(component, event, helper) {
        //document.title('Contract CPQ');
        helper.getCardsLoad(component, event, helper);
        helper.getopps(component, event, helper);
    },
    handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Account Created",
            "message": "Record ID: " + event.getParam("id")
        });
    },
    handleShowActiveSectionName: function (cmp, event, helper) {
        alert(cmp.find("accordion").get('v.activeSectionName'));
    },
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        
        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    }
})