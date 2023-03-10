import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

import '../network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker dataConnectionChecker;

  const NetworkInfoImpl(this.dataConnectionChecker);

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
