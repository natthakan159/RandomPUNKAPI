import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'beer.dart' ;

void main() => runApp(HelloWorld());

class HelloWorld extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(title: 'Random PUNK API')
    );
  }
}

class FirstPage extends StatelessWidget {
  final String title;

  FirstPage({
    Key key,
    this.title
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Beer>>(
        future: getBeer(),
        builder: (context, result) {
          if  (result.hasError) print(result.error);
          return result.hasData
              ? BeerList(beers : result.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class BeerList extends StatelessWidget {
  final List<Beer> beers;

  BeerList({Key key, this.beers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: beers.length,
      itemBuilder: (context, index) {
        return Center(
          child: Image.network(beers[index].imageUrl),
        );
      },
    );
  }
}

Future<List<Beer>> getBeer() async {
  String url = 'https://api.punkapi.com/v2/beers/random';
  http.Response response = await http.get(url);

  // convert json to dart object
  List<Beer> randomBeer = new List();
  List<dynamic> beer = json.decode(response.body);
  for (var beerJson in beer) {
    var beers = Beer.fromJson(beerJson);
    randomBeer.add(beers);
  }
  return randomBeer;
}
