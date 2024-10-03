@IsTest
public with sharing class TSSGoogleMapsRouteTest {

    @IsTest
    static void testLocationRequest() {
        TSSGoogleMaps.GoogleMapsLocation origin = new TSSGoogleMaps.GoogleMapsLocation(34.180790, -118.394740);
        TSSGoogleMaps.GoogleMapsLocation destination = new TSSGoogleMaps.GoogleMapsLocation(34.101090, -118.340060);

        Test.setMock(HttpCalloutMock.class, new TSSGoogleMapsRouteMock());

        Test.startTest();
        TSSGoogleMaps.RouteResponse routeResponse = TSSGoogleMapsRoute.getRoute(origin, destination);
        Test.stopTest();

        System.assert(routeResponse.getRoutes().size() == 1);
    }

    @IsTest
    static void testLocationRequestResponse() {
        TSSGoogleMaps.GoogleMapsLocation origin2 = new TSSGoogleMaps.GoogleMapsLocation(34.180790, -118.394740);
        TSSGoogleMaps.GoogleMapsLocation destination2 = new TSSGoogleMaps.GoogleMapsLocation(34.101090, -118.340060);

        Test.setMock(HttpCalloutMock.class, new TSSGoogleMapsRouteMock());

        Test.startTest();
        HttpResponse httpResponse = TSSGoogleMapsRoute.getRouteHttpResponse(origin2, destination2);
        Test.stopTest();

        System.assertEquals(200, httpResponse.getStatusCode());
    }

    @IsTest
    static void testAddressRequest() {
        TSSGoogleMaps.GoogleMapsAddress originAddr = new TSSGoogleMaps.GoogleMapsAddress('6150 Laurel Canyon Blvd.', 'North Hollywood', 'CA', 'USA');
        TSSGoogleMaps.GoogleMapsAddress destinationAddr = new TSSGoogleMaps.GoogleMapsAddress('6840 Hollywood Blvd.', 'Los Angeles', 'CA', 'USA');

        Test.setMock(HttpCalloutMock.class, new TSSGoogleMapsRouteMock());

        Test.startTest();
        TSSGoogleMaps.RouteResponse routeResponse = TSSGoogleMapsRoute.getRoute(originAddr, destinationAddr);
        Test.stopTest();

        System.assert(routeResponse.getRoutes().size() == 1);
    }

    @IsTest
    static void testAddressRequestResponse() {
        TSSGoogleMaps.GoogleMapsAddress originAddr2 = new TSSGoogleMaps.GoogleMapsAddress('6150 Laurel Canyon Blvd.', 'North Hollywood', 'CA', 'USA');
        TSSGoogleMaps.GoogleMapsAddress destinationAddr2 = new TSSGoogleMaps.GoogleMapsAddress('6840 Hollywood Blvd.', 'Los Angeles', 'CA', 'USA');

        Test.setMock(HttpCalloutMock.class, new TSSGoogleMapsRouteMock());

        Test.startTest();
        TSSGoogleMapsRoute.RETURN_ROUTE_TOKEN = true;
        TSSGoogleMapsRoute.ROUTING_PREFERENCE = TSSGoogleMaps.RoutingPreference.TRAFFIC_AWARE;
        HttpResponse httpResponse = TSSGoogleMapsRoute.getRouteHttpResponse(originAddr2, destinationAddr2);
        Test.stopTest();

        System.assertEquals(200, httpResponse.getStatusCode());
    }

}