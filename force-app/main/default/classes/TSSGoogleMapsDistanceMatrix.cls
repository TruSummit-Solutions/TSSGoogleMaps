/**
 * TSSGoogleMapsDistanceMatrix - Open Source Google Maps API Distance Matrix Wrapper for Salesforce
 * Author: TruSummit Solutions, LLC
 */
public with sharing class TSSGoogleMapsDistanceMatrix {

    private static final String DISTANCE_MATRIX_ENDPOINT = '/distancematrix/json';
    private static final String MODE = 'driving';
    public static String UNITS = 'imperial';

    private static String getDistanceMatrixEndpoint() {
        return TSSGoogleMapsAPIConnect.getEndpoint(DISTANCE_MATRIX_ENDPOINT);
    }

    /**
     * @param origin A single Origin location containing latitude and longitude
     * @param destination A single Destination location containing latitude and longitude
     *
     * @return A formatted DistanceMatrix object
     */
    public static TSSGoogleMaps.DistanceMatrix getDistanceMatrix(TSSGoogleMaps.GoogleMapsLocation origin, TSSGoogleMaps.GoogleMapsLocation destination) {
        return getDistanceMatrix(origin, destination, null, MODE);
    }

    /**
     * @param origin A single Origin location containing latitude and longitude
     * @param destination A single Destination location containing latitude and longitude
     * @param departureTime A Unix timestamp representing the desired departure time
     *
     * @return A formatted DistanceMatrix object
     */
    public static TSSGoogleMaps.DistanceMatrix getDistanceMatrix(TSSGoogleMaps.GoogleMapsLocation origin, TSSGoogleMaps.GoogleMapsLocation destination, Long departureTime) {
        return getDistanceMatrix(origin, destination, departureTime, MODE);
    }

    /**
     * @param origin A single Origin location containing latitude and longitude
     * @param destination A single Destination location containing latitude and longitude
     * @param departureTime A Unix timestamp representing the desired departure time
     * @param mode A string representing the mode of transportation
     *
     * @return A formatted DistanceMatrix object
     */
    public static TSSGoogleMaps.DistanceMatrix getDistanceMatrix(TSSGoogleMaps.GoogleMapsLocation origin, TSSGoogleMaps.GoogleMapsLocation destination, Long departureTime, String mode) {
        List<TSSGoogleMaps.GoogleMapsLocation> origins = new List<TSSGoogleMaps.GoogleMapsLocation>{origin};
        List<TSSGoogleMaps.GoogleMapsLocation> destinations = new List<TSSGoogleMaps.GoogleMapsLocation>{destination};

        String payload = formatPayload(origins, destinations, departureTime, mode);
        return requestDistanceMatrix(payload);
    }

    /**
     * @param origins A list of Origin locations containing latitude and longitude
     * @param destinations A list of Destination locations containing latitude and longitude
     *
     * @return A formatted DistanceMatrix object
     */
    public static TSSGoogleMaps.DistanceMatrix getDistanceMatrix(List<TSSGoogleMaps.GoogleMapsLocation> origins, List<TSSGoogleMaps.GoogleMapsLocation> destinations) {
        return getDistanceMatrix(origins, destinations, null, MODE);
    }

    /**
     * @param origins A list of Origin locations containing latitude and longitude
     * @param destinations A list of Destination locations containing latitude and longitude
     * @param departureTime A Unix timestamp representing the desired departure time
     *
     * @return A formatted DistanceMatrix object
     */
    public static TSSGoogleMaps.DistanceMatrix getDistanceMatrix(List<TSSGoogleMaps.GoogleMapsLocation> origins, List<TSSGoogleMaps.GoogleMapsLocation> destinations, Long departureTime) {
        return getDistanceMatrix(origins, destinations, departureTime, MODE);
    }

    /**
     * @param origins A list of Origin locations containing latitude and longitude
     * @param destinations A list of Destination locations containing latitude and longitude
     * @param departureTime A Unix timestamp representing the desired departure time
     * @param mode A string representing the mode of transportation
     *
     * @return A formatted DistanceMatrix object
     */
    public static TSSGoogleMaps.DistanceMatrix getDistanceMatrix(List<TSSGoogleMaps.GoogleMapsLocation> origins, List<TSSGoogleMaps.GoogleMapsLocation> destinations, Long departureTime, String mode) {
        String payload = formatPayload(origins, destinations, departureTime, mode);
        return requestDistanceMatrix(payload);
    }

    /**
     * @param originAddr A single Origin address
     * @param destinationAddr A single Destination address
     *
     * @return A formatted DistanceMatrix object
     */
    public static TSSGoogleMaps.DistanceMatrix getDistanceMatrix(TSSGoogleMaps.GoogleMapsAddress originAddr, TSSGoogleMaps.GoogleMapsAddress destinationAddr) {
        List<TSSGoogleMaps.GoogleMapsAddress> originAddrs = new List<TSSGoogleMaps.GoogleMapsAddress>{originAddr};
        List<TSSGoogleMaps.GoogleMapsAddress> destinationAddrs = new List<TSSGoogleMaps.GoogleMapsAddress>{destinationAddr};

        return getDistanceMatrix(originAddrs, destinationAddrs, null, MODE);
    }

    /**
     * @param originAddrs A list of Origin addresses
     * @param destinationAddrs A list of Destination addresses
     *
     * @return A formatted DistanceMatrix object
     */
    public static TSSGoogleMaps.DistanceMatrix getDistanceMatrix(List<TSSGoogleMaps.GoogleMapsAddress> originAddrs, List<TSSGoogleMaps.GoogleMapsAddress> destinationAddrs) {
        return getDistanceMatrix(originAddrs, destinationAddrs, null, MODE);
    }

    /**
     * @param originAddrs A list of Origin addresses
     * @param destinationAddrs A list of Destination addresses
     * @param departureTime A Unix timestamp representing the desired departure time
     * @param mode A string representing the mode of transportation
     *
     * @return A formatted DistanceMatrix object
     */
    public static TSSGoogleMaps.DistanceMatrix getDistanceMatrix(List<TSSGoogleMaps.GoogleMapsAddress> originAddrs, List<TSSGoogleMaps.GoogleMapsAddress> destinationAddrs, Long departureTime, String mode) {
        String payload = formatPayload(originAddrs, destinationAddrs, departureTime, mode);
        return requestDistanceMatrix(payload);
    }

    private static TSSGoogleMaps.DistanceMatrix requestDistanceMatrix(String payload) {
        String endpoint = getDistanceMatrixEndpoint() + '?' + payload + '&key=' + TSSGoogleMapsAPIConnect.getKey();

        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('GET');
        httpRequest.setEndpoint(endpoint);

        Http http = new Http();
        HttpResponse httpResponse = http.send(httpRequest);

        return parseDistanceMatrix(httpResponse);
    }

    private static TSSGoogleMaps.DistanceMatrix parseDistanceMatrix(HttpResponse httpResponse) {
        if (httpResponse.getStatusCode() != 200) {
            System.debug('Status: ' + httpResponse.getStatus());
            System.debug('Response: ' + httpResponse.getBody());
            throw new TSSGoogleMaps.GoogleMapsException(httpResponse.getStatusCode() + ': ' + httpResponse.getStatus());
        }

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());

        TSSGoogleMaps.DistanceMatrix distanceMatrix = new TSSGoogleMaps.DistanceMatrix();
        distanceMatrix.status = (String) responseMap.get('status');

        if (distanceMatrix.status == 'OK') {
            List<Object> destinationObjects = (List<Object>) responseMap.get('destination_addresses');
            List<Object> originObjects = (List<Object>) responseMap.get('origin_addresses');

            if (destinationObjects != null) {
                distanceMatrix.destinations = new List<String>();

                for (Object destination : destinationObjects) {
                    distanceMatrix.destinations.add((String) destination);
                }
            }

            if (originObjects != null) {
                distanceMatrix.origins = new List<String>();

                for (Object origin : originObjects) {
                    distanceMatrix.origins.add((String) origin);
                }
            }

            List<Object> rows = (List<Object>) responseMap.get('rows');

            if (rows != null && rows.size() > 0) {
                distanceMatrix.rows = new List<TSSGoogleMaps.MatrixRow>();

                Integer o = 0;

                for (Object row : rows) {
                    Map<String, Object> rowMap = (Map<String, Object>) row;
                    List<Object> elements = (List<Object>) rowMap.get('elements');

                    Integer d = 0;

                    List<TSSGoogleMaps.MatrixElement> allElements = new List<TSSGoogleMaps.MatrixElement>();

                    for (Object rawElement : elements) {
                        Map<String, Object> elementMap = (Map<String, Object>) rawElement;

                        TSSGoogleMaps.MatrixElement element = new TSSGoogleMaps.MatrixElement();
                        element.status = (String) elementMap.get('status');
                        element.destination = distanceMatrix.destinations.get(d);
                        element.origin = distanceMatrix.origins.get(o);

                        if (element.status == 'OK') {
                            Map<String, Object> distanceMap = (Map<String, Object>) elementMap.get('distance');
                            TSSGoogleMaps.MatrixDistance distance = new TSSGoogleMaps.MatrixDistance((String) distanceMap.get('text'), (Integer) distanceMap.get('value'));
                            element.setDistance(distance);

                            Map<String, Object> durationMap = (Map<String, Object>) elementMap.get('duration');
                            TSSGoogleMaps.MatrixDuration duration = new TSSGoogleMaps.MatrixDuration((String) durationMap.get('text'), (Integer) durationMap.get('value'));
                            element.setDuration(duration);
                        }

                        allElements.add(element);
                        d++;
                    }

                    o++;
                    TSSGoogleMaps.MatrixRow matrixRow = new TSSGoogleMaps.MatrixRow();
                    matrixRow.elements = allElements;
                    distanceMatrix.rows.add(matrixRow);
                }
            }
        }

        return distanceMatrix;
    }

    private static String formatPayload(List<TSSGoogleMaps.GoogleMapsAddress> originAddrs, List<TSSGoogleMaps.GoogleMapsAddress> destinationAddrs, Long departureTime, String mode) {
        String queryString = '';

        if (originAddrs != null) {
            if (String.isNotBlank(queryString)) {
                queryString += '&';
            }

            queryString += 'origins=' + EncodingUtil.urlEncode(formatAddresses(originAddrs), 'UTF-8');
        }

        if (destinationAddrs != null) {
            if (String.isNotBlank(queryString)) {
                queryString += '&';
            }

            queryString += 'destinations=' + EncodingUtil.urlEncode(formatAddresses(destinationAddrs), 'UTF-8');
        }

        return formatPayloadExtras(queryString, departureTime, mode);
    }

    private static String formatPayload(List<TSSGoogleMaps.GoogleMapsLocation> origins, List<TSSGoogleMaps.GoogleMapsLocation> destinations, Long departureTime, String mode) {
        String queryString = '';

        if (origins != null) {
            if (String.isNotBlank(queryString)) {
                queryString += '&';
            }

            queryString += 'origins=' + EncodingUtil.urlEncode(formatGeolocation(origins), 'UTF-8');
        }

        if (destinations != null) {
            if (String.isNotBlank(queryString)) {
                queryString += '&';
            }

            queryString += 'destinations=' + EncodingUtil.urlEncode(formatGeolocation(destinations), 'UTF-8');
        }

        return formatPayloadExtras(queryString, departureTime, mode);
    }

    private static String formatPayloadExtras(String queryString, Long departureTime, String mode) {
        if (departureTime != null) {
            if (String.isNotBlank(queryString)) {
                queryString += '&';
            }

            queryString += 'departure_time=' + departureTime;
        }

        if (mode != null) {
            if (String.isNotBlank(queryString)) {
                queryString += '&';
            }

            queryString += 'mode=' + EncodingUtil.urlEncode(mode, 'UTF-8');
        }

        queryString += '&units=' + UNITS;

        return queryString;
    }

    private static String formatGeolocation(TSSGoogleMaps.GoogleMapsLocation location) {
        return location.lat + ',' + location.lng;
    }

    private static String formatGeolocation(List<TSSGoogleMaps.GoogleMapsLocation> locations) {
        List<String> formattedLocations = new List<String>();

        for (TSSGoogleMaps.GoogleMapsLocation location : locations) {
            formattedLocations.add(formatGeolocation(location));
        }

        return String.join(formattedLocations, '|');
    }

    private static String formatAddress(TSSGoogleMaps.GoogleMapsAddress address) {
        return address.getFormattedAddress();
    }

    private static String formatAddresses(List<TSSGoogleMaps.GoogleMapsAddress> addresses) {
        List<String> formattedAddresses = new List<String>();

        for (TSSGoogleMaps.GoogleMapsAddress address : addresses) {
            formattedAddresses.add(formatAddress(address));
        }

        return String.join(formattedAddresses, '|');
    }

}