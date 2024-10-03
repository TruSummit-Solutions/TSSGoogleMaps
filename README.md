# TSSGoogleMaps

This project is an open source collection of Apex classes that make it easy to interact with the Google Maps API from Salesforce. The classes are designed to be easy to use and easy to extend, so you can quickly build custom mapping solutions in your Salesforce org. This project will continue to grow as we add more components.

## TSSGoogleMapsDistanceMatrix

This class allows you to make a Distance Matrix request to the Google Maps API. This is a traditional Distance Matrix request and NOT a Route API Distance Matrix.

You will need a Google Maps API key to use this class.

### Usage

For usage examples, see the DistanceExample Apex class in this project.

## TSSGoogleMapsRoute

The Google Maps Route API is a very powerful tool with a variety of options for requesting routes between two or more locations. This class is LIMITED to making a simple Route request between a single origin and a single destination. There is no Route API implementation for a Route Matrix at this time.

You will need a Google Maps API key to use this class.

### Usage

For usage examples, see the RouteExample Apex class in this project. NOTE: the examples demonstrate how to retrieve either a formatted response or the HttpResponse instance from the request.