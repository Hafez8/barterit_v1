import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barterlt_v1/models/item.dart';
import 'package:barterlt_v1/models/user.dart';
import 'package:barterlt_v1/myconfig.dart';
import 'package:http/http.dart'as http;

class BuyerDetailsScreen extends StatefulWidget {
  final Item usercatch;
  final User user;
  const BuyerDetailsScreen(
      {super.key, required this.usercatch, required this.user});

  @override
  State<BuyerDetailsScreen> createState() => _BuyerDetailsScreenState();
}

class _BuyerDetailsScreenState extends State<BuyerDetailsScreen> {
  int qty = 0;
  int userqty = 1;
  double totalprice = 0.0;
  double singleprice = 0.0;

  @override
  void initState() {
    super.initState();
    qty = int.parse(widget.usercatch.itemQty.toString());
    totalprice = double.parse(widget.usercatch.itemPrice.toString());
    singleprice = double.parse(widget.usercatch.itemPrice.toString());
  }

  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late double screenHeight, screenWidth, cardwitdh;

  Widget build (BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Items Details")),
      body: Column(children: [
        Flexible(
          flex:4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Card(
              child: Container(
                width: screenWidth,
                child: CachedNetworkImage(
                  width: screenWidth,
                  fit: BoxFit.cover,
                  imageUrl: "${MyConfig().SERVER}/barterit/assets/items/${widget.usercatch.itemId}.png",
                  placeholder: (context, url) => 
                  const LinearProgressIndicator(),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(
              widget.usercatch.itemName.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Table(
              columnWidths:const{
                0: FlexColumnWidth(4),
                1:FlexColumnWidth(6),
              },
              children: [
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ),
                 TableCell(
                    child: Text(
                      widget.usercatch.itemType.toString(),
                    ),
                  )
                ]),
               TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Quantity Available",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
               TableCell(
                  child: Text(
                    widget.usercatch.itemQty.toString(),
                    ),
                  )
                ]),
              TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Price",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              TableCell(
                  child: Text(
                    "RM ${double.parse(widget.usercatch.itemPrice.toString()).toStringAsFixed(2)}",
                    ),
                  )
                ]),
              TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              TableCell(
                    child: Text(
                      "${widget.usercatch.itemLocality}/${widget.usercatch.itemState}",
                    ),
                  )
                ]),
            TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      df.format(DateTime.parse(
                          widget.usercatch.itemDate.toString())),
                    ),
                  )
                ]),
              ],
            ),
          )
          ),
          Container(
            padding: const EdgeInsets.all(8),
              child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                IconButton(
                  onPressed:(){
                    if (userqty <= 1) {
                      userqty = 1;
                      totalprice = singleprice * userqty;
                  } else {
                      userqty = userqty - 1;
                      totalprice = singleprice * userqty;
                  }
                  setState(() {});
                  },
                   icon: const Icon(Icons.remove)
                ),
              Text(
                userqty.toString(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              IconButton(
                onPressed: (){
                  if (userqty >= qty) {
                    userqty = qty;
                    totalprice = singleprice * userqty;
                  } else {
                    userqty = userqty + 1;
                    totalprice = singleprice * userqty;
                  }
                  setState(() {});
                },
                 icon: const Icon(Icons.add)
                ),
              ],
            ),
          ),
          Text(
          "RM ${totalprice.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }
}