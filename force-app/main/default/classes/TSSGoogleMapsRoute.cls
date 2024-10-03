/**
 * TSSGoogleMapsRoute - Open Source Google Maps Route API Wrapper for Salesforce
 * Author: TruSummit Solutions, LLC
 */
public with sharing class TSSGoogleMapsRoute {

    private static final String ROUTE_ENDPOINT = '/directions/v2:computeRoutes';
    private static final String MODE = 'DRIVE';
    private static final String HEADER_GOOGLE_API_KEY = 'X-Goog-Api-Key';
    private static final String HEADER_GOOGLE_FIELDMASK = 'X-Goog-FieldMask';
    public static String UNITS = 'imperial';
    public static String REGION_CODE = 'US';
    public static String LANGUAGE_CODE = 'en-US';
    public static TSSGoogleMaps.RoutingPreference ROUTING_PREFERENCE = TSSGoogleMaps.RoutingPreference.TRAFFIC_UNAWARE;
    public static Boolean RETURN_DURATION = true;
    public static Boolean RETURN_DISTANCE = true;
    public static Boolean RETURN_POLYLINE = true;
    public static Boolean RETURN_ROUTE_TOKEN = false; // NOTE: This requires travelMode = DRIVE and a routingPreference of TRAFFIC_AWARE or TRAFFIC_AWARE_OPTIONAL

    private static String getRoutesEndpoint() {
        return TSSGoogleMapsAPIConnect.getRoutesEndpoint(ROUTE_ENDPOINT);
    }

    /**
     * @param origin A GoogleMapsLocation object (longitude and latitude) representing the origin
     * @param destination A GoogleMapsLocation object (longitude and latitude) representing the destination
     *
     * @return A formatted RouteResponse object
     */
    public static TSSGoogleMaps.RouteResponse getRoute(TSSGoogleMaps.GoogleMapsLocation origin, TSSGoogleMaps.GoogleMapsLocation destination) {
        String requestPayload = formatPayload(origin, destination);
        return requestRoute(requestPayload);
    }

    /**
     * @param originAddr A GoogleMapsAddress object (street address) representing the origin
     * @param destinationAddr A GoogleMapsAddress object (street address) representing the destination
     *
     * @return A formatted RouteResponse object
     */
    public static TSSGoogleMaps.RouteResponse getRoute(TSSGoogleMaps.GoogleMapsAddress originAddr, TSSGoogleMaps.GoogleMapsAddress destinationAddr) {
        String requestPayload = formatPayload(originAddr, destinationAddr);
        return requestRoute(requestPayload);
    }

    /**
     * @param origin A GoogleMapsLocation object (longitude and latitude) representing the origin
     * @param destination A GoogleMapsLocation object (longitude and latitude) representing the destination
     *
     * @return A standard HttpResponse instance
     */
    public static HttpResponse getRouteHttpResponse(TSSGoogleMaps.GoogleMapsLocation origin, TSSGoogleMaps.GoogleMapsLocation destination) {
        String requestPayload = formatPayload(origin, destination);
        return requestRouteHttpResponse(requestPayload);
    }

    /**
     * @param originAddr A GoogleMapsAddress object (street address) representing the origin
     * @param destinationAddr A GoogleMapsAddress object (street address) representing the destination
     *
     * @return A standard HttpResponse instance
     */
    public static HttpResponse getRouteHttpResponse(TSSGoogleMaps.GoogleMapsAddress originAddr, TSSGoogleMaps.GoogleMapsAddress destinationAddr) {
        String requestPayload = formatPayload(originAddr, destinationAddr);
        return requestRouteHttpResponse(requestPayload);
    }

    private static Map<String, Object> formatLocation(TSSGoogleMaps.GoogleMapsLocation location) {
        Map<String, Object> formattedLocation = new Map<String, Object>();

        Map<String, Object> coordinates = new Map<String, Object>{
                'longitude' => location.lng,
                'latitude' => location.lat
        };

        Map<String, Object> latLngMap = new Map<String, Object>{
                'latLng' => coordinates
        };

        formattedLocation.put('location', latLngMap);
        return formattedLocation;
    }

    private static Map<String, Object> formatAddress(TSSGoogleMaps.GoogleMapsAddress address) {
        Map<String, Object> formattedAddress = new Map<String, Object>{
                'address' => address.getFormattedAddress()
        };

        return formattedAddress;
    }

    private static String formatPayload(TSSGoogleMaps.GoogleMapsLocation origin, TSSGoogleMaps.GoogleMapsLocation destination) {
        Map<String, Object> originMap = formatLocation(origin);
        Map<String, Object> destinationMap = formatLocation(destination);

        return formatPayloadExtras(originMap, destinationMap);
    }

    private static String formatPayload(TSSGoogleMaps.GoogleMapsAddress originAddr, TSSGoogleMaps.GoogleMapsAddress destinationAddr) {
        Map<String, Object> originMap = formatAddress(originAddr);
        Map<String, Object> destinationMap = formatAddress(destinationAddr);

        return formatPayloadExtras(originMap, destinationMap);
    }

    private static String formatPayloadExtras(Map<String, Object> origin, Map<String, Object> destination) {
        Map<String, Object> payloadMap = new Map<String, Object>{
                'languageCode' => LANGUAGE_CODE,
                'routingPreference' => ROUTING_PREFERENCE.name(),
                'regionCode' => REGION_CODE,
                'units' => UNITS,
                'travelMode' => MODE,
                'destination' => destination,
                'origin' => origin
        };

        if (RETURN_ROUTE_TOKEN) {
            if (ROUTING_PREFERENCE == TSSGoogleMaps.RoutingPreference.TRAFFIC_AWARE || ROUTING_PREFERENCE == TSSGoogleMaps.RoutingPreference.TRAFFIC_AWARE_OPTIONAL) {
                payloadMap.put('travelMode', 'DRIVE'); // This mode is required for RETURN_ROUTE_TOKEN
            } else {
                throw new TSSGoogleMaps.GoogleMapsException('RETURN_ROUTE_TOKEN requires a routingPreference of TRAFFIC_AWARE or TRAFFIC_AWARE_OPTIONAL');
            }
        }

        return JSON.serialize(payloadMap);
    }

    private static TSSGoogleMaps.RouteResponse requestRoute(String payload) {
        return parseRouteResponse(requestRouteCallout(payload));
    }

    private static HttpResponse requestRouteHttpResponse(String payload) {
        return requestRouteCallout(payload);
    }

    private static HttpResponse requestRouteCallout(String payload) {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('POST');
        httpRequest.setEndpoint(getRoutesEndpoint());
        httpRequest.setBody(payload);

        setHeaders(httpRequest);

        Http http = new Http();
        HttpResponse httpResponse = http.send(httpRequest);

        return httpResponse;
    }

    private static TSSGoogleMaps.RouteResponse parseRouteResponse(HttpResponse httpResponse) {
        TSSGoogleMaps.RouteResponse response;
        if (httpResponse.getStatusCode() == 200) {
            response = (TSSGoogleMaps.RouteResponse) JSON.deserialize(httpResponse.getBody(), TSSGoogleMaps.RouteResponse.class);
        } else {
            response = new TSSGoogleMaps.RouteResponse();
        }

        response.status = httpResponse.getStatus();
        response.statusCode = httpResponse.getStatusCode();

        return response;
    }

    private static void setHeaders(HttpRequest httpRequest) {
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader(HEADER_GOOGLE_API_KEY, TSSGoogleMapsAPIConnect.getRoutesApiKey());

        String fieldMask = '';

        if (RETURN_DURATION) {
            fieldMask += 'routes.duration';
        }

        if (RETURN_DISTANCE) {
            if (String.isNotBlank(fieldMask)) {
                fieldMask += ',';
            }
            fieldMask += 'routes.distanceMeters';
        }

        if (RETURN_POLYLINE) {
            if (String.isNotBlank(fieldMask)) {
                fieldMask += ',';
            }
            fieldMask += 'routes.polyline.encodedPolyline';
        }

        if (RETURN_ROUTE_TOKEN) {
            if (String.isNotBlank(fieldMask)) {
                fieldMask += ',';
            }
            fieldMask += 'routes.routeToken';
        }

        httpRequest.setHeader(HEADER_GOOGLE_FIELDMASK, fieldMask);
    }

}