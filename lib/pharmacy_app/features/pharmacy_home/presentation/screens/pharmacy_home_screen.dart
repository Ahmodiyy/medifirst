import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medifirst/core/constants/data.dart';

import '../../../../../core/theming/palette.dart';


class PharmacyHomeScreen extends ConsumerStatefulWidget {
  const PharmacyHomeScreen({super.key});

  @override
  ConsumerState createState() => _PharmacyHomeScreenState();
}

class _PharmacyHomeScreenState extends ConsumerState<PharmacyHomeScreen> {
  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Data.pharmacyPages[_page],
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
