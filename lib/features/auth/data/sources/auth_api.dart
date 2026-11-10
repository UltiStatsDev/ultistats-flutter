import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ultistats/features/auth/data/models/auth_context_model.dart';
import 'package:ultistats/features/auth/data/models/installation_model.dart';
import 'package:ultistats/features/auth/data/models/logout_result_model.dart';
import 'package:ultistats/features/auth/data/requests/change_password_request.dart';
import 'package:ultistats/features/auth/data/requests/expected_session_request.dart';
import 'package:ultistats/features/auth/data/requests/login_request.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  /// Публичный эндпоинт: его installationId нужен в заголовке при входе.
  @GET('/installation')
  Future<InstallationModel> getInstallation();

  /// Восстановление сессии по cookie. Без cookie сервер отвечает ANONYMOUS.
  @GET('/auth/session')
  Future<AuthContextModel> getSession();

  @POST('/auth/login')
  Future<AuthContextModel> login(@Body() LoginRequest body);

  @POST('/auth/renew')
  Future<AuthContextModel> renew(@Body() ExpectedSessionRequest body);

  @POST('/auth/logout')
  Future<LogoutResultModel> logout(@Body() ExpectedSessionRequest body);

  @POST('/auth/password')
  Future<AuthContextModel> changePassword(@Body() ChangePasswordRequest body);
}
