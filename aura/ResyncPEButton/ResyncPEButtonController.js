/**
 * Created by joannabak on 8/20/19.
 */
({
    handleResync : function(component, event, helper)
    {

        var action = component.get('c.resyncButtonClick');

        action.setParams({
            recordId : component.get("v.recordId")
        });

        action.setCallback(this, function(response){
            var rtnVal = response.getState();
            console.log("======rtnVal======", rtnVal);

            if(rtnVal === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "success",
                    "message": component.get("v.successMessage")
                });
                toastEvent.fire();
            }
            if(rtnVal === "ERROR"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error Syncing",
                    "type" : "warning",
                    "message": component.get("v.errorMessage")
                });
                toastEvent.fire();
             }
        });

        $A.enqueueAction(action);
    },
})