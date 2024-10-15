import { LightningElement, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';

export default class TruSummitMap extends LightningElement {
    @api apiKey;
    @api encodedPolyline;
    @api markers = [];

    @api mapHeight = '300px';
    @api mapWidth = '300px';

    @api centerLatitude;
    @api centerLongitude;
    @api centerZoom = 8;

    googleMapsApiUrl = 'https://maps.googleapis.com/maps/api/js';
    map;

    get mapStyle() {
        let style = '';

        if (this.mapHeight) {
            style += `height: ${this.mapHeight};`;
        }
        if (this.mapWidth) {
            style += `width: ${this.mapWidth};`;
        }

        return style;
    }

    renderedCallback() {
        if (this.map) {
            return;
        }

        loadScript(this, `${this.googleMapsApiUrl}?key=${this.apiKey}`).then(() => {
            this.initializeMap();
        });
    }

    initializeMap() {
        const mapElement = this.template.querySelector('.map');

        this.map = new google.maps.Map(mapElement, {
            zoom: this.centerZoom,
            center: { lat: this.centerLatitude, lng: this.centerLongitude }
        });

        if (this.encodedPolyline) {
            this.renderRoute();
        }
    }

    @api
    setEncodedPolyline(encodedPolyline) {
        this.encodedPolyline = encodedPolyline;
        this.renderRoute();
    }

    @api
    renderRoute() {
        if (!this.map || !this.encodedPolyline) return;
        const path = google.maps.geometry.encoding.decodePath(this.encodedPolyline);
        const polyline = new google.maps.Polyline({
            path: path,
            strokeColor: "#FF0000",
            strokeOpacity: 1.0,
            strokeWeight: 2
        });
        polyline.setMap(this.map);
        this.map.fitBounds(polyline.getBounds());
    }

    @api
    addMarker(lat, lng, title) {
        if (!this.map) return;

        const marker = new this.google.maps.Marker({
            position: { lat, lng },
            map: this.map,
            title: title
        });

        this.markers.push(marker);
        this.renderMarkers();
    }

    renderMarkers() {
        if (!this.map) return;

        this.markers.forEach(marker => marker.setMap(this.map));

        if (this.markers.length > 0) {
            const bounds = new this.google.maps.LatLngBounds();
            this.markers.forEach(marker => bounds.extend(marker.getPosition()));
            this.map.fitBounds(bounds);
        }
    }

    @api
    clearMarkers() {
        this.markers.forEach(marker => marker.setMap(null));
        this.markers = [];
    }
}