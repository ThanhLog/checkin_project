class Address {
  final String street;
  final String ward;
  final String district;
  final String city;

  Address({
    this.street = '',
    this.ward = '',
    this.district = '',
    this.city = '',
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      ward: json['ward'] ?? '',
      district: json['district'] ?? '',
      city: json['city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'street': street, 'ward': ward, 'district': district, 'city': city};
  }
}

class PersonalInfo {
  final String fullName;
  final String tel;
  final String email;
  final String dateOfBirth;
  final String gender;
  final Address address;

  PersonalInfo({
    this.fullName = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.email = '',
    this.tel = '',
    Address? address,
  }) : address = address ?? Address();

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      fullName: json['full_name'] ?? '',
      tel: json['tel'] ?? '',
      email: json['email'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      gender: json['gender'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'date_of_birth': dateOfBirth,
      'tel': tel,
      'email': email,
      'gender': gender,
      'address': address.toJson(),
    };
  }
}

class Identification {
  final String idNumber;
  final String? issueDate;
  final String issuePlace;

  Identification({this.idNumber = '', this.issueDate, this.issuePlace = ''});

  factory Identification.fromJson(Map<String, dynamic> json) {
    return Identification(
      idNumber: json['id_number'] ?? '',
      issueDate: json['issue_date'],
      issuePlace: json['issue_place'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_number': idNumber,
      'issue_date': issueDate,
      'issue_place': issuePlace,
    };
  }
}

class FaceData {
  final String? faceImageUrl;
  final String? embeddingVersion;
  final List<String>? embeddings;

  FaceData({this.embeddings, this.faceImageUrl, this.embeddingVersion});

  factory FaceData.fromJson(Map<String, dynamic> json) {
    return FaceData(
      faceImageUrl: json['face_image_url'] ?? '',
      embeddingVersion: json['embedding_version'] ?? '',
      embeddings:
          (json['embeddings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'face_image_url': faceImageUrl,
      'embedding_version': embeddingVersion,
      'embeddings': embeddings,
    };
  }
}

class FaceImage {
  final String? imageUrl;
  final String? imageType;
  final String? uploadedAt;
  final int? fileSize;
  final String? fileFormat;

  FaceImage({
    this.imageUrl,
    this.imageType,
    this.uploadedAt,
    this.fileSize,
    this.fileFormat,
  });

  factory FaceImage.fromJson(Map<String, dynamic> json) {
    return FaceImage(
      imageUrl: json['image_url'] ?? '',
      imageType: json['image_type'] ?? '',
      uploadedAt: json['uploaded_at'] ?? '',
      fileSize: json['file_size'] ?? 0,
      fileFormat: json['file_format'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'image_type': imageType,
      'uploaded_at': uploadedAt,
      'file_size': fileSize,
      'file_format': fileFormat,
    };
  }
}

class UserModel {
  final String id;
  final String userId;
  final String? fcmToken;
  final PersonalInfo personalInfo;
  final Identification identification;
  final FaceData faceData;
  final List<FaceImage> images;

  UserModel({
    required this.id,
    required this.userId,
    this.fcmToken,
    PersonalInfo? personalInfo,
    Identification? identification,
    FaceData? faceData,
    List<FaceImage>? images,
  }) : personalInfo = personalInfo ?? PersonalInfo(),
       identification = identification ?? Identification(),
       faceData = faceData ?? FaceData(),
       images = images ?? [];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      fcmToken: json['fcm_token'] ?? '',
      personalInfo: PersonalInfo.fromJson(json['personal_info'] ?? {}),
      identification: Identification.fromJson(json['identification'] ?? {}),
      faceData: FaceData.fromJson(json['face_data'] ?? {}),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => FaceImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'fcm_token': fcmToken,
      'personal_info': personalInfo.toJson(),
      'identification': identification.toJson(),
      'face_data': faceData.toJson(),
      'images': images.map((e) => e.toJson()).toList(),
    };
  }
}
