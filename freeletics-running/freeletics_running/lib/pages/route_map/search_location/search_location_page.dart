import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freeletics_running/helper/constant.dart';
import 'package:freeletics_running/models/distance_matrix.dart';
import 'package:freeletics_running/models/map_location.dart';

import 'package:freeletics_running/models/suggestion.dart';
import 'package:freeletics_running/pages/route_map/search_location/item_location.dart';
import 'package:freeletics_running/pages/route_map/search_location/search_location_provider.dart';
import 'package:freeletics_running/services/cache/cache_preferences.dart';
import 'package:freeletics_running/widgets/appbar_empty.dart';
import 'package:geolocator/geolocator.dart';


import 'package:provider/provider.dart';

class SearchLocationPage extends StatefulWidget {
  SearchLocationPage(
      {this.currentLocation, this.startPoint = true, this.searchLocation});

  final Position currentLocation;
  final bool startPoint;
  final MapLocation searchLocation;

  @override
  _SearchLocationPageState createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  Timer _timer;
  TextEditingController _controller = TextEditingController();

  List<Suggestion> results = [];
  List<DistanceMatrix> distances = [];
  bool isSearching = false;
  List<Suggestion> recentAddress = [];
  final FocusNode _focusSearch = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.searchLocation != null) {
        _controller.text = widget.searchLocation.formattedAddress;
        isSearching = true;
        onChangedSearch(widget.searchLocation.formattedAddress);
      } else {
        getRecentAddress();
        _focusSearch?.requestFocus();
      }
    });
  }

  getRecentAddress() async {
    List<dynamic> addressCaches = await context
        .read<CachePreferences>()
        .getData(Constant.KEY_LIST_SEARCH_ADDRESS);
    List<Suggestion> results = [];
    if (addressCaches != null && addressCaches.length > 0) {
      for (int i = 0; i < addressCaches.length; i++) {
        String e = addressCaches[i].toString();
        results.add(Suggestion.fromJson(json.decode(e)));
      }
    }
    setState(() {
      recentAddress = results;
    });

    print("recentAddress " + recentAddress.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    _focusSearch?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  onPressBack() {
    Navigator.of(context).pop();
  }

  void onChangedSearch(String search) {
    setState(() {
      isSearching = search.isNotEmpty;
    });
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 400), () async {
      // search autocomplete place near current location
      String currentLocation = '';
      if (widget.currentLocation != null) {
        currentLocation = widget.currentLocation.latitude.toString() +
            ',' +
            widget.currentLocation.longitude.toString();
        List<Suggestion> suggestions = await context
            .read<SearchLocationProvider>()
            .fetchSuggestions(
                input: search,
                lang: Localizations.localeOf(context).languageCode,
                location: currentLocation,
                radius: '1000');

        // get distance from current location to every address
        await calculatorDistance(widget.currentLocation, suggestions);

        setState(() {
          results = suggestions;
          // print("results " + results.toString());
        });
      }
    });
  }

  Future<void> calculatorDistance(
      Position from, List<Suggestion> suggestions) async {
    String currentLocation = '';
    if (from != null && suggestions.length > 0) {
      currentLocation =
          from.latitude.toString() + ',' + from.longitude.toString();
      if (suggestions.length > 0) {
        String destinations = '';
        for (int i = 0; i < suggestions.length - 1; i++) {
          destinations =
              destinations + "place_id:" + suggestions[i].placeId + "|";
        }
        destinations = destinations +
            "place_id:" +
            suggestions[suggestions.length - 1].placeId;
        distances = await context
            .read<SearchLocationProvider>()
            .calculatorDistance(currentLocation, destinations);
      }
    }
  }

  void onClearSearch() {
    _controller?.clear();
    setState(() {
      results = [];
      distances = [];
      isSearching = false;
    });
  }

  onPressItemAddress(Suggestion item, bool save) async {
    if (item != null) {
      if (save == true) saveNewAddress(item);
      Navigator.of(context).pop(item.placeId);
    }
  }

  void saveNewAddress(Suggestion address) {
    int index = recentAddress.indexWhere((element) => element == address);
    if (index == -1) {
      recentAddress.add(address);
    } else {
      recentAddress[index] = address;
    }

    if (recentAddress.length > 4)
      recentAddress = recentAddress.getRange(
          recentAddress.length - 1 - 4, recentAddress.length - 1);

    List<String> results = [];
    for (int i = 0; i < recentAddress.length; i++) {
      results.add(json.encode(recentAddress[i]));
    }

    print("saveNewAddress results " + results.toString());

    context
        .read<CachePreferences>()
        .saveData<List<String>>(Constant.KEY_LIST_SEARCH_ADDRESS, results);
  }

  @override
  Widget build(BuildContext context) {
    return AppBarEmpty(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // search
            SizedBox(
              height: 20,
            ),
            _buildTextSearch(),

            SizedBox(
              height: 20,
            ),

            Expanded(
                child: isSearching == true
                    ? _buildListResults()
                    : _buildHistoryRecent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSearch() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white),
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: 20,
              color: Colors.black,
              onPressed: onPressBack),
          Expanded(
              child: TextField(
            style: TextStyle(fontSize: 16, color: Colors.black),
            controller: _controller,
            onChanged: onChangedSearch,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Search location",
            ),
          )),
          if (isSearching == true)
            IconButton(
                icon: Icon(Icons.cancel_outlined),
                iconSize: 20,
                color: Colors.black,
                onPressed: onClearSearch),
        ],
      ),
    );
  }

  void onPressCurrentLocation() {
    Navigator.of(context).pop(widget.currentLocation);
  }

  Widget _buildHistoryRecent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: onPressCurrentLocation,
          child: Row(
            children: [
              Container(
                  width: 50,
                  child: Icon(
                    Icons.location_on,
                    size: 25,
                    color: Colors.blue,
                  )),
              SizedBox(
                width: 20,
              ),
              Text(
                "Your location",
                style: TextStyle(fontSize: 14, color: Colors.black),
              )
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text("Recent"),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              Suggestion item = recentAddress[index];
              return ItemLocation(
                  address: item.description,
                  onPressItem: () {
                    onPressItemAddress(item, false);
                  });
            },
            itemCount: recentAddress.length,
          ),
        ),
      ],
    );
  }

  Widget _buildListResults() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        Suggestion item = results[index];
        return ItemLocation(
            address: item.description,
            distanceMatrix:
                distances.length - 1 >= index ? distances[index] : null,
            onPressItem: () {
              onPressItemAddress(item, true);
            });
      },
      itemCount: results.length,
    );
  }
}
