import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../theming/palette.dart';
import '../elements/rounded_edge_textfield.dart';

class LocationSearchBar extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final bool readOnly;
  final Function(String)? onSubmitted;
  const LocationSearchBar({required this.controller, this.readOnly = false, this.onSubmitted, super.key});

  @override
  ConsumerState createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends ConsumerState<LocationSearchBar> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 48 / 852,
      child: Row(
        children: [
          SizedBox(
              width: size.width * 309 / 393,
              child: RoundedEdgeTextField(
                  controller: widget.controller,
                  onSubmitted: widget.onSubmitted,
                  isReadOnly: widget.readOnly,
                  prefixIcon: 'assets/icons/svgs/location.svg',
                  hint: 'Search For Doctors'),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: size.height * 44 / 852,
              width: size.width * 44 / 393,
              decoration: BoxDecoration(
                color: Palette.whiteColor,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Palette.dividerGray, width: 1.0),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/svgs/search-filters.svg',
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
