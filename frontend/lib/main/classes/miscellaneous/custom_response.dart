sealed class CustomResponse {
  final bool success;
  final int statusCode;

  CustomResponse(this.success, this.statusCode); 
}

class ReqError extends CustomResponse {
  ReqError(super.success, super.statusCode);
}

class ReqSuccess extends CustomResponse {
  final dynamic data;

  ReqSuccess(super.success, super.statusCode, this.data);
}