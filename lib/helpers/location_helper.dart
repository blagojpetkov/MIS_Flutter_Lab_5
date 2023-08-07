const API_KEY = 'AIzaSyDHTQI0almf8rNaNNs1y8cZ9wE4RoJ_Jog';

class LocationHelper {
  static String generateLocationPreviewImage({double latitude, double longitude}){
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$latitude,$longitude&8&key=$API_KEY';
  }
}