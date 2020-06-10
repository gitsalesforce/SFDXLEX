trigger ProductDupsCheck on Product2 (before insert,before update,before delete) {
    List<Product2> newprod = Trigger.IsDelete?Trigger.old:trigger.new;
    list<Product2> prod1 = new list<Product2>();
    // Set to store ids
    map<id,Product2> prodmap = new map<id,Product2>(); 
    for (Product2 c : newprod){
        prodmap.put(c.id,c);
    }
    prod1= [select id from Product2 where id in :prodmap.keySet()];
    system.debug(prod1);
    for(Product2 pp:trigger.new){
        if (prod1.size() > 0) {
            pp.Name.addError('Duplicate Product Found Update the same product field');
        }  
    }
}