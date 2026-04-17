import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/task.dart';

class ApiService {
  final Dio _dio = Dio();

  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  final String token = dotenv.env['API_TOKEN'] ?? '';

  ApiService() {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';
    _dio.options.validateStatus = (status) => status! < 500;
  }

  Future<List<Task>> getTasks() async {
    try {
      final formData = FormData.fromMap({
        'period_start': '2026-04-01',
        'period_end': '2026-04-30',
        'period_key': 'month',
        'requested_mo_id': '42',
        'behaviour_key': 'task,kpi_task',
        'with_result': 'false',
        'response_fields': 'name,indicator_to_mo_id,parent_id,order',
        'auth_user_id': '40',
      });

      final response = await _dio.post('$baseUrl/get_mo_indicators', data: formData);

      // EXTRACTION CORRECTE DU JSON
      final data = response.data;
      if (data is Map && data['DATA'] != null && data['DATA']['rows'] != null) {
        final rows = data['DATA']['rows'] as List;
        return rows.map((e) => Task.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> saveTask({
    required int indicatorToMoId,
    required int newParentId,
    required int newOrder,
  }) async {
    try {
      final formData = FormData();
      formData.fields.addAll([
        MapEntry('period_start', '2025-09-01'),
        MapEntry('period_end', '2025-09-30'),
        MapEntry('period_key', 'month'),
        MapEntry('indicator_to_mo_id', indicatorToMoId.toString()),
        MapEntry('auth_user_id', '40'),
        MapEntry('field_name', 'parent_id'),
        MapEntry('field_value', newParentId.toString()),
        MapEntry('field_name', 'order'),
        MapEntry('field_value', newOrder.toString()),
      ]);

      final response = await _dio.post('$baseUrl/save_indicator_instance_field', data: formData);
      return response.statusCode == 200 || response.data['STATUS'] == 'OK';
    } catch (e) {
      return false;
    }
  }
}