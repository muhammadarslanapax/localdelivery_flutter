class LoginResponse {
  UserData? data;
  String? message;

  String? isEmailVerification;
  var status;

  LoginResponse({this.data, this.message, this.status, this.isEmailVerification});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
      message: json['message'],
      isEmailVerification: json['is_email_verification'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['is_email_verification'] = this.isEmailVerification;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class UserData {
  String? apiToken;
  int? id;
  String? name;
  String? email;
  String? username;
  int? status;
  String? userType;
  int? countryId;
  String? countryName;
  int? cityId;
  String? cityName;
  String? address;
  String? contactNumber;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? loginType;
  String? latitude;
  String? longitude;
  String? uid;
  String? playerId;
  String? fcmToken;
  String? lastNotificationSeen;
  int? isVerifiedDeliveryMan;
  String? deletedAt;
  UserBankAccount? userBankAccount;
  String? otpVerifyAt;
  String? emailVerifiedAt;
  String? app_version;
  String? app_source;

  UserData(
      {this.apiToken,
      this.id,
      this.name,
      this.email,
      this.username,
      this.status,
      this.userType,
      this.countryId,
      this.countryName,
      this.cityId,
      this.cityName,
      this.address,
      this.contactNumber,
      this.createdAt,
      this.updatedAt,
      this.profileImage,
      this.loginType,
      this.latitude,
      this.longitude,
      this.uid,
      this.playerId,
      this.fcmToken,
      this.lastNotificationSeen,
      this.isVerifiedDeliveryMan,
      this.deletedAt,
      this.userBankAccount,
      this.otpVerifyAt,
      this.emailVerifiedAt,
      this.app_version,
      this.app_source});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    apiToken = json['api_token'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    status = json['status'];
    userType = json['user_type'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    address = json['address'];
    contactNumber = json['contact_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileImage = json['profile_image'];
    loginType = json['login_type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    uid = json['uid'];
    playerId = json['player_id'];
    fcmToken = json['fcm_token'];
    lastNotificationSeen = json['last_notification_seen'];
    isVerifiedDeliveryMan = json['is_verified_delivery_man'];
    deletedAt = json['deleted_at'];
    userBankAccount = json['user_bank_account'] != null ? new UserBankAccount.fromJson(json['user_bank_account']) : null;
    otpVerifyAt = json['otp_verify_at'];
    emailVerifiedAt = json['email_verified_at'];
    app_version = json['app_version'];
    app_source = json['app_source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['api_token'] = this.apiToken;
    data['username'] = this.username;
    data['status'] = this.status;
    data['user_type'] = this.userType;
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['address'] = this.address;
    data['contact_number'] = this.contactNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_image'] = this.profileImage;
    data['login_type'] = this.loginType;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['uid'] = this.uid;
    data['player_id'] = this.playerId;
    data['fcm_token'] = this.fcmToken;
    data['last_notification_seen'] = this.lastNotificationSeen;
    data['is_verified_delivery_man'] = this.isVerifiedDeliveryMan;
    data['app_version'] = this.app_version;
    data['app_source'] = this.app_source;
    data['deleted_at'] = this.deletedAt;
    if (this.userBankAccount != null) {
      data['user_bank_account'] = this.userBankAccount!.toJson();
    }
    data['otp_verify_at'] = this.otpVerifyAt;
    data['email_verified_at'] = this.emailVerifiedAt;

    return data;
  }
}

class UserBankAccount {
  int? id;
  int? userId;
  String? bankName;
  String? bankCode;
  String? accountHolderName;
  String? accountNumber;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  UserBankAccount({this.id, this.userId, this.bankName, this.bankCode, this.accountHolderName, this.accountNumber, this.createdAt, this.updatedAt, this.deletedAt});

  UserBankAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bankName = json['bank_name'];
    bankCode = json['bank_code'];
    accountHolderName = json['account_holder_name'];
    accountNumber = json['account_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['bank_name'] = this.bankName;
    data['bank_code'] = this.bankCode;
    data['account_holder_name'] = this.accountHolderName;
    data['account_number'] = this.accountNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
