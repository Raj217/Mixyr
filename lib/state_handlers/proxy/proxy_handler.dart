import 'package:flutter/material.dart';
import 'package:http_proxy/http_proxy.dart';
import 'dart:io';

class ProxyHandler {
  static Future<void> setUpProxy(
      {required String host, required String port}) async {
    HttpProxy httpProxy = await HttpProxy.createHttpProxy();
    httpProxy.host = host; // replace with your server ip
    httpProxy.port = port; // replace with your server port
    HttpOverrides.global = httpProxy;
  }

  static void removeProxy() {
    HttpOverrides.global = null;
  }
}
