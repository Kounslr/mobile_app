import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:kounslr/src/config/encryption_contract.dart';
import 'package:kounslr/src/models/room.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/services/repositories/chat_repository/chat_encryption_service.dart';
import 'package:uuid/uuid.dart';

/// Provides access to Firebase chat data. Singleton, use
/// FirebaseChatCore.instance to aceess methods.
class ChatRepository {
  ChatRepository._privateConstructor() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      firebaseUser = user;
    });
  }

  /// Current logged in user in Firebase. Does not update automatically.
  /// Use [FirebaseAuth.authStateChanges] to listen to the state changes.
  User? firebaseUser = FirebaseAuth.instance.currentUser;

  /// Singleton instance
  static final ChatRepository instance = ChatRepository._privateConstructor();

  /// School level database reference
  final ref = FirebaseFirestore.instance
      .collection('customers/lcps/schools')
      .doc('independence');

  /// Creates a chat group room with [users]. Creator is automatically
  /// added to the group. [name] is required and will be used as
  /// a group name. Add an optional [imageUrl] that will be a group avatar
  /// and [metadata] for any additional custom data.
  Future<Room> createGroupRoom({
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

    final currentUser = await fetchStudent(firebaseUser!.uid);
    final roomUsers = [currentUser.toUser(), ...users];

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

    return Room(
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
  Future<Room> createRoom(
    Student otherUser, {

    /// Could be classId or clubId
    String? groupType,

    /// Class or Club
    String? groupId,
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
      DoNothingAction();
    }

    final currentUser = await fetchStudent(firebaseUser!.uid);
    final users = [currentUser.toUser(), otherUser.toUser()];

    final room = await ref.collection('chat_rooms').add({
      'createdAt': FieldValue.serverTimestamp(),
      'imageUrl': null,
      'name': null,
      'type': types.RoomType.direct.toShortString(),
      'updatedAt': FieldValue.serverTimestamp(),
      'userIds': users.map((u) => u.id).toList(),
      'userRoles': null,
    });

    return Room(
      id: room.id,
      type: types.RoomType.direct,
      users: users,
    );
  }

  /// Creates [types.User] in Firebase to store name and avatar used on
  /// rooms list
  Future<void> createUserInFirestore(types.User user) async {
    await ref.collection('students').doc(user.id).update({
      'createdAt': FieldValue.serverTimestamp(),
      'imageUrl': user.imageUrl,
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
  Stream<List<types.Message>> messages(Room room,
      {String? groupType, String? id}) {
    final encryptor = enc.Encrypter(enc.AES(enc.Key.fromLength(32)));
    IEncryption textMessageSut = ChatEncryptionService(encryptor);

    return ref
        .collection('chat_rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.fold<List<types.Message>>(
          [],
          (previousValue, element) {
            final newPreviousValues = <types.TextMessage>[];
            final data = element.data();
            final author = room.users.firstWhere(
              (u) => u.id == data['authorId'],
              orElse: () => Student(id: data['authorId'] as String).toUser(),
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

            for (int i = 0; i < previousValue.length; i++) {
              var item = previousValue[i];
              if (item.type == types.MessageType.text) {
                final encryptedMessage =
                    types.TextMessage.fromJson(item.toJson());

                newPreviousValues.add(encryptedMessage);
              }
            }

            if (data['type'] == 'text') {
              var encryptedMessage = types.TextMessage.fromJson(data);

              var newDecryptedMessage = types.TextMessage(
                id: encryptedMessage.id,
                author: encryptedMessage.author,
                previewData: encryptedMessage.previewData,
                createdAt: encryptedMessage.createdAt,
                metadata: encryptedMessage.metadata,
                status: encryptedMessage.status,
                roomId: encryptedMessage.roomId,
                updatedAt: encryptedMessage.updatedAt,
                text: textMessageSut.decrypt(encryptedMessage.text),
              );

              return [...newPreviousValues, newDecryptedMessage];
            }

            return [...newPreviousValues];
          },
        );
      },
    );
  }

  /// Returns a stream of changes in a room from Firebase
  Stream<Room> room(String roomId) {
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
  Stream<List<Room>> rooms({bool orderByUpdatedAt = false}) {
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

    final messageId = Uuid().v4();

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

      await ref
          .collection('chat_rooms/$roomId/messages')
          .doc(messageId)
          .set(messageMap);
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
Future<Student> fetchStudent(String id, {types.Role? role}) async {
  final ref = FirebaseFirestore.instance
      .collection('customers/lcps/schools')
      .doc('independence');

  final doc = await ref.collection('students').doc(id).get();

  return processStudentDocument(doc, role: role);
}

Future<types.User> fetchUser(String id, {types.Role? role}) async {
  final ref = FirebaseFirestore.instance
      .collection('customers/lcps/schools')
      .doc('independence');

  final doc = await ref.collection('students').doc(id).get();

  return processUserDocument(doc, role: role);
}

/// Returns a list of [Room] created from Firebase query.
/// If room has 2 participants, sets correct room name and image.
Future<List<Room>> processRoomsQuery(
  User firebaseUser,
  QuerySnapshot<Map<String, dynamic>> query,
) async {
  final futures = query.docs.map(
    (doc) => processRoomDocument(doc, firebaseUser),
  );

  return await Future.wait(futures);
}

/// Returns a [Room] created from Firebase document
Future<Room> processRoomDocument(
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
      name = name!.trim();
    } catch (e) {
      // Do nothing if other user is not found, because he should be found.
      // Consider falling back to some default values.
    }
  }

  final room = Room(
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
  final name = doc.data()?['name'] as String?;
  final photo = doc.data()?['imageUrl'] as String?;

  final user = Student(
    id: doc.id,
    photo: photo,
    name: name,
  );

  return user.toUser();
}

Student processStudentDocument(
  DocumentSnapshot<Map<String, dynamic>> doc, {
  types.Role? role,
}) {
  final name = doc.data()?['name'] as String?;
  final photo = doc.data()?['imageUrl'] as String?;

  final user = Student(
    id: doc.id,
    photo: photo,
    name: name,
  );

  return user;
}
