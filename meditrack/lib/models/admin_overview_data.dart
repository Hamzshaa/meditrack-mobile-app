import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meditrack/utils/date_utils.dart';

part 'admin_overview_data.g.dart';

@JsonSerializable(explicitToJson: true)
class UserRole extends Equatable {
  final String role;
  final int count;
  const UserRole({required this.role, required this.count});
  factory UserRole.fromJson(Map<String, dynamic> json) =>
      _$UserRoleFromJson(json);
  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
  @override
  List<Object?> get props => [role, count];
}

@JsonSerializable(explicitToJson: true)
class UserProfile extends Equatable {
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String email;
  final String role;
  const UserProfile(
      {required this.userId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.role});
  String get fullName => '$firstName $lastName';
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
  @override
  List<Object?> get props => [userId, firstName, lastName, email, role];
}

@JsonSerializable(explicitToJson: true)
class RecentComment extends Equatable {
  @JsonKey(name: 'comment_id')
  final int commentId;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String email;
  final String comment;
  @JsonKey(
      name: 'created_at',
      fromJson: dateTimeFromStringNullable,
      toJson: dateTimeToStringNullable)
  final DateTime? createdAt;
  const RecentComment(
      {required this.commentId,
      required this.fullName,
      required this.email,
      required this.comment,
      this.createdAt});
  factory RecentComment.fromJson(Map<String, dynamic> json) =>
      _$RecentCommentFromJson(json);
  Map<String, dynamic> toJson() => _$RecentCommentToJson(this);
  @override
  List<Object?> get props => [commentId, fullName, email, comment, createdAt];
}

@JsonSerializable(explicitToJson: true)
class AdminOverviewData extends Equatable {
  @JsonKey(defaultValue: [])
  final List<UserRole> userRoles;

  @JsonKey(name: 'total_comments')
  final int totalComments;

  @JsonKey(name: 'total_pharmacies')
  final int totalPharmacies;

  final UserProfile? userProfile;

  @JsonKey(defaultValue: [])
  final List<RecentComment> recentComments;

  const AdminOverviewData({
    required this.userRoles,
    required this.totalComments,
    required this.totalPharmacies,
    this.userProfile,
    required this.recentComments,
  });

  factory AdminOverviewData.fromJson(Map<String, dynamic> json) =>
      _$AdminOverviewDataFromJson(json);

  Map<String, dynamic> toJson() => _$AdminOverviewDataToJson(this);

  @override
  List<Object?> get props => [
        userRoles,
        totalComments,
        totalPharmacies,
        userProfile,
        recentComments,
      ];
}
