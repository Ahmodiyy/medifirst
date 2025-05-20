import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medifirst/core/widgets/elements/card_53_image.dart';
import 'package:medifirst/core/widgets/elements/error_text.dart';
import 'package:medifirst/core/widgets/elements/loader.dart';
import 'package:medifirst/core/widgets/elements/section_container.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/cart_and_checkout/controller/cart_and_checkout_controller.dart';

class MyCartBar extends ConsumerStatefulWidget {
  const MyCartBar({super.key});

  @override
  ConsumerState createState() => _MyCartBarState();
}

class _MyCartBarState extends ConsumerState<MyCartBar> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final user = ref.watch(userProvider);
    final drugs = ref.watch(getUserCartProvider(user!.uid));
    return SectionContainer(
      height: size.height * 85 / 852,
      child: Padding(
        padding: EdgeInsets.all(size.width * 16 / 393),
        child: drugs.when(
          data: (drugs) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (drugs[index].inCart) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 3/393),
                    child: Card53Image(imgUrl: drugs[index].drugImageURL),
                  );
                }
                return null;
              },
            );
          },
          error: (error, stackTrace) =>
              const ErrorText(error: 'An error occurred'),
          loading: () => const Loader(),
        ),
      ),
    );
  }
}
