public with sharing class WeatherController {
    public static final String HTTP_RESPONSE_ERROR = 'Error : An error occurred while retrieving weather information!';
    public WrapperData wrpData { get; set; }
    private final Account acc;
    private String city;
 
    public WeatherController(ApexPages.StandardController controller) {
        this.acc = (Account) controller.getRecord();
        this.city = this.acc.BillingCity;
        fetchWeatherInfo();
    }

    private void fetchWeatherInfo() {
        try {
            List<openweatherendpoint__c> endPointDatas = openweatherendpoint__c.getAll().values();
            String endPoint=endPointDatas.get(1).Endpoint_URL__c + city + endPointDatas.get(0).Endpoint_URL__c;
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            Http http = new Http();
            request.setEndpoint(endPoint);
            request.setMethod('GET');
            response = http.send(request);
            if (response.getStatusCode() == 200) {
                String jsonResponse = response.getBody();
                FromJSON jsonParseData = (FromJSON) parse(jsonResponse);
                wrpData = new WrapperData(jsonParseData);
            } else {
                ApexPages.addmessage(
                    new ApexPages.message(
                        ApexPages.severity.ERROR,
                        HTTP_RESPONSE_ERROR
                    )
                );
            }
        } catch (Exception e) {
            System.debug('Error: ' + e);
        }
    }
    
    public class WrapperData {
        public Double temp { get; set; }
        public String description { get; set; }
        public String icon { get; set; }
        public WrapperData(FromJSON parseData) {
            Main te = parseData.main;
            this.temp = te.temp;
            this.description = parseData.weather[0].description;
            this.icon =
                'http://openweathermap.org/img/wn/' +
                parseData.weather[0].icon +
                '@2x.png';
        }
    }
    
    public class FromJSON {
        public Weather[] weather;
        public Main main;
    }
   
    public class Weather {
        public String main;
        public String description;
        public String icon;
    }
    
    public class Main {
        public Double temp;
        public Integer humidity;
    }
    
    private FromJSON parse(String json) {
        return (FromJSON) System.JSON.deserialize(json, FromJSON.class);
    }
}