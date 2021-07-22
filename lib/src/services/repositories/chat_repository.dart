import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

/// Provides access to Firebase chat data. Singleton, use
/// FirebaseChatCore.instance to aceess methods.
class FirebaseChatCore {
  FirebaseChatCore._privateConstructor() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      firebaseUser = user;
    });
  }

  /// Current logged in user in Firebase. Does not update automatically.
  /// Use [FirebaseAuth.authStateChanges] to listen to the state changes.
  User? firebaseUser = FirebaseAuth.instance.currentUser;

  /// Singleton instance
  static final FirebaseChatCore instance =
      FirebaseChatCore._privateConstructor();

  /// School level database reference
  final ref = FirebaseFirestore.instance
      .collection('customers/lcps/schools')
      .doc('independence');

  /// Creates a chat group room with [users]. Creator is automatically
  /// added to the group. [name] is required and will be used as
  /// a group name. Add an optional [imageUrl] that will be a group avatar
  /// and [metadata] for any additional custom data.
  Future<types.Room> createGroupRoom({
    String? imageUrl,
    Map<String, dynamic>? metadata,
    required String name,
    required List<types.User> users,

    /// Could be classId or clubId
    required String id,

    /// Class or Club
    required String groupType,
  }) async {
    if (firebaseUser == null) return Future.error('User does not exist');

    final currentUser = await fetchUser(firebaseUser!.uid);
    final roomUsers = [currentUser, ...users];

    final room = await ref.collection('chat_rooms').add({
      'createdAt': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl,
      'metadata': metadata,
      'name': name,
      'type': types.RoomType.group.toShortString(),
      'updatedAt': FieldValue.serverTimestamp(),
      'userIds': roomUsers.map((u) => u.id).toList(),
      'userRoles': roomUsers.fold<Map<String, String?>>(
        {},
        (previousValue, element) => {
          ...previousValue,
          element.id: element.role?.toShortString(),
        },
      ),
    });

    return types.Room(
      id: room.id,
      imageUrl: imageUrl,
      metadata: metadata,
      name: name,
      type: types.RoomType.group,
      users: roomUsers,
    );
  }

  /// Creates a direct chat for 2 people. Add [metadata] for any additional
  /// custom data.
  Future<types.Room> createRoom(
    types.User otherUser, {
    Map<String, dynamic>? metadata,

    /// Could be classId or clubId
    required String groupType,

    /// Class or Club
    required String id,
  }) async {
    if (firebaseUser == null) return Future.error('User does not exist');

    final query = await ref
        .collection('chat_rooms')
        .where('userIds', arrayContains: firebaseUser!.uid)
        .get();

    final rooms = await processRoomsQuery(firebaseUser!, query);

    try {
      return rooms.firstWhere((room) {
        if (room.type == types.RoomType.group) return false;

        final userIds = room.users.map((u) => u.id);
        return userIds.contains(firebaseUser!.uid) &&
            userIds.contains(otherUser.id);
      });
    } catch (e) {
      // Do nothing if room does not exist
      // Create a new room instead
    }

    final currentUser = await fetchUser(firebaseUser!.uid);
    final users = [currentUser, otherUser];

    final room = await ref.collection('chat_rooms').add({
      'createdAt': FieldValue.serverTimestamp(),
      'imageUrl': null,
      'metadata': metadata,
      'name': null,
      'type': types.RoomType.direct.toShortString(),
      'updatedAt': FieldValue.serverTimestamp(),
      'userIds': users.map((u) => u.id).toList(),
      'userRoles': null,
    });

    return types.Room(
      id: room.id,
      metadata: metadata,
      type: types.RoomType.direct,
      users: users,
    );
  }

  /// Creates [types.User] in Firebase to store name and avatar used on
  /// rooms list
  Future<void> createUserInFirestore(types.User user) async {
    await ref.collection('students').doc(user.id).update({
      'createdAt': FieldValue.serverTimestamp(),
      'firstName': user.firstName,
      'imageUrl': user.imageUrl,
      'lastName': user.lastName,
      'lastSeen': user.lastSeen,
      'metadata': user.metadata,
      'role': user.role?.toShortString(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Removes [types.User] from `users` collection in Firebase
  Future<void> deleteUserFromFirestore(String userId) async {
    await ref.collection('students').doc(userId).delete();
  }

  /// Returns a stream of messages from Firebase for a given room
  Stream<List<types.Message>> messages(types.Room room,
      {required String groupType, required String id}) {
    return ref
        .collection('chat_rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.fold<List<types.Message>>(
          [],
          (previousValue, element) {
            final data = element.data();
            final author = room.users.firstWhere(
              (u) => u.id == data['authorId'],
              orElse: () => types.User(id: data['authorId'] as String),
            );

            data['author'] = author.toJson();
            data['id'] = element.id;
            try {
              data['createdAt'] = element['createdAt']?.millisecondsSinceEpoch;
              data['updatedAt'] = element['updatedAt']?.millisecondsSinceEpoch;
            } catch (e) {
              // Ignore errors, null values are ok
            }
            data.removeWhere((key, value) => key == 'authorId');
            return [...previousValue, types.Message.fromJson(data)];
          },
        );
      },
    );
  }

  /// Returns a stream of changes in a room from Firebase
  Stream<types.Room> room(String roomId) {
    if (firebaseUser == null) return const Stream.empty();

    return ref
        .collection('chat_rooms')
        .doc(roomId)
        .snapshots()
        .asyncMap((doc) => processRoomDocument(doc, firebaseUser!));
  }

  /// Returns a stream of rooms from Firebase. Only rooms where current
  /// logged in user exist are returned. [orderByUpdatedAt] is used in case
  /// you want to have last modified rooms on top, there are a couple
  /// of things you will need to do though:
  /// 1) Make sure `updatedAt` exists on all rooms
  /// 2) Write a Cloud Function which will update `updatedAt` of the room
  /// when the room changes or new messages come in
  /// 3) Create an Index (Firestore Database -> Indexes tab) where collection ID
  /// is `rooms`, field indexed are `userIds` (type Arrays) and `updatedAt`
  /// (type Descending), query scope is `Collection`
  Stream<List<types.Room>> rooms({bool orderByUpdatedAt = false}) {
    if (firebaseUser == null) return const Stream.empty();

    final collection = orderByUpdatedAt
        ? ref
            .collection('chat_rooms')
            .where('userIds', arrayContains: firebaseUser!.uid)
            .orderBy('updatedAt', descending: true)
        : ref
            .collection('chat_rooms')
            .where('userIds', arrayContains: firebaseUser!.uid);

    return collection
        .snapshots()
        .asyncMap((query) => processRoomsQuery(firebaseUser!, query));
  }

  /// Sends a message to the Firestore. Accepts any partial message and a
  /// room ID. If arbitraty data is provided in the [partialMessage]
  /// does nothing.
  void sendMessage(dynamic partialMessage, String roomId) async {
    if (firebaseUser == null) return;

    types.Message? message;

    if (partialMessage is types.PartialFile) {
      message = types.FileMessage.fromPartial(
        author: types.User(id: firebaseUser!.uid),
        id: '',
        partialFile: partialMessage,
      );
    } else if (partialMessage is types.PartialImage) {
      message = types.ImageMessage.fromPartial(
        author: types.User(id: firebaseUser!.uid),
        id: '',
        partialImage: partialMessage,
      );
    } else if (partialMessage is types.PartialText) {
      message = types.TextMessage.fromPartial(
        author: types.User(id: firebaseUser!.uid),
        id: '',
        partialText: partialMessage,
      );
    }

    if (message != null) {
      final messageMap = message.toJson();
      messageMap.removeWhere((key, value) => key == 'author' || key == 'id');
      messageMap['authorId'] = firebaseUser!.uid;
      messageMap['createdAt'] = FieldValue.serverTimestamp();
      messageMap['updatedAt'] = FieldValue.serverTimestamp();

      await ref.collection('chat_rooms/$roomId/messages').add(messageMap);
    }
  }

  /// Updates a message in the Firestore. Accepts any message and a
  /// room ID. Message will probably be taken from the [messages] stream.
  void updateMessage(types.Message message, String roomId) async {
    if (firebaseUser == null) return;
    if (message.author.id != firebaseUser!.uid) return;

    final messageMap = message.toJson();
    messageMap.removeWhere((key, value) => key == 'id' || key == 'createdAt');
    messageMap['updatedAt'] = FieldValue.serverTimestamp();

    await ref
        .collection('chat_rooms/$roomId/messages')
        .doc(message.id)
        .update(messageMap);
  }

  /// Returns a stream of all users from Firebase
  Stream<List<types.User>> students() {
    if (firebaseUser == null) return const Stream.empty();
    return ref.collection('students').snapshots().map(
          (snapshot) => snapshot.docs.fold<List<types.User>>(
            [],
            (previousValue, element) {
              if (firebaseUser!.uid == element.id) return previousValue;

              return [...previousValue, processUserDocument(element)];
            },
          ),
        );
  }

  Stream<List<types.User>> teachers() {
    if (firebaseUser == null) return const Stream.empty();
    return ref
        .collection('staff')
        .where('role', isEqualTo: 'Teacher')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.fold<List<types.User>>(
            [],
            (previousValue, element) {
              if (firebaseUser!.uid == element.id) return previousValue;

              return [...previousValue, processUserDocument(element)];
            },
          ),
        );
  }
}

