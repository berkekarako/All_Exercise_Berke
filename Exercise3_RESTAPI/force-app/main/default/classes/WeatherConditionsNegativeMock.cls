
@isTest
public with sharing class WeatherConditionsNegativeMock implements HttpCalloutMock {
  
    public static HttpResponse respond(HttpRequest request) {
        System.assertEquals('GET', request.getMethod());

        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"cod": "404", "message": "city not found"}');
        response.setStatusCode(400);
        return response;
    }
}