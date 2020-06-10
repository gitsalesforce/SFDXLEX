//Trigger to update Product Names,Quantity of corresponding Opportunity[V.48]
//Prerequisite Fields on Opportunity 
//1.Product_Names__c[long text](Stores total Products Name)
//2.Total_Product__c[Number](Stores total size of Products)
//3.Total_Sales_Price__c[Number](Stores Total list price of Prodcuts)
trigger OppLineItemProduct on OpportunityLineItem (after insert,after update,after delete) {
    //Handle the New and Old Data
    list<OpportunityLineItem> oppitems = Trigger.IsDelete?Trigger.Old:Trigger.new;
    //List for the Opportunity Updates
    list<Opportunity> opps = new list<Opportunity>();
    //Unique Current ID of OpportunityLineItem Object
    Set<id> lsset = new set<id>();
    for(OpportunityLineItem os:oppitems){
        lsset.add(os.OpportunityId);
    }
    //Map of OpportunityLineItem Current Record
    map<id,OpportunityLineItem> newmap = new map<id,OpportunityLineItem>([select id,Product2ID,product2.name, quantity, Listprice,OpportunityId from OpportunityLineItem where OpportunityId in:lsset]);
    //Map of Corresponding Opportunity to OpportunityLineItem
    map<id,Opportunity> newopp = new map<id,Opportunity>([select id,name,Product_Names__c from opportunity where id in:lsset]);
    //Map of Corresponding Product to Opportunity only ID Mapping
    //Map of productmap of only ID>>[ProductID,OpportunityLineItemID] 
    map<id,id> productmap = new map<id,id>();
    for(ID a :newmap.keySet()){
        productmap.put(newmap.get(a).Product2ID,a);
    }
    //Map of Product Details of Coressponding ID
    map<id,Product2> finalProduct = new map<id,Product2>([select id,name,QuantityUnitOfMeasure,StockKeepingUnit from Product2 where id in:productmap.keySet()]);
    String name=' ';//Product Name
    Decimal Price=0;//Product Lumpsum Price
    for(id ac:newopp.keySet()){
        Opportunity op = new Opportunity();//Opportunity Instance
        op.id=ac;//Mapping Opportunity ID with the fetched Record
        for(ID con:finalProduct.keySet()){
            
            if(String.isNotEmpty(finalProduct.get(con).Name)){
                name+=finalProduct.get(con).name+' ,';//Looping through all Product and concatenate in the name field
            }
        }
        for(id oppitem:newmap.keySet()){
            //check if the record is alrady present in the map
            system.debug(oppitem);
            if(newmap.containsKey(oppitem)){
                if(newmap.get(oppitem).Listprice!=0){
                    Price+=newmap.get(oppitem).Listprice;//Looping through all individual products and adds listprice to the opportunity field
                }
            }
        }
        op.Product_Names__c=name;//Update product Names
        op.Total_Product__c=finalProduct.size();//Update Total Product Size
        op.Total_Sales_Price__c=Price;//Update total Price of Products
        opps.add(op);//Add all updation to the list 
    }
    //Check if the Opportunity list is greater than 0
    if(opps.size()>0){
        update opps;//Perform DML
    }
}