import 'dart:convert';

class ZipCodeResult {
  String districtName;
  String districtUrl;

  ZipCodeResult({
    this.districtName,
    this.districtUrl,
  });

  ZipCodeResult copyWith({
    String districtName,
    String districtUrl,
  }) {
    return ZipCodeResult(
      districtName: districtName ?? this.districtName,
      districtUrl: districtUrl ?? this.districtUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'districtName': districtName,
      'districtUrl': districtUrl,
    };
  }

  factory ZipCodeResult.fromMap(Map<String, dynamic> map) {
    return ZipCodeResult(
      districtName: map['districtName'],
      districtUrl: map['districtUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ZipCodeResult.fromJson(String source) =>
      ZipCodeResult.fromMap(json.decode(source));

  @override
  String toString() =>
      'ZipCodeResult(districtName: $districtName, districtUrl: $districtUrl)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ZipCodeResult &&
        other.districtName == districtName &&
        other.districtUrl == districtUrl;
  }

  @override
  int get hashCode => districtName.hashCode ^ districtUrl.hashCode;
}
