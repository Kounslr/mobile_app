import 'dart:io';

import 'package:canton_design_system/canton_design_system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kounslr/src/models/room.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kounslr/src/services/repositories/chat_repository.dart';
import 'package:kounslr/src/ui/views/chat_view/components/chat_view_header.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatView extends StatefulWidget {
  const ChatView(this.room);

  final Room room;

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool _isAttachmentUploading = false;

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

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
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

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
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

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
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
        ChatViewHeader(room: widget.room),
        _body(context),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return StreamBuilder<Room>(
      initialData: widget.room,
      stream: FirebaseChatCore.instance.room(widget.room.id),
      builder: (context, snapshot) {
        return StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) {
              return Expanded(
                child: Chat(
                  isAttachmentUploading: _isAttachmentUploading,
                  onMessageTap: _handleMessageTap,
                  onPreviewDataFetched: _handlePreviewDataFetched,
                  messages: snapshot.data ?? [],
                  user: types.User(id: FirebaseAuth.instance.currentUser!.uid),
                  theme: DefaultChatTheme(
                    primaryColor: Theme.of(context).primaryColor,
                    inputBackgroundColor: Theme.of(context).canvasColor,
                    inputTextColor: Theme.of(context).colorScheme.primary,
                    inputBorderRadius: BorderRadius.circular(35),
                    messageBorderRadius: 35,
                    dateDividerTextStyle: const TextStyle(
                      color: NEUTRAL_2,
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.333,
                    ),
                  ),
                  onSendPressed: (text) => _handleSendPressed(text),
                  onAttachmentPressed: () => _handleAttachmentPressed(),
                ),
              );
            });
      },
    );
  }
}
