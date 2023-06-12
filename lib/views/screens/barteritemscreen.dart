import 'dart:convert';
import 'dart:io';

import 'package:barterlt_v1/models/user.dart';
import 'package:barterlt_v1/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:barterlt_v1/models/user.dart';
import 'package:barterlt_v1/myconfig.dart';

class NewItemBarterScreen extends StatefulWidget{
  final User user;

  const NewItemBarterScreen ({super.key, required this.user});

  @override
  State<NewItemBarterScreen> createState() =>_NewItemBarterScreen();
}

class _NewItemBarterScreen extends State<NewItemBarterScreen>{
  File? _image;
  var pathAsset = "assets/camera.png";
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _itemnameEditingController = TextEditingController();
  final TextEditingController _itemdescEditingController = TextEditingController();
  final TextEditingController _itempriceEditingController = TextEditingController();
  final TextEditingController _itemqtyEditingController = TextEditingController();
  final TextEditingController _prstateEditingController = TextEditingController();
  final TextEditingController _prlocalEditingController = TextEditingController();
  String selectedType = "Gadgets";
  List<String> itemslist = [
    "Gadgets",
    "Cosmetics",
    "Electronic",
    "Toys",
    "Groceries",
    "Health & Beauty",
  ];
  late Position _currentPosition;

  String curnaddress = "";
  String curnstate = "";
  String prlat = "";
  String prlong = "";

  @override
  void iniState(){
    super.initState();
    _determinePosition();
  }

  Widget build(BuildContext context){
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Insert Your Item"), actions:[
        IconButton(onPressed: (){
          _determinePosition();
        },
        icon: const Icon(Icons.refresh)
        )
      ]),
      body: Column(children: [
        Flexible(
          flex: 4,
          child: GestureDetector(
            onTap: (){
              _selectFromCamera();
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8,4,8,4),
              child: Card(
                child: Container(
                  width: screenWidth,
                  decoration:BoxDecoration(
                    image: DecorationImage(
                      image: _image == null?
                      AssetImage(pathAsset):
                      FileImage(_image!)as ImageProvider,
                      fit: BoxFit.contain,
                    )
                  )
                ),
              ),
            ),
          )
        ),
        Expanded(
          flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20,5),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.type_specimen),
                          const SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            height: 60,
                            child: DropdownButton(
                              value: selectedType,
                              onChanged: (newValue){
                                setState(() {
                                  selectedType = newValue!;
                                  print(selectedType);
                                });
                              },
                              items: itemslist.map((selectedType){
                                return DropdownMenuItem(
                                  value: selectedType,
                                  child: Text(
                                    selectedType,
                                    ),
                                );
                              }
                            ).toList(),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                              val!.isEmpty || (val.length < 3)?
                              "Items name must be longger than 3":
                              null,
                            onFieldSubmitted: (v){},
                            controller: _itemnameEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Item Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.abc),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              )
                            ),
                            ),
                          )
                        ],
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) =>
                              val!.isEmpty || (val.length < 3)?
                              "Items description must be longger than 10":
                              null,
                            onFieldSubmitted: (v){},
                            maxLines: 4,
                            controller: _itemdescEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Item Description',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.description),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              )
                            ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                              val!.isEmpty?
                              "Items price must contain value":
                              null,
                            onFieldSubmitted: (v){},
                            controller: _itempriceEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Item Price',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.money),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              )
                            ),
                            ),
                          ),
                          Row(children: [
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current State"
                                : null,
                                enabled: false,
                                controller: _itemqtyEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  labelText: 'Current State',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )
                                ),
                              )
                            ),
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: false,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current Locality"
                                : null,
                            controller: _prlocalEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current Locality',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.map),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                            )
                          ]
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        SizedBox(
                          width: screenWidth/1.2,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (){
                              insertDialog();
                            },
                            child: const Text("Insert Catch"),
                          ),
                        )  
                        ]
                      )
                    ]
                  )
                ),
              )
          )
        )
      ])
    );
  }
  Future <void> _selectFromCamera() async{
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null){
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selecetd.');
    }
  }

  Future<void> cropImage() async{
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio3x2
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio3x2,
          lockAspectRatio: true
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      int? sizeInBytes = _image?.lengthSync();
      double sizeInMb = sizeInBytes! / (1024 * 1024);
      print(sizeInMb);

      setState(() {});
    }
  }
  void insertDialog(){
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please take picture")));
      return;
    }
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Insert your catch?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertItem();
                //registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void insertItem(){
    String itemname = _itemnameEditingController.text;
    String itemdesc = _itemdescEditingController.text;
    String itemprice = _itempriceEditingController.text;
    String itemqty = _itemqtyEditingController.text;
    String state = _prstateEditingController.text;
    String locality = _prlocalEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/insert_item.php"),
      body: {
        "userid": widget.user.id.toString(),
        "itemname": itemname,
        "itemprice": itemprice,
        "itemqty": itemqty,
        "typ": selectedType,
        "lalitude": prlat,
        "longitude":prlong,
        "state": state,
        "locality": locality,
        "image": base64Image
      }
    ).then((response){
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }
   void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
   permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
  }
  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _prlocalEditingController.text = "Changlun";
      _prstateEditingController.text = "Kedah";
      prlat = "6.443455345";
      prlong = "100.05488449";
    } else {
      _prlocalEditingController.text = placemarks[0].locality.toString();
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }
}