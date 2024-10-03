public with sharing class TSSGoogleMaps {

    public class GoogleMapsLocation {
        public Decimal lat;
        public Decimal lng;

        public GoogleMapsLocation(Decimal lat, Decimal lng) {
            this.lat = lat;
            this.lng = lng;
        }
    }

    public class GoogleMapsAddress {
        public String street;
        public String city;
        public String state;
        public String country;

        public GoogleMapsAddress(String street, String city, String state, String country) {
            this.street = street;
            this.city = city;
            this.state = state;
            this.country = country;
        }

        public String getFormattedAddress() {
            String formattedAddress = '';

            if (String.isNotBlank(this.street)) {
                formattedAddress += this.street;
            }

            if (String.isNotBlank(this.city)) {
                if (String.isNotBlank(formattedAddress)) {
                    formattedAddress += ', ';
                }

                formattedAddress += this.city;
            }

            if (String.isNotBlank(this.state)) {
                if (String.isNotBlank(formattedAddress)) {
                    formattedAddress += ', ';
                }

                formattedAddress += this.state;
            }

            if (String.isNotBlank(this.country)) {
                if (String.isNotBlank(formattedAddress)) {
                    formattedAddress += ', ';
                }

                formattedAddress += this.country;
            }

            return formattedAddress;
        }
    }

    public class DistanceMatrix {
        public String status;
        public List<String> destinations;
        public List<String> origins;
        public List<MatrixRow> rows;
    }

    public class MatrixRow {
        public List<MatrixElement> elements;
    }

    public class MatrixElement {
        public String status;
        public String origin;
        public String destination;
        private MatrixDistance distance;
        private MatrixDuration duration;
        public String distanceText;
        public Decimal distanceInMeters;
        public Decimal distanceInMiles;
        public Decimal distanceInKilometers;
        public String durationText;
        public Decimal durationInSeconds;
        public Decimal durationInMinutes;
        public Decimal durationInHours;

        public void setDistance(MatrixDistance matrixDistance) {
            this.distance = matrixDistance;
            this.distanceInMeters = matrixDistance.value;
            this.distanceText = matrixDistance.text;
            this.distanceInMiles = matrixDistance.getDistanceInMiles();
            this.distanceInKilometers = matrixDistance.getDistanceInKilometers();
        }

        public void setDuration(MatrixDuration matrixDuration) {
            this.duration = matrixDuration;
            this.durationInSeconds = matrixDuration.value;
            this.durationText = matrixDuration.text;
            this.durationInMinutes = matrixDuration.getDurationInMinutes();
            this.durationInHours = matrixDuration.getDurationInHours();
        }

        public String debugString() {
            return 'status=' + this.status + ', origin=' + this.origin + ', destination=' + this.destination + ', distanceInMeters=' + this.distanceInMeters + ', durationInSeconds=' + this.durationInSeconds;
        }
    }

    public class MatrixDistance {
        public String text;
        public Decimal value;

        public MatrixDistance(String text, Decimal value) {
            this.text = text;
            this.value = value;
        }

        public Decimal getDistanceInMiles() {
            return this.value * 0.000621371;
        }

        public Decimal getDistanceInKilometers() {
            return this.value / 1000;
        }
    }

    public class MatrixDuration {
        public String text;
        public Decimal value;

        public MatrixDuration(String text, Decimal value) {
            this.text = text;
            this.value = value;
        }

        public Decimal getDurationInMinutes() {
            return this.value / 60;
        }

        public Decimal getDurationInHours() {
            return this.value / 3600;
        }
    }

    public enum RoutingPreference {
        TRAFFIC_AWARE, TRAFFIC_AWARE_OPTIONAL
    }

    public class RouteResponse {
        public String status;
        private List<GoogleRoute> routes;

        public List<GoogleRoute> getRoutes() {
            for (GoogleRoute route : this.routes) {
                route.distanceInKilometers = route.distanceMeters / 1000;
                route.distanceInMiles = route.distanceMeters * 0.000621371;
                route.durationInSeconds = Decimal.valueOf(route.duration.replaceAll('[^0-9]', ''));
                route.durationInMinutes = route.durationInSeconds / 60;
                route.durationInHours = route.durationInSeconds / 3600;
            }

            return this.routes;
        }
    }

    public class GoogleRoute {
        public Integer distanceMeters;
        public Decimal distanceInKilometers;
        public Decimal distanceInMiles;
        public String duration;
        public Decimal durationInSeconds;
        public Decimal durationInMinutes;
        public Decimal durationInHours;
        public RoutePolyline polyline;
    }

    public class RoutePolyline {
        public String encodedPolyline;
    }

    public class GoogleMapsException extends Exception {}

}