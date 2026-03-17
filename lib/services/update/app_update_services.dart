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

	Future<Response> downloadLatestApk() async {
		final url = ApiUrl.getFullUrl(ApiUrl.asmAppUpdateDownloadLatest);
		return await _dio.get(url,
			options: Options(responseType: ResponseType.bytes),
		);
	}

	Future<List<int>> getAvailableVersions() async {
		final url = ApiUrl.getFullUrl('/asm-app-updates/versions');
		final response = await _dio.get(url);
		if (response.statusCode == 200 && response.data is Map) {
			final versions = response.data['versions'];
			if (versions is List) {
				return versions.cast<int>();
			}
		}
		throw Exception('Failed to fetch versions');
	}
}
