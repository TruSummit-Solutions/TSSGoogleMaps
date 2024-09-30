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

            if (this.street != null) {
                formattedAddress += this.street + ', ';
            }

            if (this.city != null) {
                if (String.isNotBlank(formattedAddress)) {
                    formattedAddress += ', ';
                }

                formattedAddress += this.city;
            }

            if (this.state != null) {
                if (String.isNotBlank(formattedAddress)) {
                    formattedAddress += ', ';
                }

                formattedAddress += this.state;
            }

            if (this.country != null) {
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

    public class GoogleMapsException extends Exception {}

}