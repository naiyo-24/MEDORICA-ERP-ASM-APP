import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../api_url.dart';

class AppUpdateService {
	final Dio _dio;

	AppUpdateService()
			: _dio = Dio()
				..interceptors.add(PrettyDioLogger(
					requestHeader: true,
					requestBody: true,
					responseBody: true,
					responseHeader: false,
					compact: true,
					maxWidth: 120,
				));

	Future<Map<String, dynamic>> getLatestVersionInfo() async {
		final url = ApiUrl.getFullUrl(ApiUrl.asmAppUpdateLatestVersion);
		final response = await _dio.get(url);
		if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
			return response.data;
		}
		throw Exception('Failed to fetch latest version info');
	}

	Future<Response> downloadApkByFilename(String filename) async {
		final url = ApiUrl.getFullUrl(ApiUrl.asmAppUpdateDownloadByFilename(filename));
		return await _dio.get(url,
			options: Options(responseType: ResponseType.bytes),
		);
	}
}
