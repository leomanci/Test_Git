public class AnimalLocator {
    public static String getAnimalNameById(Integer id){
        String result='';
        
        HttpRequest req=new HttpRequest();
        req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse resp=http.send(req);
        
        if(resp.getStatusCode()==200){
            Map<String,Object> resultMap=(Map<String,Object>)JSON.deserializeUntyped(resp.getBody());
        	result=(String)((Map<String,Object>)resultMap.get('animal')).get('name');
        }

        return result;
    }
}