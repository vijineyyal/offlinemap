import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:offlinemap/offline_region.dart';

class OfflineRegionMap extends StatefulWidget {
  OfflineRegionMap(this.item);

  final OfflineRegionListItem item;

  @override
  _OfflineRegionMapState createState() => _OfflineRegionMapState();
}

class _OfflineRegionMapState extends State<OfflineRegionMap> {
  MapboxMapController? _controller;
  bool showMap = false;

  void _onMapCreated(MapboxMapController controller) {
    _controller = controller;
  }

  TextEditingController _textEditingController = TextEditingController();
  int currentIndex = 0;

  List<LatLng> coordinatesList = [
    LatLng(10.651304586691268, 76.1190232084511),
    LatLng(10.651445155644453, 76.11929052484606),
    LatLng(10.651345846503872, 76.11934938908064),
    LatLng(10.65160231488079, 76.11986052695289),
    LatLng(10.65074167375495, 76.120246981928),
    LatLng(10.650546398823309, 76.12031536498387),
    LatLng(10.65045510132343, 76.12008699127045),
    LatLng(10.650558069631913, 76.1200621556273),
    LatLng(10.650651986939408, 76.12005680942542),
    LatLng(10.650650673407242, 76.11993785611338),
    LatLng(10.650542475490056, 76.1196931496857),
    LatLng(10.650607730231968, 76.11962398866723),
    LatLng(10.650613606670063, 76.11953515097912),
    LatLng(10.650613606670063, 76.11953173461279),
    LatLng(10.65077436963378, 76.11948261763143),
    LatLng(10.650706349871967, 76.11932702883757),
    LatLng(10.651304754267017, 76.11904325654126),
  ];
  List<LatLng> lineArray = [];

  @override
  void initState() {
    super.initState();
    _textEditingController.text = coordinatesList[0].latitude.toString() +
        ", " +
        coordinatesList[0].longitude.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Region: ${widget.item.name}'),
      ),
      body: MapboxMap(
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: widget.item.offlineRegionDefinition.minZoom,
        ),
        minMaxZoomPreference: MinMaxZoomPreference(
          widget.item.offlineRegionDefinition.minZoom,
          widget.item.offlineRegionDefinition.maxZoom,
        ),
        styleString: widget.item.offlineRegionDefinition.mapStyleUrl,
        cameraTargetBounds: CameraTargetBounds(
          widget.item.offlineRegionDefinition.bounds,
        ),
        onMapCreated: _onMapCreated,
        onMapClick: (point, coordinates) {
          print(coordinates.latitude);
          print(coordinates.longitude);
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black))),
            controller: _textEditingController,
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
              onTap: () {
                if (currentIndex < coordinatesList.length) {
                  lineArray.add(coordinatesList[currentIndex]);
                  currentIndex++;

                  _controller?.addLine(
                    LineOptions(
                      geometry: lineArray,
                      lineColor: '#0000FF', // Blue color
                      lineWidth: 3.0,
                    ),
                  );
                  if (currentIndex < coordinatesList.length) {
                    _textEditingController.text =
                        coordinatesList[currentIndex].latitude.toString() +
                            ", " +
                            coordinatesList[currentIndex].longitude.toString();
                  } else {
                    _textEditingController.clear();
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.orange,
                child: Text("Add Geo Tag"),
              ))
        ]),
      ),
    );
  }

  LatLng get _center {
    final bounds = widget.item.offlineRegionDefinition.bounds;
    final lat = (bounds.southwest.latitude + bounds.northeast.latitude) / 2;
    final lng = (bounds.southwest.longitude + bounds.northeast.longitude) / 2;
    return LatLng(lat, lng);
  }
}
