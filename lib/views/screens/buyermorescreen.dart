import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterlt_v1/myconfig.dart';
import 'package:barterlt_v1/models/item.dart';
import 'package:barterlt_v1/models/user.dart';
import 'package:http/http.dart' as http;

import 'buyerdetailscreen.dart';

class BuyerMoreScreen extends StatefulWidget {
  final Item useritem;
  final User user;
  const BuyerMoreScreen(
      {super.key, required this.useritem, required this.user});

  @override
  State<BuyerMoreScreen> createState() => _BuyerMoreScreenState();
}

class _BuyerMoreScreenState extends State<BuyerMoreScreen> {
  List<Item> itemList = <Item>[];
  int numberofresult = 0;
  late double screenHeight, screenWidth, cardwitdh;
  late User user = User(
      id: "na",
      name: "na",
      email: "na",
      phone: "na",
      datereg: "na",
      password: "na",
      otp: "na");

  @override
  void initState() {
    super.initState();
    loadSellerItems();
    loadSeller();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("More from ")),
      body: Column(
        children: [
          SizedBox(
              height: screenHeight / 8,
              width: screenWidth,
              child: Card(
                  child: user.name == "na"
                      ? const Center(child: Text("Loading..."))
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Store Owner\n${user.name}",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))),
          const Divider(),
          itemList.isEmpty
              ? Container()
              : Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(itemList.length, (index) {
                        return Card(
                          child: InkWell(
                            onTap: () async {
                              Item useritem =
                                  Item.fromJson(itemList[index].toJson());
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => BuyerDetailsScreen(
                                            user: widget.user,
                                            useritem: useritem
                                          )));
                              //loaditem();
                            },
                            child: Column(children: [
                              CachedNetworkImage(
                                width: screenWidth,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${MyConfig().SERVER}/barterit/assets/item/${itemList[index].itemId}.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Text(
                                itemList[index].itemName.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                "RM ${double.parse(itemList[index].itemPrice.toString()).toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "${itemList[index].itemQty} available",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ]),
                          ),
                        );
                      })))
        ],
      ),
    );
  }

  void loadSellerItems() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/load_singleseller.php"),
        body: {
          "sellerid": widget.useritem.userId,
        }).then((response) {
      //print(response.body);
      //log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['item'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }

  void loadSeller() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_user.php"),
        body: {
          "userid": widget.useritem.userId,
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }
}