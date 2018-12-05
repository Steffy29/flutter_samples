import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'galaxy.dart';
import 'galaxy_zoom.dart';

class GalaxyRoute extends StatelessWidget {
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  final Galaxy galaxy;
  const GalaxyRoute({
    @required this.galaxy,
  }) : assert(galaxy != null);
  @override
  Widget build(BuildContext context) {
    String urlImage = galaxy.previewHref.replaceAll("thumb", "orig");

    return new ListView(
      children: <Widget>[
        new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Text(
              galaxy.description,
              style: _biggerFont,
            )),
        // Image.network(urlImage),
        new GestureDetector(
          onTap: () => _navigateToGalaxyZoom(context, galaxy),
          child: new Stack(
            children: <Widget>[
              new Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Center(child: CircularProgressIndicator())),
              Center(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: urlImage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Navigates to the [GalaxyZoom].
  void _navigateToGalaxyZoom(BuildContext context, Galaxy galaxy) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: Text(galaxy.title),
            centerTitle: true,
          ),
          body: GalaxyZoom(galaxy: galaxy),
        );
      },
    ));
  }
}
