import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'user.g.dart';

@Entity()
@JsonSerializable()
class User {
  @Id()
  int? iid = 0;
  @Unique(onConflict: ConflictStrategy.replace)
  int? id;
  String? email;
  @JsonKey(name: 'first_name')
  String? firstName;
  @JsonKey(name: 'last_name')
  String? lastName;
  String? avatar;

  User({
    this.iid,
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
