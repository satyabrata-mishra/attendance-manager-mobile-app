import 'package:flutter/material.dart';

Image imageWidget(String imageName,BuildContext context){
  return Image.asset(imageName,
    fit: BoxFit.fitHeight,
    width: MediaQuery.of(context).size.width,
    height: 200,
  );
}