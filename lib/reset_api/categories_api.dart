// To parse this JSON data, do
//
//     final categoriesapi = categoriesapiFromJson(jsonString);

import 'dart:convert';

  Categoriesapi categoriesapiFromJson(String str) => Categoriesapi.fromJson(json.decode(str));

String categoriesapiToJson(Categoriesapi data) => json.encode(data.toJson());

class Categoriesapi {
  Categoriesapi({
    this.data,
  });

  Data? data;

  factory Categoriesapi.fromJson(Map<String, dynamic> json) => Categoriesapi(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.homeCategoryList,
  });

  List<HomeCategoryList>? homeCategoryList;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    homeCategoryList: List<HomeCategoryList>.from(json["home_category_list"].map((x) => HomeCategoryList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "home_category_list": List<dynamic>.from(homeCategoryList!.map((x) => x.toJson())),
  };
}

class HomeCategoryList {
  HomeCategoryList({
    this.id,
    this.idList,
  });

  String? id;
  List<IdList>? idList;

  factory HomeCategoryList.fromJson(Map<String, dynamic> json) => HomeCategoryList(
    id: json["_id"],
    idList: List<IdList>.from(json["idList"].map((x) => IdList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "idList": List<dynamic>.from(idList!.map((x) => x.toJson())),
  };
}

class IdList {
  IdList({
    this.id,
    this.audioBookDpUrl,
    this.name,
    this.tags,
    this.category,
    this.author,
    this.publisher,
    this.description,
    this.reader,
    this.files,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isLock,
    this.isNewAudiobook,
    this.authorDpUrl,
    this.language,
    this.publisherDpUrl,
  });

  String? id;
  String? audioBookDpUrl;
  String? name;
  String? tags;
  Category? category;
  Author? author;
  Publisher? publisher;
  String? description;
  Reader? reader;
  List<FileElement>? files;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? isLock;
  bool? isNewAudiobook;
  String? authorDpUrl;
  String? language;
  String? publisherDpUrl;

  factory IdList.fromJson(Map<String, dynamic> json) => IdList(
    id: json["_id"],
    audioBookDpUrl: json["audioBookDpUrl"],
    name: json["name"],
    tags: json["tags"],
    category: Category.fromJson(json["category"]),
    author: authorValues.map![json["author"]],
    publisher: publisherValues.map![json["publisher"]],
    description: json["description"],
    reader: readerValues.map![json["reader"]],
    files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    isLock: json["isLock"],
    isNewAudiobook: json["isNewAudiobook"],
    authorDpUrl: json["authorDpUrl"],
    language: json["language"] == null ? null : json["language"],
    publisherDpUrl: json["publisherDpUrl"] == null ? null : json["publisherDpUrl"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "audioBookDpUrl": audioBookDpUrl,
    "name": name,
    "tags": tags,
    "category": category!.toJson(),
    "author": authorValues.reverse![author],
    "publisher": publisherValues.reverse![publisher],
    "description": description,
    "reader": readerValues.reverse![reader],
    "files": List<dynamic>.from(files!.map((x) => x.toJson())),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "isLock": isLock,
    "isNewAudiobook": isNewAudiobook,
    "authorDpUrl": authorDpUrl,
    "language": language == null ? null : language,
    "publisherDpUrl": publisherDpUrl == null ? null : publisherDpUrl,
  };
}

enum Author { EMPTY, NILKANTH_DESHMUKH }

final authorValues = EnumValues({
  "नीलकंठ देशमुख": Author.EMPTY,
  "nilkanth deshmukh": Author.NILKANTH_DESHMUKH
});

class Category {
  Category({
    this.id,
    this.type,
    this.photoUrl,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.count,
  });

  CategoryId? id;
  Type? type;
  String? photoUrl;
  Name? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? count;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: categoryIdValues.map![json["_id"]],
    type: typeValues.map![json["type"]],
    photoUrl: json["photoUrl"],
    name: nameValues.map![json["name"]],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "_id": categoryIdValues.reverse![id],
    "type": typeValues.reverse![type],
    "photoUrl": photoUrl,
    "name": nameValues.reverse![name],
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "count": count,
  };
}

enum CategoryId { THE_6159_A2612389_FEA5_CA37612_E, THE_61462_C3641_F2597_D7_C40439_A }

final categoryIdValues = EnumValues({
  "61462c3641f2597d7c40439a": CategoryId.THE_61462_C3641_F2597_D7_C40439_A,
  "6159a2612389fea5ca37612e": CategoryId.THE_6159_A2612389_FEA5_CA37612_E
});

enum Name { EMPTY, NAME }

final nameValues = EnumValues({
  "कार्यकर्ता": Name.EMPTY,
  "विविध": Name.NAME
});

enum Type { AUDIOBOOK }

final typeValues = EnumValues({
  "audiobook": Type.AUDIOBOOK
});

class FileElement {
  FileElement({
    this.fileType,
    this.id,
    this.title,
    this.playCount,
    this.seconds,
    this.fileUrl,
  });

  Type? fileType;
  FileId? id;
  Title? title;
  int? playCount;
  int? seconds;
  String? fileUrl;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    fileType: typeValues.map![json["fileType"]],
    id: fileIdValues.map![json["_id"]],
    title: titleValues.map![json["title"]],
    playCount: json["playCount"],
    seconds: json["seconds"],
    fileUrl: json["fileUrl"],
  );

  Map<String, dynamic> toJson() => {
    "fileType": typeValues.reverse![fileType],
    "_id": fileIdValues.reverse![id],
    "title": titleValues.reverse![title],
    "playCount": playCount,
    "seconds": seconds,
    "fileUrl": fileUrl,
  };
}

enum FileId { THE_62_F4_DFDC68_D00_A721_B331_CBE, THE_62_F4_DFDC68_D00_A721_B331_CBF }

final fileIdValues = EnumValues({
  "62f4dfdc68d00a721b331cbe": FileId.THE_62_F4_DFDC68_D00_A721_B331_CBE,
  "62f4dfdc68d00a721b331cbf": FileId.THE_62_F4_DFDC68_D00_A721_B331_CBF
});

enum Title { EMPTY, TITLE }

final titleValues = EnumValues({
  "आभार - प्रदर्शन": Title.EMPTY,
  "प्रस्तावना": Title.TITLE
});

enum Publisher { EMPTY }

final publisherValues = EnumValues({
  "सुरुचि प्रकाशन": Publisher.EMPTY
});

enum Reader { THE_630_D8_B08_A0295361234_DE3_C7 }

final readerValues = EnumValues({
  "630d8b08a0295361234de3c7": Reader.THE_630_D8_B08_A0295361234_DE3_C7
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
