import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theming/palette.dart';

class EmergencyPage extends ConsumerWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        elevation: 1,
        title: const Text(
          'Emergency',
          style:
              TextStyle(color: Palette.blackColor, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fire Service Emergency Lines',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Palette.emergencyRed,
              ),
            ),
            Divider(
              thickness: .5,
              color: Colors.black.withOpacity(.08),
              height: 1,
            ),
            Expanded(
              child: ListView(
                children: const [
                  EmergencyCard(
                    title: 'Lagos State Fire Service Station Alausa',
                    location: 'Ikeja',
                    phone: '0803 323 5891',
                  ),
                  EmergencyCard(
                    title: 'Ogun State Fire Service Station – Abeokuta',
                    location: 'Abeokuta',
                    phone: '0803 569 2904',
                    phone2: '+234 807 675 9999',
                  ),
                  EmergencyCard(
                    title: 'Federal Fire Service Oyo Command',
                    location: 'Oyo',
                    phone: '0815 420 5000',
                  ),
                  EmergencyCard(
                    title: 'Federal Fire Service Headquarters',
                    location: 'Area 10 Mohammadu Buhari Way',
                    phone: '0803 200 3557',
                    open24: true,
                  ),
                  EmergencyCard(
                    title: 'Rivers State Fire Service',
                    location: 'Rivers',
                    phone: '0703 152 2199',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyCard extends StatelessWidget {
  final String title;
  final String location;
  final String phone;
  final String? phone2;
  final bool open24;

  const EmergencyCard({
    Key? key,
    required this.title,
    required this.location,
    required this.phone,
    this.phone2,
    this.open24 = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 16, color: Colors.black.withOpacity(.6)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black.withOpacity(.6)),
                  ),
                ),
                if (open24) ...[
                  const SizedBox(width: 8),
                  const Text(
                    'Open 24 hours',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            _CopyPhoneButton(phone: phone),
            if (phone2 != null) ...[
              const SizedBox(height: 8),
              _CopyPhoneButton(phone: phone2!),
            ],
          ],
        ),
      ),
    );
  }
}

class _CopyPhoneButton extends StatelessWidget {
  final String phone;

  const _CopyPhoneButton({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: phone));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Palette.whiteColor,
              content: Text(
                'Copied $phone',
                style: const TextStyle(
                  color: Palette.consultationGreen,
                ),
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        icon: const Icon(Icons.phone, size: 20),
        label: Text(
          phone,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.faintGreen,
          foregroundColor: Palette.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
