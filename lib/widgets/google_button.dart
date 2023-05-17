import 'package:flutter/material.dart';

GestureDetector googleButton(
    BuildContext context, Function onTap, bool isLoading) {
  return GestureDetector(
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: isLoading
            ? [
                const CircularProgressIndicator(
                  color: Colors.black54,
                ),
              ]
            : [
                const Text(
                  "Continue with google",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Image.asset(
                  "lib/assets/google-logo.png",
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ],
      ),
    ),
    onTap: () {
      onTap();
    },
  );
}
