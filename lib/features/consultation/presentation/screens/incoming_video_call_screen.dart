import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/features/consultation/presentation/screens/video_call_screen.dart';

import '../../controller/video_call_controller.dart';
import '../../controller/voice_call_controller.dart';

class IncomingVideoCallScreen extends ConsumerWidget {
  final String callId;
  final String callerId;
  final String callerName;

  IncomingVideoCallScreen({
    required this.callId,
    required this.callerId,
    required this.callerName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam, size: 64),
            Text('Incoming video call from $callerName'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.videocam),
                  label: Text('Answer with Video'),
                  onPressed: () {
                    // Answer the video call

                    /**
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => VideoCallScreen()),
                    );
                        **/
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.call_end),
                  label: Text('Decline'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    // Reject the call

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
