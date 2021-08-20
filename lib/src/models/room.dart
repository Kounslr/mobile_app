import 'package:canton_design_system/canton_design_system.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

/// A class that represents a room where 2 or more participants can chat
@immutable
class Room extends Equatable {
  /// Creates a [Room]
  const Room({
    this.createdAt,
    required this.id,
    this.imageUrl,
    this.lastMessages,
    this.metadata,
    this.name,
    required this.type,
    this.updatedAt,
    required this.users,
    this.groupType,
    this.groupId,
  });

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'],
      createdAt: map['createdAt'],
      imageUrl: map['imageUrl'],
      lastMessages:
          (map['lastMessages']).map((e) => types.Message.fromJson(e)).toList(),
      metadata: map['metadata'],
      name: map['name'],
      type: types.getRoomTypeFromString(map['type']),
      updatedAt: map['updatedAt'],
      users: (map['users']).map((e) => types.User.fromJson(e)).toList(),
      groupType: map['groupType'],
      groupId: map['groupId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'id': id,
      'imageUrl': imageUrl,
      'lastMessages': lastMessages?.map((e) => e.toJson()).toList(),
      'metadata': metadata,
      'name': name,
      'type': type.toShortString(),
      'updatedAt': updatedAt,
      'users': users.map((e) => e.toJson()).toList(),
    };
  }

  factory Room.fromJson(String source) {
    return Room.fromMap(json.decode(source));
  }

  /// Converts room to the map representation, encodable to JSON.
  String toJson() => json.encode(toMap());

  /// Creates a copy of the room with an updated data.
  /// [imageUrl], [name] and [updatedAt] with null values will nullify existing values
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  /// [type] and [users] with null values will be overwritten by previous values.
  Room copyWith({
    String? imageUrl,
    Map<String, dynamic>? metadata,
    String? name,
    types.RoomType? type,
    int? updatedAt,
    List<types.User>? users,
  }) {
    return Room(
      id: id,
      imageUrl: imageUrl,
      lastMessages: lastMessages,
      metadata: metadata == null
          ? null
          : {
              ...this.metadata ?? {},
              ...metadata,
            },
      name: name,
      type: type ?? this.type,
      updatedAt: updatedAt,
      users: users ?? this.users,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props => [
        createdAt,
        id,
        imageUrl,
        lastMessages,
        metadata,
        name,
        type,
        updatedAt,
        users
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Room &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.name == name &&
        other.type == type &&
        other.imageUrl == imageUrl &&
        other.metadata == metadata &&
        other.updatedAt == updatedAt &&
        listEquals(other.users, users) &&
        listEquals(other.lastMessages, lastMessages);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        name.hashCode ^
        type.hashCode ^
        imageUrl.hashCode ^
        metadata.hashCode ^
        updatedAt.hashCode ^
        users.hashCode ^
        lastMessages.hashCode;
  }

  /// Created room timestamp, in ms
  final int? createdAt;

  /// Room's unique ID
  final String id;

  /// Room's image. In case of the [RoomType.direct] - avatar of the second person,
  /// otherwise a custom image [RoomType.group].
  final String? imageUrl;

  /// List of last messages this room has received
  final List<types.Message>? lastMessages;

  /// [RoomType]
  final types.RoomType type;

  /// Additional custom metadata or attributes related to the room
  final Map<String, dynamic>? metadata;

  /// Room's name. In case of the [RoomType.direct] - name of the second person,
  /// otherwise a custom name [RoomType.group].
  final String? name;

  /// Updated room timestamp, in ms
  final int? updatedAt;

  /// List of users which are in the room
  final List<types.User> users;

  final String? groupType;

  final String? groupId;
}
