

import 'package:abc_cooking/services/location_service.dart';
import 'package:abc_cooking/widgets/jumping_dots.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        body: FutureBuilder(
            future: LocationService.getLocation(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FlutterMap(
                  options: new MapOptions(
                    center: snapshot.data,
                    zoom: 13,
                  ),
                  layers: [
                    new TileLayerOptions(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']
                    ),
                    new MarkerLayerOptions(
                      markers: [

                      ],
                    ),
                  ],
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Gathering data...'),
                  SizedBox(height: 20,),
                  JumpingDots(color: Theme.of(context).accentColor, alignment: MainAxisAlignment.center,),
                ],
              );
            }
        ),
      ),
    );
  }

}