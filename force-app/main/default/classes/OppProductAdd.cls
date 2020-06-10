public class OppProductAdd {
    public static void processSelectedProducts(){
        list<Product2> lsp = new list<Product2>();
        Product2 pp = new Product2();//first product
        Product2 pp1 = new Product2();//second product
        pp.Name='GenWatt Diesel 10kW';
        pp.ProductCode='GC1020';
        pp.QuantityUnitOfMeasure=String.valueOf(2);
        lsp.add(pp);
        /////////////////////////
        pp1.Name='GenWatt Diesel 1000kW';
        pp1.ProductCode='GC1060';
        pp1.QuantityUnitOfMeasure=String.valueOf(10);
        lsp.add(pp1);
        insert lsp;//product list added
        Opportunity op = [select id,name from Opportunity where name=:'Google' limit 1];
        for(Integer i=0;i<lsp.size();i++){
            PriceBook2 stdPriceBookRecId = [SELECT Id, isstandard FROM Pricebook2 WHERE IsStandard=true];
            OpportunityLineItem[] lines = new OpportunityLineItem[0];
            PricebookEntry entry = [SELECT Id,Name,UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :stdPriceBookRecId.Id AND Product2.ProductCode = :lsp.get(i).ProductCode AND Product2.Name = :lsp.get(i).Name];
            //Mapping standeredBook id to Opportunity
            //Inserting OpportunityLineItem With the PricebookEntrtId
            lines.add(new OpportunityLineItem(PricebookEntryId=entry.Id, OpportunityId=op.id, UnitPrice=entry.UnitPrice, Quantity=integer.valueOf(lsp.get(i).QuantityUnitOfMeasure)));
            upsert lines;
        }
        
        
    }
}