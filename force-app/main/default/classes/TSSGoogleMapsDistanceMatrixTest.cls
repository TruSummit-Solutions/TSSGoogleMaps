@IsTest
public with sharing class TSSGoogleMapsDistanceMatrixTest {

    @IsTest
    static void testGetDistanceMatrixAddresses() {
        Test.setMock(HttpCalloutMock.class, new TSSGoogleMapsDistanceMatrixMock());

        Test.startTest();
        TSSGoogleMaps.DistanceMatrix distanceMatrix = TSSGoogleMapsDistanceMatrix.getDistanceMatrix(getOriginAddresses(), getDestinationAddresses());
        Test.stopTest();

        System.assertEquals(2, distanceMatrix.rows.size());
    }

    @IsTest
    static void testGetDistanceMatrixAddress() {
        Test.setMock(HttpCalloutMock.class, new TSSGoogleMapsDistanceMatrixMock());

        Test.startTest();
        TSSGoogleMaps.DistanceMatrix distanceMatrix = TSSGoogleMapsDistanceMatrix.getDistanceMatrix(getOriginAddress(), getDestinationAddress());
        Test.stopTest();

        System.assertEquals(2, distanceMatrix.rows.size());
    }

    @IsTest
    static void testGetDistanceMatrixLocations() {
        Test.setMock(HttpCalloutMock.class, new TSSGoogleMapsDistanceMatrixMock());

        Test.startTest();
        TSSGoogleMaps.DistanceMatrix distanceMatrix = TSSGoogleMapsDistanceMatrix.getDistanceMatrix(getOrigins(), getDestinations());
        Test.stopTest();

        System.assertEquals(2, distanceMatrix.rows.size());
    }

    @IsTest
    static void testGetDistanceMatrixLocation() {
        Test.setMock(HttpCalloutMock.class, new TSSGoogleMapsDistanceMatrixMock());

        Test.startTest();
        TSSGoogleMaps.DistanceMatrix distanceMatrix = TSSGoogleMapsDistanceMatrix.getDistanceMatrix(getOrigin(), getDestination());
        Test.stopTest();

        System.assertEquals(2, distanceMatrix.rows.size());
    }

    @IsTest
    static void testGetDistanceMatrixAddressExtras() {
        Test.setMock(HttpCalloutMock.class, new TSSGoogleMapsDistanceMatrixMock());
        Long rightNow = Datetime.now().getTime() / 1000;

        Test.startTest();
        TSSGoogleMaps.DistanceMatrix distanceMatrix1 = TSSGoogleMapsDistanceMatrix.getDistanceMatrix(getOriginAddresses(), getDestinationAddresses(), rightNow, 'driving');
        Test.stopTest();

        System.assertEquals(2, distanceMatrix1.rows.size());
    }

    @IsTest
    static void testGetDistanceMatrixLocationExtras() {
        Test.setMock(HttpCalloutMock.class, new TSSGoogleMapsDistanceMatrixMock());
        Long rightNow = Datetime.now().getTime() / 1000;

        Test.startTest();
        TSSGoogleMaps.DistanceMatrix distanceMatrix1 = TSSGoogleMapsDistanceMatrix.getDistanceMatrix(getOrigins(), getDestinations(), rightNow, 'driving');
        TSSGoogleMaps.DistanceMatrix distanceMatrix2 = TSSGoogleMapsDistanceMatrix.getDistanceMatrix(getOrigins(), getDestinations(), rightNow);
        TSSGoogleMaps.DistanceMatrix distanceMatrix3 = TSSGoogleMapsDistanceMatrix.getDistanceMatrix(getOrigin(), getDestination(), rightNow, 'driving');
        TSSGoogleMaps.DistanceMatrix distanceMatrix4 = TSSGoogleMapsDistanceMatrix.getDistanceMatrix(getOrigin(), getDestination(), rightNow);
        Test.stopTest();

        System.assertEquals(2, distanceMatrix1.rows.size());
        System.assertEquals(2, distanceMatrix2.rows.size());
        System.assertEquals(2, distanceMatrix3.rows.size());
        System.assertEquals(2, distanceMatrix4.rows.size());
    }

    private static TSSGoogleMaps.GoogleMapsLocation getOrigin() {
        return new TSSGoogleMaps.GoogleMapsLocation(34.187050, -118.412750);
    }

    private static List<TSSGoogleMaps.GoogleMapsLocation> getOrigins() {
        TSSGoogleMaps.GoogleMapsLocation location1 = new TSSGoogleMaps.GoogleMapsLocation(34.187050, -118.412750);
        TSSGoogleMaps.GoogleMapsLocation location2 = new TSSGoogleMaps.GoogleMapsLocation(34.180790, -118.394740);
        return new List<TSSGoogleMaps.GoogleMapsLocation>{location1, location2};
    }

    private static TSSGoogleMaps.GoogleMapsAddress getOriginAddress() {
        return new TSSGoogleMaps.GoogleMapsAddress('12827 Victory Blvd.', 'North Hollywood', 'CA', 'USA');
    }

    private static List<TSSGoogleMaps.GoogleMapsAddress> getOriginAddresses() {
        TSSGoogleMaps.GoogleMapsAddress address1 = new TSSGoogleMaps.GoogleMapsAddress('12827 Victory Blvd.', 'North Hollywood', 'CA', 'USA');
        TSSGoogleMaps.GoogleMapsAddress address2 = new TSSGoogleMaps.GoogleMapsAddress('6150 Laurel Canyon Blvd.', 'North Hollywood', 'CA', 'USA');
        return new List<TSSGoogleMaps.GoogleMapsAddress>{address1, address2};
    }

    private static TSSGoogleMaps.GoogleMapsLocation getDestination() {
        return new TSSGoogleMaps.GoogleMapsLocation(34.102240, -118.325780);
    }

    private static List<TSSGoogleMaps.GoogleMapsLocation> getDestinations() {
        TSSGoogleMaps.GoogleMapsLocation location1 = new TSSGoogleMaps.GoogleMapsLocation(34.102240, -118.325780);
        TSSGoogleMaps.GoogleMapsLocation location2 = new TSSGoogleMaps.GoogleMapsLocation(34.101090, -118.340060);
        return new List<TSSGoogleMaps.GoogleMapsLocation>{location1, location2};
    }

    private static TSSGoogleMaps.GoogleMapsAddress getDestinationAddress() {
        return new TSSGoogleMaps.GoogleMapsAddress('6233 Hollywood Blvd.', 'Los Angeles', 'CA', 'USA');
    }

    private static List<TSSGoogleMaps.GoogleMapsAddress> getDestinationAddresses() {
        TSSGoogleMaps.GoogleMapsAddress address1 = new TSSGoogleMaps.GoogleMapsAddress('6233 Hollywood Blvd.', 'Los Angeles', 'CA', 'USA');
        TSSGoogleMaps.GoogleMapsAddress address2 = new TSSGoogleMaps.GoogleMapsAddress('6840 Hollywood Blvd.', 'Los Angeles', 'CA', 'USA');
        return new List<TSSGoogleMaps.GoogleMapsAddress>{address1, address2};
    }

}