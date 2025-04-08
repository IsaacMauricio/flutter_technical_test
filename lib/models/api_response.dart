import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

class ApiResponse<T> {
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  T? data;
  Support? support;

  ApiResponse({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    this.data,
    this.support,
  });

  factory ApiResponse.transform(
    Map<String, dynamic> data,
    T? Function(dynamic) transformer,
  ) {
    return ApiResponse(
      page: data['page'],
      perPage: data['per_page'],
      total: data['total'],
      totalPages: data['total_pages'],
      data: transformer(data['data']),
      support: Support.fromJson(data['support']),
    );
  }
}

@JsonSerializable()
class Support {
  @JsonKey(name: 'url')
  String? url;
  @JsonKey(name: 'text')
  String? text;

  Support({this.url, this.text});

  factory Support.fromJson(Map<String, dynamic> json) =>
      _$SupportFromJson(json);

  Map<String, dynamic> toJson() => _$SupportToJson(this);
}
