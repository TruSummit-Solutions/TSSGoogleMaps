@IsTest
global class TSSGoogleMapsDistanceMatrixMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest request) {
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setHeader('Content-Type', 'application/json');
        httpResponse.setBody(getMockResponse());
        httpResponse.setStatus('OK');
        httpResponse.setStatusCode(200);

        return httpResponse;
    }

    public static String getMockResponse() {
        return '{   "destination_addresses":[      "6233 Hollywood Blvd, Los Angeles, CA 90028, USA",      "6840 Hollywood Blvd, Los Angeles, CA 90028, USA"   ],   "origin_addresses":[      "12827 Victory Blvd, Valley Glen, CA 91606, USA",      "6150 Laurel Canyon Blvd, North Hollywood, CA 91606, USA"   ],   "rows":[      {         "elements":[            {               "distance":{                  "text":"13.7 km",                  "value":13731               },               "duration":{                  "text":"16 mins",                  "value":930               },               "status":"OK"            },            {               "distance":{                  "text":"13.0 km",                  "value":13047               },               "duration":{                  "text":"14 mins",                  "value":865               },               "status":"OK"            }         ]      },      {         "elements":[            {               "distance":{                  "text":"12.1 km",                  "value":12086               },               "duration":{                  "text":"14 mins",                  "value":840               },               "status":"OK"            },            {               "distance":{                  "text":"11.4 km",                  "value":11402               },               "duration":{                  "text":"13 mins",                  "value":775               },               "status":"OK"            }         ]      }   ],   "status":"OK"}';
    }
}