/// Fetches user from Firebase and returns a promise
Future<types.User> fetchUser(String userId, {types.Role? role}) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  return processUserDocument(doc, role: role);
}

/// Returns a list of [types.Room] created from Firebase query.
/// If room has 2 participants, sets correct room name and image.
Future<List<types.Room>> processRoomsQuery(
  User firebaseUser,
  QuerySnapshot<Map<String, dynamic>> query,
) async {
  final futures = query.docs.map(
    (doc) => processRoomDocument(doc, firebaseUser),
  );

  return await Future.wait(futures);
}

/// Returns a [types.Room] created from Firebase document
Future<types.Room> processRoomDocument(
  DocumentSnapshot<Map<String, dynamic>> doc,
  User firebaseUser,
) async {
  final createdAt = doc.data()?['createdAt'] as Timestamp?;
  var imageUrl = doc.data()?['imageUrl'] as String?;
  final metadata = doc.data()?['metadata'] as Map<String, dynamic>?;
  var name = doc.data()?['name'] as String?;
  final type = doc.data()!['type'] as String;
  final updatedAt = doc.data()?['updatedAt'] as Timestamp?;
  final userIds = doc.data()!['userIds'] as List<dynamic>;
  final userRoles = doc.data()?['userRoles'] as Map<String, dynamic>?;

  final users = await Future.wait(
    userIds.map(
      (userId) => fetchUser(
        userId as String,
        role: types.getRoleFromString(userRoles?[userId] as String?),
      ),
    ),
  );

  if (type == types.RoomType.direct.toShortString()) {
    try {
      final otherUser = users.firstWhere(
        (u) => u.id != firebaseUser.uid,
      );

      imageUrl = otherUser.imageUrl;
      name = '${otherUser.firstName ?? ''} ${otherUser.lastName ?? ''}'.trim();
    } catch (e) {
      // Do nothing if other user is not found, because he should be found.
      // Consider falling back to some default values.
    }
  }

  final room = types.Room(
    createdAt: createdAt?.millisecondsSinceEpoch,
    id: doc.id,
    imageUrl: imageUrl,
    metadata: metadata,
    name: name,
    type: types.getRoomTypeFromString(type),
    updatedAt: updatedAt?.millisecondsSinceEpoch,
    users: users,
  );

  return room;
}

/// Returns a [types.User] created from Firebase document
types.User processUserDocument(
  DocumentSnapshot<Map<String, dynamic>> doc, {
  types.Role? role,
}) {
  final createdAt = doc.data()?['createdAt'] as Timestamp?;
  final firstName = doc.data()?['firstName'] as String?;
  final imageUrl = doc.data()?['imageUrl'] as String?;
  final lastName = doc.data()?['lastName'] as String?;
  final lastSeen = doc.data()?['lastSeen'] as Timestamp?;
  final metadata = doc.data()?['metadata'] as Map<String, dynamic>?;
  final roleString = doc.data()?['role'] as String?;
  final updatedAt = doc.data()?['updatedAt'] as Timestamp?;

  final user = types.User(
    createdAt: createdAt?.millisecondsSinceEpoch,
    firstName: firstName,
    id: doc.id,
    imageUrl: imageUrl,
    lastName: lastName,
    lastSeen: lastSeen?.millisecondsSinceEpoch,
    metadata: metadata,
    role: role ?? types.getRoleFromString(roleString),
    updatedAt: updatedAt?.millisecondsSinceEpoch,
  );

  return user;
}

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
