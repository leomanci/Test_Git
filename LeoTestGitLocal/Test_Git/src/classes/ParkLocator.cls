public class ParkLocator {
    public static String[] country(String country){
        String[] result=null;
        ParkService.ParksImplPort doSearch=new ParkService.ParksImplPort();
		result=doSearch.byCountry(country);        
        return result;
    }
}