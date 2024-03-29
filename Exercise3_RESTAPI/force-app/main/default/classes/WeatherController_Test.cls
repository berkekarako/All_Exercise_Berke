@isTest
public with sharing class WeatherController_Test {
    private static Account testAccount;

    private static void createTestData() {
        testAccount = new Account(
            Name = 'Test Account',
            BillingCity = 'London'
        );
        insert testAccount;
        List<openweatherendpoint__c> cSettings = new List<openweatherendpoint__c>();
        for (Integer i = 0; i < 2; i++) {
            openweatherendpoint__c customSetting = new openweatherendpoint__c();
            if (i == 1) {
                customSetting.Name = 'OpenWeatherMap API';
                customSetting.Endpoint_URL__c = 'https://api.openweathermap.org/data/2.5/weather?q=';
            } else {
                customSetting.Name = 'OpenWeatherMap API2';
                customSetting.Endpoint_URL__c = '&units=metric&appid=388f8aa6cfe4d209c5ecdc6ea385f16d';
            }
            cSettings.add(customSetting);
        }
        insert cSettings;
    }
 
    @isTest
    static void weatherControllerPositiveTest() {
        createTestData();
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new WeatherConditionsMock());
        Apexpages.StandardController stdController = new Apexpages.StandardController(
            testAccount
        );
        WeatherController testController = new WeatherController(stdController);
        Test.stopTest();
        System.assert(testController.wrpData.description != null);
        System.assert(testController.wrpData.temp != null);
        System.assert(testController.wrpData.icon != null);
    }
  
    @isTest
    static void weatherControllerNegativeTest() {
        createTestData();
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new WeatherConditionsNegativeMock());
        Apexpages.StandardController stdController = new Apexpages.StandardController(
            testAccount
        );
        WeatherController testController = new WeatherController(stdController);
        Test.stopTest();
        System.assert(testController.wrpData == null);
    }
}