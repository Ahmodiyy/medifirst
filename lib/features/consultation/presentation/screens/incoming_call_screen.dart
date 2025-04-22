import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/features/consultation/presentation/screens/voice_call_screen.dart';

import '../../controller/voice_call_controller.dart';

class IncomingCallScreen extends ConsumerWidget {
  final String callId;
  final String callerId;

  IncomingCallScreen({required this.callId, required this.callerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Incoming call from $callerId'),
            ElevatedButton(
              onPressed: () {
                // Answer the call

                /**
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => VoiceCallScreen()),
                );
                **/
              },
              child: Text('Answer'),
            ),
            ElevatedButton(
              onPressed: () {
                // Reject the call

                Navigator.pop(context);
              },
              child: Text('Reject'),
            ),
          ],
        ),
      ),
    );
  }
}
