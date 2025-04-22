import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medifirst/core/constants/constants.dart';
import 'package:medifirst/core/constants/data.dart';
import 'package:medifirst/core/utils/utils.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/models/user_info.dart';

import '../../../../core/theming/palette.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }


  void _setupMessagingWhenUserAvailable() async {
    ref.listen<UserInfoModel?>(userProvider, (previous, next) {
      if (next != null) {
        setupFirebaseMessaging(Constants.patientCategory, next.uid);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width;
    _setupMessagingWhenUserAvailable();
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: Data.patientPages[_page],
        bottomNavigationBar: Material(
          color: Palette.mainGreen,
          child: TabBar(
            splashBorderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            labelColor: Palette.whiteColor,
            indicatorColor: Palette.whiteColor,
            unselectedLabelColor: Palette.dividerGray,
            isScrollable: false,
            labelStyle: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 8,
              color: Palette.whiteColor,
            ),
            unselectedLabelStyle: Palette.lightModeAppTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 8,
              color: Palette.dividerGray,
            ),
            onTap: onPageChanged,
            tabs: [
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/tab_bar/discover.svg',
                  colorFilter: ColorFilter.mode(
                      (_page == 0) ? Palette.whiteColor : Palette.dividerGray,
                      BlendMode.srcIn),
                  fit: BoxFit.scaleDown,
                  height: 24,
                  width: 24,
                ),
                text: 'Explore',
              ),
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/tab_bar/clipboard.svg',
                  colorFilter: ColorFilter.mode(
                      (_page == 1) ? Palette.whiteColor : Palette.dividerGray,
                      BlendMode.srcIn),
                  fit: BoxFit.scaleDown,
                  height: 24,
                  width: 24,
                ),
                text: 'Orders',
              ),
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/tab_bar/notification.svg',
                  colorFilter: ColorFilter.mode(
                      (_page == 2) ? Palette.whiteColor : Palette.dividerGray,
                      BlendMode.srcIn),
                  fit: BoxFit.scaleDown,
                  height: 24,
                  width: 24,
                ),
                text: 'Notifications',
              ),
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/tab_bar/wallet.svg',
                  colorFilter: ColorFilter.mode(
                      (_page == 3) ? Palette.whiteColor : Palette.dividerGray,
                      BlendMode.srcIn),
                  fit: BoxFit.scaleDown,
                  height: 24,
                  width: 24,
                ),
                text: 'Wallet',
              ),
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/tab_bar/setting.svg',
                  colorFilter: ColorFilter.mode(
                      (_page == 4) ? Palette.whiteColor : Palette.dividerGray,
                      BlendMode.srcIn),
                  fit: BoxFit.scaleDown,
                  height: 24,
                  width: 24,
                ),
                text: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
