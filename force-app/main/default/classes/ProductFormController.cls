public class ProductFormController {
    @AuraEnabled
    Public static List<ProductWrapper> getProductList(){
        List<ProductWrapper> contactList = new List<ProductWrapper>(); 
        List<Product2> conList = [SELECT Id, Name,ProductCode,QuantityUnitOfMeasure,(SELECT UnitPrice FROM PricebookEntries where Pricebook2.IsStandard = TRUE) FROM Product2 offset 12];
        if(conList!=null){
            for(Product2 con : conList){
                ProductWrapper obj = new ProductWrapper();
                obj.Id = con.Id;
                obj.Name = con.Name;
                obj.ProductCode = con.ProductCode;
                obj.QuantityUnitOfMeasure =(con.QuantityUnitOfMeasure);
                obj.PricebookEntries =con.PricebookEntries;
                obj.isSelected = false; 
                obj.counter=0;
                contactList.add(obj);
            }
        }
        system.debug(contactList.size());
        
        return contactList;
    }
    @AuraEnabled
    Public static list<Product2> processSelectedProducts(string ProductRecords){
        List<ProductWrapper> ProductList = new  List<ProductWrapper>();
        if(!string.isBlank(ProductRecords)){
            ProductList = (List<ProductWrapper>)System.JSON.deserialize(ProductRecords,List<ProductWrapper>.class);
        }
        
        list<Product2> ll = new list<Product2>();
        for(ProductWrapper pon:ProductList){
            Product2 pp = new Product2();//Instnace
            pp.Name=pon.Name;
            pp.ProductCode=pon.ProductCode;
            pp.QuantityUnitOfMeasure=String.valueOf(pon.counter);
            ll.add(pp);
           
            
        }
        return ll;
    }
    
    public class ProductWrapper{
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String ProductCode {get;set;}
        @AuraEnabled
        public String QuantityUnitOfMeasure {get;set;}
        @AuraEnabled
        public list<PriceBookEntry> PricebookEntries {get;set;}
        @AuraEnabled
        public boolean isSelected {get;set;}
        @AuraEnabled
        public Integer counter {get;set;}
    }
}