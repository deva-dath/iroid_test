abstract class BaseApiResponse {
  bool? success;
  String? message;
  int? statusCode;

  BaseApiResponse fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    return this;
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}
