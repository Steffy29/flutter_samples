import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'galaxy.dart';
import 'galaxy_route.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Galaxy',
      theme: ThemeData(
        brightness: Brightness.dark, // Default style for widgets
        primaryColor: Colors.blueGrey[900], // AppBar
        dividerColor: Colors.blueGrey[600], // Divider
        scaffoldBackgroundColor: Colors.black, // Background
        splashColor: Colors.blueGrey[200], // InkWell
        accentColor: Colors.pink, // spinner
      ),
      home: new Galaxies(),
    );
  }
}

class GalaxiesState extends State<Galaxies> {
  List<Galaxy> _galaxies = [];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Galaxy'),
      ),
      body: _buildGalaxies(),
    );
  }

  Widget _buildGalaxies() {
    if (_galaxies.isEmpty) {
      return new Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(child: CircularProgressIndicator()));
    }

    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _galaxies.length * 2,
        itemBuilder: (BuildContext _context, int i) {
          // Add a one-pixel-high divider on odd row
          if (i.isOdd) return new Divider();
          // Else build a galaxy row
          final int index = i ~/ 2;
          return _buildRow(_galaxies[index]);
        });
  }

  Widget _buildRow(Galaxy galaxy) {
    return new InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () => _navigateToGalaxy(context, galaxy),
      child: new ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(galaxy.previewHref),
            ),
          ),
        ),
        title: new Text(
          galaxy.title,
          style: _biggerFont,
        ),
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if (_galaxies.isEmpty) {
      await _retrieveLocalGalaxies();
    }
  }

  /// Retrieves a list of [galaxy]
  Future<void> _retrieveLocalGalaxies() async {
    final response = await http
        .get('https://images-api.nasa.gov/search?q=galaxy&media_type=image');
    var json;
    if (response.statusCode == 200) {
      json = response.body;
    } else {
      json = DefaultAssetBundle.of(context)
          .loadString('assets/data/galaxies.json');
    }
    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }

    var collection = data['collection'];
    if (collection is! Map) {
      throw ('Collection is not a Map');
    }

    var items = collection['items'];
    List<Galaxy> galaxies = [];

    for (var jsonMap in items) {
      var links = jsonMap['links'][0];
      var previewHref = links['href'];
      var data = jsonMap['data'][0];
      var title = data['title'];
      var id = data['nasa_id'];
      var description = data['description'];
      var galaxy = new Galaxy(
          id: id,
          title: title,
          previewHref: previewHref,
          description: description);
      galaxies.add(galaxy);
    }
    setState(() {
      _galaxies.clear();
      _galaxies.addAll(galaxies);
    });
  }

  /// Navigates to the [GalaxyRoute].
  void _navigateToGalaxy(BuildContext context, Galaxy galaxy) {
    print("Navigate...");
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: Text(galaxy.title),
            centerTitle: true,
          ),
          body: GalaxyRoute(galaxy: galaxy),
        );
      },
    ));
  }
}

class Galaxies extends StatefulWidget {
  @override
  GalaxiesState createState() => new GalaxiesState();
}
