public with sharing class TSSGoogleMapsAPIConnect {

    private static Map<String, String> GOOGLE_MAPS_DETAILS;

    public static void getGoogleMapsDetails() {
        List<TSS_Google_Map_Setting__mdt> googleMapsDetails = [SELECT Id, DeveloperName, Google_Maps_API_Root__c, API_Key__c
            FROM TSS_Google_Map_Setting__mdt WHERE DeveloperName = 'Google_Maps'];

        if (googleMapsDetails.isEmpty()) {
            throw new TSSGoogleMaps.GoogleMapsException('Google Maps custom metadata type with developername Google_Maps not found!');
        }

        TSS_Google_Map_Setting__mdt googleMapsDetail = googleMapsDetails.get(0);

        GOOGLE_MAPS_DETAILS = new Map<String, String> {
            'rootUrl' => googleMapsDetail.Google_Maps_API_Root__c,
            'apiKey' => googleMapsDetail.API_Key__c
        };
    }

    private static void initSettings() {
        if (GOOGLE_MAPS_DETAILS == null) {
            getGoogleMapsDetails();
        }
    }

    /**
     * This method should be implemented to adhere to your security requirements. In this example,
     * the key is being returned as a result of querying a Custom Metadata Type.
     *
     * @return A String representing the Google Maps API key
     */
    public static String getKey() {
        initSettings();
        return GOOGLE_MAPS_DETAILS.get('apiKey');
    }

    public static String getRootUrl() {
        initSettings();
        return GOOGLE_MAPS_DETAILS.get('rootUrl');
    }

    public static String getEndpoint(String endpoint) {
        return getRootUrl() + endpoint;
    }

}