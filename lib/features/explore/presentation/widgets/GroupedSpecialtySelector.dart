import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/doctor_search_bar.dart';

class Specialty {
  final String id;
  final String name;
  final String description;

  Specialty({required this.id, required this.name, required this.description});

  factory Specialty.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Specialty(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
    );
  }
}

final specialtiesProvider = FutureProvider<List<Specialty>>((ref) async {
  final specialtiesSnapshot = await FirebaseFirestore.instance.collection('specialties').get();
  return specialtiesSnapshot.docs.map((doc) => Specialty.fromFirestore(doc)).toList();
});

final selectedSpecialtyProvider = StateProvider<Specialty?>((ref) => null);


class SpecialtySelector extends ConsumerWidget {
  const SpecialtySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialtiesAsyncValue = ref.watch(specialtiesProvider);
    final selectedSpecialty = ref.watch(selectedSpecialtyProvider);

    return specialtiesAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (specialties) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: specialties.map((specialty) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        ref.read(selectedSpecialtyProvider.notifier).state = specialty;
                        ref.read(searchQueryProvider.notifier).state = specialty.name;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: selectedSpecialty == specialty
                              ? const Color(0xFF4CAF50)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF4CAF50),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          specialty.name,
                          style: TextStyle(
                            color: selectedSpecialty == specialty
                                ? Colors.white
                                : const Color(0xFF4CAF50),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (selectedSpecialty != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedSpecialty.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedSpecialty.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
