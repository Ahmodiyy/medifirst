import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/doctor_app/features/appointment_list/presentation/screens/appointment_list_screen.dart';
import 'package:medifirst/doctor_app/features/doctor_explore/presentation/screens/doctor_explore_screen.dart';
import 'package:medifirst/doctor_app/features/doctor_notifications/presentation/screens/doctor_notifications.dart';
import 'package:medifirst/doctor_app/features/doctor_settings/presentation/screens/doctor_settings_screen.dart';
import 'package:medifirst/doctor_app/features/wallet/presentation/screens/doctor_wallet_screen.dart';
import 'package:medifirst/features/explore/presentation/screens/explore_page.dart';
import 'package:medifirst/features/my_lists/presentation/screens/my_orders_screen.dart';
import 'package:medifirst/features/notifications/presentation/screens/notification_screen.dart';
import 'package:medifirst/features/settings/presentation/screens/settings_screen.dart';
import 'package:medifirst/features/wallet/presentation/screens/wallet_screen.dart';

class Data {
  static NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');
  static NumberFormat balanceFormat = NumberFormat('#,##0', 'en_US');

  static List<String> pkgUnits = [
    'Box',
    'Strip',
    'Pieces',
  ];

  static Map<int, String> appointmentType = {
    1: 'Video Call',
    2: 'Voice Call',
    3: 'Chat'
  };

  static Map<int, String> requestStatus = {
    1: 'Unanswered',
    2: 'Accepted',
    3: 'Rejected'
  };

  static Map<int, String> appointmentIcon = {
    1: 'assets/icons/svgs/white_video_call.svg',
    2: 'assets/icons/svgs/phone_call.svg',
    3: 'assets/icons/svgs/white_chat.svg',
  };

  static Map<int, String> orderStatus = {
    1: 'Processing',
    2: 'Delivered',
    3: 'Cancelled'
  };

  static Map<int, String> transactionType = {
    1: 'Withdrawal',
    2: 'Deposit',
    3: 'Receive money',
    4: 'Send money'
  };

  static Map<int, String> transactionLogo = {
    1: 'assets/icons/svgs/transactions/withdrawal.svg',
    2: 'assets/icons/svgs/transactions/deposit.svg',
    3: 'assets/icons/svgs/transactions/credit.svg',
    4: 'assets/icons/svgs/transactions/debit.svg'
  };

  static List<Widget> patientPages = [
    const ExplorePage(),
    const MyOrdersScreen(),
    const NotificationScreen(),
    const WalletScreen(),
    const SettingsScreen(),
  ];

  static List<Widget> doctorPages = [
    const DoctorExploreScreen(),
    const AppointmentListScreen(),
    const DoctorNotificationScreen(),
    const DoctorWalletScreen(),
    const DoctorSettingsScreen(),
  ];

  // static List<Widget> pharmacyPages = [
  //   const PharmacyExploreScreen(),
  //   Container(),
  //   const PharmacyNotificationScreen(),
  //   const PharmacySettingsScreen(),
  // ];
}
