//Create custom setting for file names and columns to query??
global class CSVFileGenerator {
    private static final String COLUMNS='ID,CaseNumber,Payment_Type__c'; //Read from custom setting
    private static final String SEPARATOR=',';
    private static String fileName='';
    private static final String FILE_EXT='.csv';
    private static final String TIMESTAMP=String.valueOf(Date.today().day())+
        								  String.valueOf(Date.today().month()) +
        								  String.valueOf(Date.today().year())+'_'+
        								  String.valueOf(Datetime.now().hour())+
        								  String.valueOf(Datetime.now().minute());
   
    webservice static void generateCSVFiles(){
        Map<String, List<Case>> cases=new Map<String,List<Case>>();
        
        String query='SELECT '+COLUMNS+' FROM Case WHERE Payment_Type__c IN (\'EFT\',\'Cheque\',\'BPAY\')';
        
        try{
        	for(Case c:(List<Case>)Database.query(query)){
                if(!cases.containsKey(c.Payment_Type__c)){
                    cases.put(c.Payment_Type__c,new List<Case>{c});
                }
                else{
                    cases.get(c.Payment_Type__c).add(c);
                }
        	}
        }
        catch(QueryException ex){
        	System.debug('An error has ocurred querying case data '+ex);
    	}
        catch(Exception e){
            System.debug('An unexpected error has ocurred '+e);
        }
        
        //Process individual CSV files
        generateEFTCSV(cases.get('EFT'));
    } 

    private static void generateEFTCSV(List<Case> eftCases){
        String content=COLUMNS+'\n';
        for(Case c:eftCases){
            content+=c.ID+SEPARATOR+c.CaseNumber+'\n';
        }
        
        filename='EFT_'+TIMESTAMP;
        outputCSV(fileName,content);
    }
    
    private void generateChequeCSV(){
        
    }
    
    private void generateBPAY_PPHouseCSV(){
        
    }
    
    private void generateBPAY_ServProvidersCSV(){
        
    }
    private static void outputCSV(String fName, String content){
        Blob b=Blob.valueOf(content);
       
        Document doc=new Document();
        doc.Body=b;
        doc.Name=fName+FILE_EXT;
        doc.Description='CSV Payment File';
        doc.IsPublic=true;
        doc.DeveloperName=fName;
        
        //Make custom setting or custom meta data
        doc.FolderId=[SELECT ID FROM Folder WHERE Name ='CSV Output' LIMIT 1].ID;
        
        try{
        	insert doc;
        }catch(DMLException ex){
        	System.debug('An error has ocurred querying case data '+ex);  
        }
        
        System.debug('@@@ DOC ID '+doc.ID);
    }
}