import 'package:internet_connection_checker/internet_connection_checker.dart';

class ServerException implements Exception {
  final String message;
  
  const ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  
  const CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;
  
  const NetworkException(this.message);
}

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}