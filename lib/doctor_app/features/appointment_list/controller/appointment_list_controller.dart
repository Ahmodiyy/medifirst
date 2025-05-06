import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/doctor_app/features/appointment_list/repository/appointment_list_repository.dart';

import '../../../../models/appointment_info.dart';

final appointmentListControllerProvider =
    Provider<AppointmentListController>((ref) {
  final repo = ref.watch(appointmentListRepoProvider);
  return AppointmentListController(repo: repo);
});

final getAllDoctorAppointmentsProvider =
    StreamProvider.family((ref, String doctorId) {
  return ref
      .watch(appointmentListControllerProvider)
      .getAllDoctorAppointments(doctorId);
});

final getDoctorAppointmentProvider =
    StreamProvider.family((ref, String doctorId) {
  return ref
      .watch(appointmentListControllerProvider)
      .getDoctorAppointment(doctorId);
});

final getDoctorAppointmentRequestsProvider =
    StreamProvider.family((ref, String doctorId) {
  return ref
      .watch(appointmentListControllerProvider)
      .getDoctorAppointmentRequests(doctorId);
});

final getDoctorVideoAppointmentsProvider =
    StreamProvider.family((ref, String doctorId) {
  return ref
      .watch(appointmentListControllerProvider)
      .getDoctorVideoAppointments(doctorId);
});

final getDoctorVoiceAppointmentsProvider =
    StreamProvider.family((ref, String doctorId) {
  return ref
      .watch(appointmentListControllerProvider)
      .getDoctorVoiceAppointments(doctorId);
});

final getDoctorChatAppointmentsProvider =
    StreamProvider.family((ref, String doctorId) {
  return ref
      .watch(appointmentListControllerProvider)
      .getDoctorChatAppointments(doctorId);
});

class AppointmentListController {
  final AppointmentListRepository _repo;

  const AppointmentListController({required AppointmentListRepository repo})
      : _repo = repo;

  Stream<List<AppointmentInfo>> getAllDoctorAppointments(String doctorId) {
    return _repo.getAllDoctorAppointments(doctorId);
  }

  Stream<List<AppointmentInfo>> getDoctorAppointmentRequests(String doctorId) {
    return _repo.getDoctorAppointmentRequests(doctorId);
  }

  Stream<List<AppointmentInfo>> getDoctorAppointment(String doctorId) {
    return _repo.getDoctorAppointment(doctorId);
  }

  Stream<List<AppointmentInfo>> getDoctorVideoAppointments(String doctorId) {
    return _repo.getDoctorVideoAppointments(doctorId);
  }

  Stream<List<AppointmentInfo>> getDoctorVoiceAppointments(String doctorId) {
    return _repo.getDoctorVoiceAppointments(doctorId);
  }

  Stream<List<AppointmentInfo>> getDoctorChatAppointments(String doctorId) {
    return _repo.getDoctorChatAppointments(doctorId);
  }

  Future<void> acceptAppointmentRequest(AppointmentInfo appt) async {
    final newAppt = appt.copyWith(status: 2);
    try {
      _repo.acceptAppointmentRequest(newAppt);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectAppointmentRequest(AppointmentInfo appt) async {
    final newAppt = appt.copyWith(status: 3);
    try {
      _repo.acceptAppointmentRequest(newAppt);
    } catch (e) {
      rethrow;
    }
  }
}
