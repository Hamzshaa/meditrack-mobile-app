// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRole _$UserRoleFromJson(Map<String, dynamic> json) => UserRole(
      role: json['role'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$UserRoleToJson(UserRole instance) => <String, dynamic>{
      'role': instance.role,
      'count': instance.count,
    };

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      userId: (json['user_id'] as num).toInt(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'role': instance.role,
    };

RecentComment _$RecentCommentFromJson(Map<String, dynamic> json) =>
    RecentComment(
      commentId: (json['comment_id'] as num).toInt(),
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      comment: json['comment'] as String,
      createdAt: dateTimeFromStringNullable(json['created_at'] as String?),
    );

Map<String, dynamic> _$RecentCommentToJson(RecentComment instance) =>
    <String, dynamic>{
      'comment_id': instance.commentId,
      'full_name': instance.fullName,
      'email': instance.email,
      'comment': instance.comment,
      'created_at': dateTimeToStringNullable(instance.createdAt),
    };

AdminOverviewData _$AdminOverviewDataFromJson(Map<String, dynamic> json) =>
    AdminOverviewData(
      userRoles: (json['userRoles'] as List<dynamic>?)
              ?.map((e) => UserRole.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalComments: (json['total_comments'] as num).toInt(),
      totalPharmacies: (json['total_pharmacies'] as num).toInt(),
      userProfile: json['userProfile'] == null
          ? null
          : UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
      recentComments: (json['recentComments'] as List<dynamic>?)
              ?.map((e) => RecentComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$AdminOverviewDataToJson(AdminOverviewData instance) =>
    <String, dynamic>{
      'userRoles': instance.userRoles.map((e) => e.toJson()).toList(),
      'total_comments': instance.totalComments,
      'total_pharmacies': instance.totalPharmacies,
      'userProfile': instance.userProfile?.toJson(),
      'recentComments': instance.recentComments.map((e) => e.toJson()).toList(),
    };
