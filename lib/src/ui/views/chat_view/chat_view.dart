import 'dart:io';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kounslr/src/config/encryption_contract.dart';
import 'package:kounslr/src/config/themes/chat_theme.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:kounslr/src/models/room.dart';
import 'package:kounslr/src/providers/chat_providers/room_messages_stream_provider.dart';
import 'package:kounslr/src/providers/chat_providers/room_stream_provider.dart';
import 'package:kounslr/src/services/repositories/chat_repository/chat_encryption_service.dart';
import 'package:kounslr/src/services/repositories/chat_repository/chat_repository.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/chat_view/components/chat_view_header.dart';

class ChatView extends StatefulWidget {
  const ChatView(this.room);

  final Room room;

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool _isAttachmentUploading = false;

  // ignore: unused_element
  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Container(
              decoration: ShapeDecoration(
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Theme.of(context).colorScheme.onSecondary
                        : Theme.of(context).canvasColor,
                shape: SquircleBorder(
                  radius: BorderRadius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleImageSelection();
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Photo'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleFileSelection();
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('File'),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path;
      final file = File(filePath ?? '');

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath ?? ''),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        ChatRepository.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
        // ignore: unused_catch_clause
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        ChatRepository.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
        // ignore: unused_catch_clause
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        final client = http.Client();
        final request = await client.get(Uri.parse(message.uri));
        final bytes = request.bodyBytes;
        final documentsDir = (await getApplicationDocumentsDirectory()).path;
        localPath = '$documentsDir/${message.name}';

        if (!File(localPath).existsSync()) {
          final file = File(localPath);
          await file.writeAsBytes(bytes);
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
      types.TextMessage message, types.PreviewData previewData) {
    final updatedMessage = message.copyWith(previewData: previewData);

    ChatRepository.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    ChatRepository.instance.sendMessage(
      message,
      widget.room.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      padding: EdgeInsets.zero,
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        ChatViewHeader(widget.room),
        _body(context),
      ],
    );
  }

  Widget _body(BuildContext context) {
    IEncryption textMessageSut;
    return Consumer(
      builder: (context, watch, child) {
        currentChatRoomId = widget.room.id;
        currentChatRoom = widget.room;

        final encryptor = enc.Encrypter(enc.AES(enc.Key.fromLength(32)));
        textMessageSut = ChatEncryptionService(encryptor);
        final chatRoomRepo = watch(roomStreamProvider);
        final chatRoomMessagesRepo = watch(roomMessagesStreamProvider);

        types.PartialText encryptTextMessage(String message) {
          return types.PartialText(text: textMessageSut.encrypt(message));
        }

        return chatRoomRepo.when(
          error: (e, s) {
            return SomethingWentWrong();
          },
          loading: () => Expanded(child: Loading()),
          data: (room) {
            return chatRoomMessagesRepo.when(
              error: (e, s) {
                print(e);
                print(s);
                return SomethingWentWrong();
              },
              loading: () => Expanded(child: Loading()),
              data: (messages) {
                return Expanded(
                  child: Chat(
                    isAttachmentUploading: _isAttachmentUploading,
                    onMessageTap: _handleMessageTap,
                    onPreviewDataFetched: _handlePreviewDataFetched,
                    messages: messages,
                    user:
                        types.User(id: FirebaseAuth.instance.currentUser!.uid),
                    theme: chatTheme(context),
                    onSendPressed: (text) {
                      _handleSendPressed(encryptTextMessage(text.text));
                    },
                    // onAttachmentPressed: () => _handleAttachmentPressed(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
