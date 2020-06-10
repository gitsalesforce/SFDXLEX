({
    doInit : function(component, event, helper) {
        helper.preproductdetails(component); // Calling Helper Fetch method        
    },
    //function to increase the quanity 
    handleClickinc : function(component, event,helper) {        
        var productsq=component.get("v.ProductList");
        var affiliation = productsq[event.srcElement.id];
        var list1=[];
        list1.push(affiliation);
        list1[0].counter=list1[0].counter+1;
        component.set('v.ProductList.counter',list1[0].counter);
    },
    //function to decrease the quanity 
    handleClickdec: function(component, event,helper) {
        var productsq=component.get("v.ProductList");
        var affiliation = productsq[event.srcElement.id]; 
        var list1=[];
        list1.push(affiliation);
        console.log('counter>>'+ list1[0].counter);
        if( list1[0].counter<=0){
            alert('Your quantity is zero');
        }
        else{
            list1[0].counter=list1[0].counter-1;}
        component.set('v.ProductList.counter',list1[0].counter);        
    },
    //function to select all the products (optional)
    handleSelectAllProduct: function(component, event, helper) {
        var getID = component.get("v.ProductList");
        var checkvalue = component.find("selectAll").get("v.value");        
        var checkProduct = component.find("checkProduct"); 
        if(checkvalue == true){
            for(var i=0; i<checkProduct.length; i++){
                checkProduct[i].set("v.value",true);
            }
        }
        else{ 
            for(var i=0; i<checkProduct.length; i++){
                checkProduct[i].set("v.value",false);
            }
        }
    },
    //function to submit the products 
    addIncome:function(component,event,helper){
        var ProductList = component.get("v.ProductList");
        var UnitPrices = [];//store unit prices
        //list of wrappers in controller side
        var selectedProducts = [];//getting the products value
        var k = 0;
        for (var i=0; i<ProductList.length; i++){
            var c = ProductList[i];
            //checking the quantity of product
            if(c.counter>0) {
                selectedProducts[k] = c;
                UnitPrices[k]=c.PricebookEntries;
                k++; 
            }
        }
        //component.set("v.rows",UnitPrices.length);//show total product selected
        if(selectedProducts.length > 0){
            var contactRecords = JSON.stringify(selectedProducts);
            var action = component.get("c.processSelectedProducts");
            action.setParams({
                ProductRecords : contactRecords,//passing wrapper list
                // oppid:passingId //Opportunity Id
            });
            
            
            action.setCallback(this, function(result){
                var state = result.getState();
                if (component.isValid() && state === "SUCCESS"){
                    var res1 = result.getReturnValue();
                    
                    var childCmp = component.find('childCmp');//getting child comp
                    childCmp.sampleMethod(res1,UnitPrices);//calling the child method
                }
                else if(state == "ERROR"){
                   
                }
            });
            $A.enqueueAction(action);
        }
    }
    
})