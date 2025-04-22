import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/voice_call_repository.dart';

final callRepositoryProvider = Provider((ref) => VoiceCallRepository());


