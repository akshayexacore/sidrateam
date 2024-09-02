import 'dart:async';
import 'package:cluster/common_widgets/loading.dart';
import 'package:cluster/core/color_palatte.dart';
import 'package:cluster/presentation/task_operation/create/task_bloc/task_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_address_picker/models/location_result.dart';

import '../../../common_widgets/gradient_button.dart';
import '../../../core/common_snackBar.dart';
import '../../../core/utils/variables.dart';
import '../../dashboard_screen/home_screen/homescreen_widget/appbar.dart';
import 'model/task_models.dart';


class AddressPickFromMap extends StatefulWidget {
  final String? countryCode;
  final GetTaskList? taskRead;
  final bool? isUser;
  const AddressPickFromMap({Key? key, this.countryCode, this.taskRead, this.isUser=false}) : super(key: key);

  @override

  State<AddressPickFromMap> createState() => _AddressPickFromMapState();
}

class _AddressPickFromMapState extends State<AddressPickFromMap> {
  int searchLength = 0;
  TextEditingController _searchController = TextEditingController();
  bool delButtonDisable = false;
  Completer<GoogleMapController> mapController = Completer();
  Position? _currentPosition;
  LatLng? _lastMapPosition;
  MapType? selectedMapType;
  BitmapDescriptor? customIcon;
  double? latitude;
  double? longitude;
  String? city;
  String? country;
  String? state1;
  String? highLightAddress;
  String? area;
  final Set<Marker> _markers = {};
  LocationResult? locationResult;
  LatLng? _selectedLocation;

//search location
  void _searchLocation(String query) async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=AIzaSyCAagJLDQSlAv4j9d19yCzhD0MhAnSKS1E';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      print("searhhhh api   response ${data}");
      if (data['status'] == 'OK') {
        double lat = data['results'][0]['geometry']['location']['lat'];
        double lng = data['results'][0]['geometry']['location']['lng'];
        setState(() {
          _selectedLocation = LatLng(lat, lng);
          moveToCurrentLocation(_selectedLocation!);
        });
      } else {
        // Handle error
      }
    } else {
      // Handle error
    }
  }

  // this also checks for location permission.
  Future<void> _initCurrentLocation() async {
    print("hoi bro");
    await _checkGeolocationPermission();
    Position? currentPosition;
    try {
      currentPosition = await
      // Geolocator.s
      Geolocator.getCurrentPosition(
        timeLimit: Duration(seconds: 20),
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      currentPosition = null;
      // print(e);
    }

    if (mounted && currentPosition != null) {
      setState(() => _currentPosition = currentPosition);
    }
    if (currentPosition != null || _currentPosition != null) {
      _lastMapPosition = currentPosition == null
          ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
          : LatLng(currentPosition.latitude, currentPosition.longitude);
      setState(() {
        _markers.add(Marker(
          icon: customIcon!,
          markerId: const MarkerId("defaultMarker"),
          position: currentPosition == null
              ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
              : LatLng(currentPosition.latitude, currentPosition.longitude),
        ));
      });
    }

    if (_currentPosition != null) {
      await moveToCurrentLocation(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
    }
  }

  Future moveToCurrentLocation(LatLng currentLocation) async {
    print("new mappp posssiittook old loca");
print("new mapp location got ${currentLocation}");
    final controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: currentLocation, zoom: 16),
    ));
    print("hi hello");
    // getAddressFromLatLong(LatLng(currentLocation.latitude,currentLocation.longitude),);
  }

  Future moveToNewPosition(LatLng newLocation) async {
    print(
        "new mappp posssiittook lattttt ${newLocation.latitude}  longggg ${newLocation.longitude}");
    final controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: newLocation, zoom: 16),
    ));
    // getAddressFromLatLong(LatLng(currentLocation.latitude,currentLocation.longitude),);
  }

  bool automaticallyAnimateToCurrentLocation = true;
  bool requiredGPS = true;
  LatLng initialCenter = const LatLng(28.612925, 77.229512);
  String address = 'turn on location';
  bool buttonLoad=false;
  bool isValid=false;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(5, 5)), 'asset/location_marker.png',)
    // const ImageConfiguration(size: Size(0.5, 0.5)), 'asset/pin.png',)
        .then((d) {
      customIcon = d;
    });
    if(widget.taskRead?.latitude!=null&&widget.taskRead?.latitude!=""&&widget.taskRead?.longitude!=null&&widget.taskRead?.latitude!=""){
      print("if case run");
      getAddressFromLatLong( LatLng(
        double.tryParse(widget.taskRead?.latitude??'')??0.0,
        double.tryParse(widget.taskRead?.longitude??'')??0.0,
      ));
      moveToNewPosition( LatLng(
        double.tryParse(widget.taskRead?.latitude??'')??0.0,
        double.tryParse(widget.taskRead?.longitude??'')??0.0,
      ));
      _markers.add(Marker(
        markerId: const MarkerId("defaultMarker"),
        position:  LatLng(
          double.tryParse(widget.taskRead?.latitude??'')??0.0,
          double.tryParse(widget.taskRead?.longitude??'')??0.0,
        ),
        icon: customIcon ?? BitmapDescriptor.defaultMarker,
      ));

    }else{
      print("else case run");
      getAddressFromLatLong(const LatLng(
        11.265573014752482,
        75.81402953714132,
      ));
      moveToNewPosition(const LatLng(
        11.265573014752482,
        75.81402953714132,
      ));
      _markers.add(Marker(
        markerId: const MarkerId("defaultMarker"),
        position: const LatLng(
          11.265573014752482,
          75.81402953714132,
        ),
        icon: customIcon ?? BitmapDescriptor.defaultMarker,
      ));
    }

    context
        .read<TaskBloc>()
        .add(SearchMapResults(searchQuery: _searchController.text));
    if (automaticallyAnimateToCurrentLocation && !requiredGPS) {
      _initCurrentLocation();
    }
    // BitmapDescriptor.defaultMarker;
    // BitmapDescriptor.defaultMarkerWithHue(50);


    super.initState();
  }

  Future<void> getAddressFromLatLong(var position) async {
    print(
        "new mappp posssiittoo get addreesss from lat long  lattt ${position.latitude} longggg ${position.longitude}");
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    latitude = position.latitude;
    longitude = position.longitude;

    Placemark place = placemarks[0];
    address = '${place.name}, ${place.locality},${place.country}';
    state1 = place.administrativeArea;
    city = place.locality;
    try {
      area = place.street?.split("-")[1];

    } catch (e) {
      area=place.street;
    }
    country = place.isoCountryCode;
    print("addresssss at map......... $area");
    print("addresssss at map sub locality ${place.name}");

    print("addresssss at map sub adm area ${place.street}");
    // print("addresssss at map sub adm area ${place.street?.split("-")[1]}");
    print("addresssss at map sub locality ${place.subAdministrativeArea}");
    print("addresssss at map localuity ${place.locality}");
    // context.read<AddressBloc>().add(DeliveryAddressCheck(
    //     country: country, state: state1, city: city=="" ||city==null?area:city, street: area));
    // Assets.deliveryAddress = address;
    // if (Variables.defaultAddress == "") {
    //   Variables.defaultAddress = address;
    // }
    setState(() {});
    //  moveToCurrentLocation(LatLng(position.latitude,position.longitude));
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    double w1 = MediaQuery.of(context).size.width;
    double w = w1 > 700 ? 400 : w1;
    selectedMapType ??= MapType.normal;
    bool darkIcons = ((selectedMapType == MapType.hybrid) ||
        (selectedMapType == MapType.satellite));
    return MultiBlocListener(
  listeners: [
    BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {

         if (state is UpdateTaskSuccess) {
           buttonLoad=false;
          Navigator.pop(context);
          context.read<TaskBloc>().add(GetTaskReadListEvent(widget.taskRead?.id ?? 0));
         // Navigator.push(context, MaterialPageRoute(builder: (context) => MoreDetailsScreen(),));
          print("task sucsess");

        }

        else if (state is UpdateTaskFailed) {
           buttonLoad=false;
          showSnackBar(
            context,
            message: state.error,
            color: Colors.red,
            // icon: Icons.admin_panel_settings_outlined
          );
          setState(() {

          });
        }

      },
),
    BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is SearchMapResultsSuccess) {
          searchLength = state.cartData?.length ?? 0;
          setState(() {});
        }
      },
    ),
  ],
  child: Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BackAppBar(
            isAction: false,
            onTap: () {

              Navigator.pop(context);
            },
            label: "Select Location",
          )),
      extendBodyBehindAppBar: true,
      body: SizedBox(
                // color: Colors.grey,
                width: w1,
                height: h,
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: selectedMapType ?? MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: initialCenter,
                        zoom: 200,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        mapController.complete(controller);

                        _markers.add(Marker(
                          markerId: const MarkerId("defaultMarker"),
                          position: initialCenter,
                          icon: customIcon!,
                        ));

                        _lastMapPosition = initialCenter;
                      },
                      markers: _markers,
                      onTap: (argument) {
                        isValid=true;
                        _lastMapPosition = argument;
                         print("lattttt........ ${_lastMapPosition?.latitude}");
                         print("lattttt++++++ ${_lastMapPosition?.longitude}");

                        Variable.locationUrl='https://www.google.com/maps/search/?api=1&query=${_lastMapPosition?.latitude},${_lastMapPosition?.longitude}';
                        print("RRRRRR!!!!!${Variable.locationUrl}");
                        setState(() {
                          getAddressFromLatLong(_lastMapPosition);
                          _markers.add(Marker(
                            markerId: const MarkerId("defaultMarker"),
                            position: argument,
                            icon: customIcon!,
                          ));
                        });
                      },
                      onLongPress: (argument) {
                        _lastMapPosition = argument;

                        setState(() {
                          getAddressFromLatLong(_lastMapPosition);
                          _markers.add(Marker(
                            markerId: const MarkerId("defaultMarker"),
                            position: argument,
                            icon: customIcon!,
                          ));
                        });
                      },
                      onCameraIdle: () async {
                        // getAddressFromLatLong(_lastMapPosition);
                        // print("onCameraIdle#_lastMapPosition = ");
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      padding: const EdgeInsets.only(
                        bottom: kBottomNavigationBarHeight + 60,
                      ),
                    ),
                    Positioned(
                        top: 100,
                        child: Container(
                          width: w1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),

                                // color: Colors.white,
                                // height: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      const Icon(Icons.search, color: Colors.grey),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                            controller: _searchController,
                                            decoration:  InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Search Location',
                                              hintStyle: GoogleFonts.roboto(
                                                fontSize: w/26,
                                                color: ColorPalette.borderGrey

                                              )
                                            ),
                                            onChanged: (query) {
                                              context.read<TaskBloc>().add(
                                                  SearchMapResults(
                                                      searchQuery:
                                                      _searchController.text));
                                            },
                                            onEditingComplete: () {
                                              context.read<TaskBloc>().add(
                                                  SearchMapResults(
                                                      searchQuery:
                                                      _searchController.text));
                                              FocusScopeNode currentFocus =
                                              FocusScope.of(context);

                                              if (!currentFocus.hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }

                                              // setState(() {});
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              BlocBuilder<TaskBloc, TaskState>(
                                builder: (context, state) {
                                  if (state is SearchMapResultsSuccess) {
                                    // searchLength = state.cartData?.length ?? 0;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      height: searchLength >= 5 ? h / 2 : null,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]),
                                      child: ListView.separated(
                                          padding: EdgeInsets.all(8),
                                          shrinkWrap: true,
                                          // physics: NeverScrollableScrollPhysics(),
                                          // primary: true,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                isValid=true;

                                                HapticFeedback.heavyImpact();

                                              latitude = state.cartData?[index]
                                                  .locationData?.latAndLang?.lat;
                                              longitude = state.cartData?[index]
                                                  .locationData?.latAndLang?.lng;
                                            _lastMapPosition=LatLng(state.cartData?[index].locationData?.latAndLang?.lat??0.0,
                                                state.cartData?[index].locationData?.latAndLang?.lng??0.0);
                                                getAddressFromLatLong(_lastMapPosition);
                                              moveToNewPosition(LatLng(
                                                  state
                                                      .cartData?[index]
                                                      .locationData
                                                      ?.latAndLang
                                                      ?.lat ??
                                                      0.0,
                                                  state
                                                      .cartData?[index]
                                                      .locationData
                                                      ?.latAndLang
                                                      ?.lng ??
                                                      0.0));
                                              _markers.add(Marker(
                                                markerId:
                                                const MarkerId("defaultMarker"),
                                                position: LatLng(
                                                    state
                                                        .cartData?[index]
                                                        .locationData
                                                        ?.latAndLang
                                                        ?.lat ??
                                                        0.0,
                                                    state
                                                        .cartData?[index]
                                                        .locationData
                                                        ?.latAndLang
                                                        ?.lng ??
                                                        0.0),
                                                icon: customIcon!,
                                              ));

                                              context.read<TaskBloc>().add(
                                                  const SearchMapResults(
                                                      searchQuery: ""));
                                              setState(() {

                                              });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 10),

                                                color: Colors.white,
                                                // height: 40,
                                                width: w,
                                                child: Text(
                                                  state.cartData?[index].formattedAddress ??
                                                      "",
                                                  style: TextStyle(fontSize: w / 28),
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const Divider(
                                              height: .5,
                                            );
                                          },
                                          itemCount: state.cartData?.length ?? 1),
                                    );
                                  }
                                  if (state is SearchMapResultsLoading) {
                                    return customCupertinoLoading();
                                  }
                                  return Container();
                                },
                              )

                            ],
                          ),
                        )),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 20, bottom: 20),
                              // margin: EdgeInsets.only(right: 20,bottom: 10),
                              width: w,
                              alignment: Alignment.bottomRight,

                              child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                elevation: 0.2,
                                onPressed: _initCurrentLocation,
                                materialTapTargetSize: MaterialTapTargetSize.padded,
                                mini: true,
                                heroTag: "layers2",
                                child: const Icon(
                                  Icons.gps_fixed,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              width: w1,
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(bottom: 25),
                                      width: w1 / 1.1,
                                      child: Text(
                                        address.toString(),
                                        style: const TextStyle(
                                            color: Color(0xff676767), fontSize: 12),
                                      )),

                                   Container(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 10),
                                    child: isValid==true?
                                    GradientButton(
                                        onPressed: () {
                                          HapticFeedback.heavyImpact();
                                          buttonLoad=true;

                                          setState(() {

                                          });
                                          print("lattttt........ ${_lastMapPosition?.latitude}");
                                          print("lattttt++++++ ${_lastMapPosition?.longitude}");

                                          BlocProvider.of<TaskBloc>(context).add(
                                              UpdateTaskEvent(
                                                latitude: _lastMapPosition?.latitude.toString()??"",
                                                longitude: _lastMapPosition?.longitude.toString()??"",
                                                img5:  widget.taskRead?.metaData?.image5,
                                                img1: widget.taskRead?.metaData?.image1,
                                                img4: widget.taskRead?.metaData?.image4,
                                                img2: widget.taskRead?.metaData?.image2,
                                                img3: widget.taskRead?.metaData?.image3,
                                                attachmentDescription: widget.taskRead?.metaData?.description,
                                                attachmentNote: widget.taskRead?.metaData?.note,
                                                id: widget.taskRead?.id??0,
                                                AssigningCode: widget.taskRead?.assigningCode??"",
                                                AssigningType: widget.taskRead?.assigningType??"",
                                                createdOn: "${widget.taskRead?.createdOn?.split("T")[0]}"" ""${widget.taskRead?.createdOn?.split("T")[1].split("+")[0]}",
                                                jobid: widget.taskRead?.jobId,
                                                notas: widget.taskRead?.notes??"",
                                                durationOption: widget.taskRead?.duration??'',
                                                priorityLeval: 0,
                                                remarks: widget.taskRead?.remarks??"",
                                                taskName: widget.taskRead?.taskName??"",
                                                taskType: widget.taskRead?.taskType??0,
                                                lastmodified: null,
                                                parant: widget.taskRead?.parent??null,
                                                statusStagesId: widget.taskRead?.statusStagesId,
                                                discription:widget.taskRead?.description??"",
                                                createdBy: widget.taskRead?.createdPersonCode??"",
                                                isActive: true,
                                                priority: widget.taskRead?.priority??"",
                                                reportingPerson: widget.taskRead?.reportingPersonCode??"",
                                                endDate: "${widget.taskRead?.endDate?.split("T")[0]}",
                                                startDate: "${widget.taskRead?.startDate?.split("T")[0]}",
                                                startTime: "${widget.taskRead?.startDate?.split("T")[1].split("+")[0]}",
                                                endTime: "${widget.taskRead?.endDate?.split("T")[1].split("+")[0]}"
                                              ));


                                        },
                                        gradient: const LinearGradient(
                                          colors: [
                                            ColorPalette.primary,
                                            ColorPalette.primary,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        color: ColorPalette.primary,
                                        child:  buttonLoad==true?SpinKitThreeBounce(
                                          color: Colors.white,
                                          size: 15.0,
                                        ):Text(
                                          "CONFIRM LOCATION",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        )):
                                    GradientButton(
                                        onPressed: () {
                                          HapticFeedback.heavyImpact();
                                          buttonLoad=true;

                                          setState(() {

                                          });
                                          print("lattttt........ ${_lastMapPosition?.latitude}");
                                          print("lattttt++++++ ${_lastMapPosition?.longitude}");

                                          BlocProvider.of<TaskBloc>(context).add(
                                              UpdateTaskEvent(
                                                  latitude: _lastMapPosition?.latitude.toString()??"",
                                                  longitude: _lastMapPosition?.longitude.toString()??"",
                                                  img5:  widget.taskRead?.metaData?.image5,
                                                  img1: widget.taskRead?.metaData?.image1,
                                                  img4: widget.taskRead?.metaData?.image4,
                                                  img2: widget.taskRead?.metaData?.image2,
                                                  img3: widget.taskRead?.metaData?.image3,
                                                  attachmentDescription: widget.taskRead?.metaData?.description,
                                                  attachmentNote: widget.taskRead?.metaData?.note,
                                                  id: widget.taskRead?.id??0,
                                                  AssigningCode: widget.taskRead?.assigningCode??"",
                                                  AssigningType: widget.taskRead?.assigningType??"",
                                                  createdOn: "${widget.taskRead?.createdOn?.split("T")[0]}"" ""${widget.taskRead?.createdOn?.split("T")[1].split("+")[0]}",
                                                  jobid: widget.taskRead?.jobId,
                                                  notas: widget.taskRead?.notes??"",
                                                  durationOption: widget.taskRead?.duration??'',
                                                  priorityLeval: 0,
                                                  remarks: widget.taskRead?.remarks??"",
                                                  taskName: widget.taskRead?.taskName??"",
                                                  taskType: widget.taskRead?.taskType??0,
                                                  lastmodified: null,
                                                  parant: widget.taskRead?.parent??null,
                                                  statusStagesId: widget.taskRead?.statusStagesId,
                                                  discription:widget.taskRead?.description??"",
                                                  createdBy: widget.taskRead?.createdPersonCode??"",
                                                  isActive: true,
                                                  priority: widget.taskRead?.priority??"",
                                                  reportingPerson: widget.taskRead?.reportingPersonCode??"",
                                                  endDate: "${widget.taskRead?.endDate?.split("T")[0]}",
                                                  startDate: "${widget.taskRead?.startDate?.split("T")[0]}",
                                                  startTime: "${widget.taskRead?.startDate?.split("T")[1].split("+")[0]}",
                                                  endTime: "${widget.taskRead?.endDate?.split("T")[1].split("+")[0]}"
                                              ));


                                        },
                                        gradient: const LinearGradient(
                                          colors: [
                                            ColorPalette.inactiveGrey,
                                            ColorPalette.inactiveGrey,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        color: ColorPalette.inactiveGrey,
                                        child:  buttonLoad==true?SpinKitThreeBounce(
                                          color: Colors.white,
                                          size: 15.0,
                                        ):Text(
                                          "CONFIRM LOCATION",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ))
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
    ),
);
  }

  var dialogOpen;

  Future _checkGeolocationPermission() async {
    await Geolocator.requestPermission();
    final geolocationStatus = await Geolocator.checkPermission();
    // print("geolocationStatus = $geolocationStatus");

    if (geolocationStatus == LocationPermission.denied && dialogOpen == null) {
      dialogOpen = _showDeniedDialog();
    } else if (geolocationStatus == LocationPermission.deniedForever &&
        dialogOpen == null) {
      dialogOpen = _showDeniedForeverDialog();
    } else if (geolocationStatus == LocationPermission.whileInUse ||
        geolocationStatus == LocationPermission.always) {
      // print('GeolocationStatus.granted');

      if (dialogOpen != null) {
        Navigator.of(context, rootNavigator: true).pop();
        dialogOpen = null;
      }
    }
  }

  Future _showDeniedDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            ;
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pop();
            return true;
          },
          child: AlertDialog(
            title: const Text('Access to location denied'),
            content: const Text('Allow access to the location services.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _initCurrentLocation();
                  dialogOpen = null;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _showDeniedForeverDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pop();
            return true;
          },
          child: AlertDialog(
            title: const Text(
              'Access to location permanently denied',
            ),
            content: const Text(
              'Allow access to the location services for this App using the device settings.',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Geolocator.openAppSettings();
                  dialogOpen = null;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}