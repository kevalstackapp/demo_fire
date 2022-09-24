import 'dart:convert';

List<AudioApi> audioApiFromJson(String str) => List<AudioApi>.from(json.decode(str).map((x) => AudioApi.fromJson(x)));

String audioApiToJson(List<AudioApi> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AudioApi {
  AudioApi({
    this.id,
    this.type,
    this.photoUrl,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.count,
  });

  String? id;
  String? type;
  String? photoUrl;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? count;

  factory AudioApi.fromJson(Map<String, dynamic> json) => AudioApi(
    id: json["_id"],
    type: json["type"],
    photoUrl: json["photoUrl"],
    name: json["name"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    count: json["count"],
  );

  Map  toJson() => {
    "_id": id,
    "type": type,
    "photoUrl": photoUrl,
    "name": name,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "count": count,
  };
}
