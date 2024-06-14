import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../state_management/connection_provider.dart';

/// A widget that displays an indicator to show the connection status.
class ConnectionIndicator extends StatefulWidget {
  // final bool isConnected;

  /// Constructor for the ConnectionIndicator class.
  /// The `isConnected` parameter specifies whether the device is connected to the network.
  const ConnectionIndicator({
    super.key,
  });
  //required this.isConnected}

  @override
  State<ConnectionIndicator> createState() => _ConnectionIndicatorState();
}

class _ConnectionIndicatorState extends State<ConnectionIndicator> {
  @override
  Widget build(BuildContext context) {
    // Connectionprovider connection =
    //     Provider.of<Connectionprovider>(context, listen: false);
    return Consumer<Connectionprovider>(
      builder:
          (BuildContext context, Connectionprovider connection, Widget? child) {
        return Align(
          alignment: Alignment.topRight,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              color: PrimaryAppColors.innerBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'LG Rig',
                  style: TextStyle(fontFamily: fontType, fontSize: textSize),
                ),
                CircleAvatar(
                  backgroundColor: connection.isLgConnected
                      ? LgAppColors.lgColor4
                      : LgAppColors.lgColor2,
                  radius: 20,
                ),
                Text(
                  'AI Server',
                  style: TextStyle(fontFamily: fontType, fontSize: textSize),
                ),
                CircleAvatar(
                  backgroundColor: connection.isAiConnected
                      ? LgAppColors.lgColor4
                      : LgAppColors.lgColor2,
                  radius: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
