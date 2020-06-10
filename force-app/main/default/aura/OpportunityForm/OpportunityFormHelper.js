({
    //Fetching the data
    getData : function(cmp) {
        //Getting the list of Opportunity from Apex-Server
        var action = cmp.get('c.GetOpportunity');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.mydata', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    //Fetching the data
    getProductData : function(cmp,pass) {
        //Getting the list of Opportunity from Apex-Server
        var newaction = cmp.get('c.getproduct');
        console.log(newaction);
         newaction.setParams({
            "recordId":pass.Id
        });
        newaction.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.mydataoppline', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(newaction);
    },
    //Creating the product page for Opportunity
    getProductFormPage:function(cmp,row){
       //Getting the list of Opportunity from Apex-Server
       cmp.set("v.showproduct",true);//true show
        
    },
    //Implement Delete Operation
     deleteRow: function(cmp, row) {
      var action = cmp.get("c.deleteopps");
        action.setParams({
            "op":row
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = cmp.get('v.mydata');
                var rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);
                cmp.set('v.mydata', rows);
            }
             else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    //Sorting the fields in the columns
    sortData:function(component,fieldName,sortDirection){
        var data = component.get("v.mydata");//Opportunity 
        var dataproduct = component.get("v.mydataoppline");//Product
           var key = function(a){
            return a[fieldName];
        }
        var reverse= sortDirection=='asc'?1:-1; 
        // to handel number/currency type fields 
        if(fieldName == 'Amount' || fieldName=='ExpectedRevenue' || fieldName=='ListPrice'|| fieldName=='Quantity'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
            dataproduct.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else {// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });   
            dataproduct.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });   
        }
        component.set("v.mydata",data); //Set Opportunity Sort
        component.set("v.mydataoppline",dataproduct); // Set Product Sort
    }
    
})