({
    handleSelect : function (component, event, helper) {
        //get selected Status value
        var selectStatus = event.getParam("detail").value;
        //set selected Status value
        component.set("v.picklistField.Status__c", selectStatus);
         
        component.find("record").saveRecord($A.getCallback(function(response) {
            if (response.state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                component.find('notifLib').showToast({
                    "variant": "success",
                    "message": "Record was updated sucessfully",
                    "mode" : "sticky"
                });
            } else {
                component.find('notifLib').showToast({
                    "variant": "error",
                    "message": "There was a problem updating the record.",
                    "mode" : "sticky"
                });
            }
        }));
    }
})