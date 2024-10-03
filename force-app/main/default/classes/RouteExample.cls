public with sharing class RouteExample {

    /**
     * This is a formatted response that uses addresses for the origin and destination
     */
    public static void addressExample() {
        // Format an origin and destination
        TSSGoogleMaps.GoogleMapsAddress originAddr = new TSSGoogleMaps.GoogleMapsAddress('6150 Laurel Canyon Blvd.', 'North Hollywood', 'CA', 'USA');
        TSSGoogleMaps.GoogleMapsAddress destinationAddr = new TSSGoogleMaps.GoogleMapsAddress('6840 Hollywood Blvd.', 'Los Angeles', 'CA', 'USA');

        // Make a simple request to retrieve a RouteResponse
        TSSGoogleMaps.RouteResponse response = TSSGoogleMapsRoute.getRoute(originAddr, destinationAddr);

        // Output the route details
        if (response.statusCode == 200) {
            for (TSSGoogleMaps.GoogleRoute route : response.getRoutes()) {
                System.debug('Seconds: ' + route.durationInSeconds);
                System.debug('Miles: ' + route.distanceInMiles);
                System.debug(route);
            }
        }
    }

    /**
     * This is a formatted response that uses coordinates for the origin and destination
     */
    public static void geoExample() {
        // Format an origin and destination
        TSSGoogleMaps.GoogleMapsLocation origin = new TSSGoogleMaps.GoogleMapsLocation(34.180790, -118.394740);
        TSSGoogleMaps.GoogleMapsLocation destination = new TSSGoogleMaps.GoogleMapsLocation(34.101090, -118.340060);

        // Make a simple request to retrieve a RouteResponse
        TSSGoogleMapsRoute.RETURN_ROUTE_TOKEN = true;
        TSSGoogleMapsRoute.ROUTING_PREFERENCE = TSSGoogleMaps.RoutingPreference.TRAFFIC_AWARE; // **WARNING: TRAFFIC_AWARE and TRAFFIC_AWARE_OPTIONAL are billed at a higher rate
        TSSGoogleMaps.RouteResponse response = TSSGoogleMapsRoute.getRoute(origin, destination);

        // Output the route details
        if (response.statusCode == 200) {
            for (TSSGoogleMaps.GoogleRoute route : response.getRoutes()) {
                System.debug('Seconds: ' + route.durationInSeconds);
                System.debug('Miles: ' + route.distanceInMiles);
                System.debug('Route Token: ' + route.routeToken);
                System.debug(route);
            }
        }
    }

    /**
     * This is a raw unformatted HTTP response that uses coordinates for the origin and destination
     */
    public static void rawResponseExample() {
        // Format an origin and destination
        TSSGoogleMaps.GoogleMapsLocation origin = new TSSGoogleMaps.GoogleMapsLocation(34.180790, -118.394740);
        TSSGoogleMaps.GoogleMapsLocation destination = new TSSGoogleMaps.GoogleMapsLocation(34.101090, -118.340060);

        // Make a simple request to retrieve a RouteResponse
        HttpResponse httpResponse = TSSGoogleMapsRoute.getRouteHttpResponse(origin, destination);

        // Examine the HTTP response from Google
        System.debug(httpResponse.getStatusCode());
        System.debug(httpResponse.getStatus());
        System.debug(httpResponse.getBody());
    }

}