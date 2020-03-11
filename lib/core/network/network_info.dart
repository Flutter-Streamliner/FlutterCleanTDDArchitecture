import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImplementation implements NetworkInfo {
   final DataConnectionChecker dataConnectionChecker;

   NetworkInfoImplementation({@required this.dataConnectionChecker});

   @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}