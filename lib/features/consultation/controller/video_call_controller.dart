import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../repository/video_call_repository.dart';

final videoCallRepositoryProvider = Provider((ref) => VideoCallRepository());




