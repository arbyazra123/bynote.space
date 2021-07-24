import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> isConnected();
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> isConnected() async {
    try {
      await FirebaseFirestore.instance.runTransaction((_) async {
        return await _;
      });
      return true;
    } catch (_) {
      return false;
    }
  }
}
