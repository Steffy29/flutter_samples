import 'package:flutter/material.dart';
import 'package:zoomable_image/zoomable_image.dart';
import 'galaxy.dart';

class GalaxyZoom extends StatelessWidget {
 final Galaxy galaxy;

 const GalaxyZoom({
   @required this.galaxy,
 }) : assert(galaxy != null);

 @override
 Widget build(BuildContext context) {
   String urlImage = galaxy.previewHref.replaceAll("thumb", "orig");
   return new ZoomableImage(NetworkImage(urlImage));
 }
}