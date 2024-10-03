@IsTest
global class TSSGoogleMapsRouteMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest request) {
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setHeader('Content-Type', 'application/json');
        httpResponse.setBody(getMockResponse());
        httpResponse.setStatus('OK');
        httpResponse.setStatusCode(200);

        return httpResponse;
    }

    public static String getMockResponse() {
        return '{"routes":[{"distanceMeters":11343,"duration":"770s","polyline":{"encodedPolyline":"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"}}]}';
    }

}