public with sharing class DistanceExample {

    public static void example() {
        // Place your origin addresses and your destination addresses into lists:
        List<TSSGoogleMaps.GoogleMapsAddress> originAddrs = getTestOriginAddresses();
        List<TSSGoogleMaps.GoogleMapsAddress> destinationAddrs = getTestDestinationAddresses();

        // Here is where the magic happens. Request your distance matrix from the Google Maps API:
        TSSGoogleMaps.DistanceMatrix distanceMatrix = TSSGoogleMapsDistanceMatrix.getDistanceMatrix(originAddrs, destinationAddrs);

        // Now you can access the distance and duration between your origin and destination addresses:
        for (TSSGoogleMaps.MatrixRow matrixRow : distanceMatrix.rows) {
            for (TSSGoogleMaps.MatrixElement matrixElement : matrixRow.elements) {
                System.debug(matrixElement.origin + ' to ' + matrixElement.destination + ' is ' + matrixElement.distanceText + ' away and will take ' + matrixElement.durationText + ' ...');
            }
        }
    }

    // Initialize your address origins - i.e. where you are starting from:
    public static List<TSSGoogleMaps.GoogleMapsAddress> getTestOriginAddresses() {
        TSSGoogleMaps.GoogleMapsAddress originAddr1 = new TSSGoogleMaps.GoogleMapsAddress('12827 Victory Blvd.', 'North Hollywood', 'CA', 'USA');
        TSSGoogleMaps.GoogleMapsAddress originAddr2 = new TSSGoogleMaps.GoogleMapsAddress('6150 Laurel Canyon Blvd.', 'North Hollywood', 'CA', 'USA');

        return new List<TSSGoogleMaps.GoogleMapsAddress>{originAddr1, originAddr2};
    }

    // Initialize your address destinations - i.e. where you are going:
    public static List<TSSGoogleMaps.GoogleMapsAddress> getTestDestinationAddresses() {
        TSSGoogleMaps.GoogleMapsAddress destinationAddr1 = new TSSGoogleMaps.GoogleMapsAddress('6233 Hollywood Blvd.', 'Los Angeles', 'CA', 'USA');
        TSSGoogleMaps.GoogleMapsAddress destinationAddr2 = new TSSGoogleMaps.GoogleMapsAddress('6840 Hollywood Blvd.', 'Los Angeles', 'CA', 'USA');

        return new List<TSSGoogleMaps.GoogleMapsAddress>{destinationAddr1, destinationAddr2};
    }

}