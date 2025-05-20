import 'package:medifirst/core/constants/constants.dart';

class UserInfoModel{
  final String name;
  final String surname;
  final String uid;
  final double latitude;
  final double longitude;
  final int age;
  final String phone;
  final String email;
  final String address;
  final String profilePicture;
  final String bio;
  final String state;
  final String occupation;
  final String city;
  final String? fcmToken;
  final String emergencyContact;
  final String bloodPressure;
  final double bmi;
  final int height;
  final double weight;
  final String surgicalHist;
  final String genotype;
  final String  bloodGroup;
  final String geneticDisorder;
  final String medicalDisorder;
  final List<String> favDoctors;
  final List<String> favPractices;

//<editor-fold desc="Data Methods">
  const UserInfoModel({
    required this.name,
    required this.surname,
    required this.uid,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.age = 0,
    this.phone = '',
    this.email = '',
    this.address = '',
    this.profilePicture = Constants.defaultProfilePic,
    this.bio = '',
    this.state = '',
    this.occupation = '',
    this.city = '',
    this.fcmToken = '',
    this.emergencyContact = '',
    this.bloodPressure = '',
    this.bmi = 0,
    this.height = 0,
    this.weight = 0,
    this.surgicalHist = '',
    this.genotype = '',
    this.bloodGroup = '',
    this.geneticDisorder = '',
    this.medicalDisorder = '',
    required this.favPractices,
    required this.favDoctors,
  });


  UserInfoModel copyWith({
    String? name,
    String? surname,
    String? uid,
    double? latitude,
    double? longitude,
    int? age,
    String? phone,
    String? email,
    String? address,
    String? profilePicture,
    String? bio,
    String? state,
    String? occupation,
    String? city,
    String? fcmToken,
    String? emergencyContact,
    String? bloodPressure,
    double? bmi,
    int? height,
    double? weight,
    String? surgicalHist,
    String? genotype,
    String? bloodGroup,
    String? geneticDisorder,
    String? medicalDisorder,
    List<String>? favDoctors,
    List<String>? favPractices,
  }) {
    return UserInfoModel(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      uid: uid ?? this.uid,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      state: state ?? this.state,
      occupation: occupation ?? this.occupation,
      city: city ?? this.city,
      fcmToken: fcmToken ?? this.fcmToken,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      bmi: bmi ?? this.bmi,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      surgicalHist: surgicalHist ?? this.surgicalHist,
      genotype: genotype ?? this.genotype,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      geneticDisorder: geneticDisorder ?? this.geneticDisorder,
      medicalDisorder: medicalDisorder ?? this.medicalDisorder,
      favDoctors: favDoctors ?? this.favDoctors,
      favPractices: favPractices ?? this.favPractices
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'uid': uid,
      'latitude': latitude,
      'longitude': longitude,
      'age': age,
      'phone': phone,
      'email': email,
      'address': address,
      'profilePicture': profilePicture,
      'bio': bio,
      'state': state,
      'occupation': occupation,
      'city': city,
      'fcmToken': fcmToken,
      'emergencyContact': emergencyContact,
      'bloodPressure': bloodPressure,
      'bmi': bmi,
      'height': height,
      'weight': weight,
      'surgicalHist': surgicalHist,
      'genotype': genotype,
      'bloodGroup': bloodGroup,
      'geneticDisorder': geneticDisorder,
      'medicalDisorder': medicalDisorder,
      'favDoctors': favDoctors,
      'favPractices': favPractices
    };
  }

  factory UserInfoModel.fromMap(Map<String, dynamic> map) {
    return UserInfoModel(
      name: map['name'] as String? ?? '',
      surname: map['surname'] as String? ?? '',
      uid: map['uid'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      age: map['age'] as int? ?? 0,
      phone: map['phone'] as String? ?? '',
      email: map['email'] as String? ?? '',
      address: map['address'] as String? ?? '',
      profilePicture: map['profilePicture'] as String? ?? Constants.defaultProfilePic,
      bio: map['bio'] as String? ?? '',
      state: map['state'] as String? ?? '',
      occupation: map['occupation'] as String? ?? '',
      city: map['city'] as String? ?? '',
      fcmToken: map['fcmToken'] as String? ?? '',
      emergencyContact: map['emergencyContact'] as String? ?? '',
      bloodPressure: map['bloodPressure'] as String? ?? '',
      bmi: (map['bmi'] as num?)?.toDouble() ?? 0.0,
      height: map['height'] as int? ?? 0,
      weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
      surgicalHist: map['surgicalHist'] as String? ?? '',
      genotype: map['genotype'] as String? ?? '',
      bloodGroup: map['bloodGroup'] as String? ?? '',
      geneticDisorder: map['geneticDisorder'] as String? ?? '',
      medicalDisorder: map['medicalDisorder'] as String? ?? '',
      favDoctors: (map['favDoctors'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      favPractices: (map['favPractices'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }


//</editor-fold>
}
