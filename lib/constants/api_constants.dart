class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://128.199.98.121/admin/Api';

  // Headers
  static const Map<String, String> headers = {
    'Authorization': '4ccda7514adc0f13595a585205fb9761',
    'Content-Type': 'application/json',
    'Cookie': 'ci_session=lvtdi30a4rvo6rn923nl59h1qn9ro2af',
  };

  // API Endpoints
  static const String getDistributorsEndpoint = '/get_retailer_distributor_master/1';
  static const String addDistributorEndpoint = '/add_distributor';
}
