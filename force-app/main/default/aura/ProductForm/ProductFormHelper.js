({
    //fetching the list of products
    preproductdetails : function( component ) {
        var action1= component.get("c.getProductList"); //Calling Apex class controller 'getAccountRecord' method
        action1.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.ProductList", response.getReturnValue());  // Adding values in Aura attribute variable.  
            }
            else if (state === "INCOMPLETE"){
                console.log('failed');
            }
        });
        
        $A.enqueueAction(action1);
    },
    
    
    
})