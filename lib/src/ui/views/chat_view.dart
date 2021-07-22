import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kounslr/src/services/repositories/chat_repository.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  var isStudentView = false;

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return StreamBuilder<List<types.Room>>(
      stream: FirebaseChatCore.instance.rooms(),
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        if (snapshot.data == null) {
          return Loading();
        }

        return Column(
          children: [
            _header(context, snapshot.data!),
            SizedBox(height: 10),
            _listOfChats(context, snapshot.data!),
          ],
        );
      },
    );
  }

  Widget _header(BuildContext context, List<types.Room> rooms) {
    return Column(
      children: [
        ViewHeaderOne(
          title: 'Chat',
          button: CantonHeaderButton(
            isClear: true,
            backgroundColor: CantonColors.transparent,
            icon: Icon(
              FeatherIcons.plus,
              color: Theme.of(context).primaryColor,
              size: 27,
            ),
          ),
        ),
        _searchBar(context, rooms),
      ],
    );
  }

  Widget _searchBar(BuildContext context, List<types.Room> rooms) {
    if (rooms.length == 0) {
      return Container();
    }
    return CantonTextInput(
      obscureText: false,
      isTextFormField: false,
      hintText: 'Search',
      prefixIcon: IconlyIcon(
        IconlyBold.Search,
        size: 20,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
      onChanged: (string) {
        _searchChats(string);
      },
    );
  }

  Widget _listOfChats(BuildContext context, List<types.Room> rooms) {
    if (rooms.length == 0) {
      return Expanded(
        child: Center(
          child: Text(
            'Click the "+" button to start a chat',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Text(rooms[index].name!);
        },
      ),
    );
  }

  void _searchChats(String query) {
    // final newNoteList = context
    //     .read(noteProvider)
    //     .where((element) => element.tags!.contains(widget.tag))
    //     .toList()
    //     .where((note) {
    //   return note.title!.toLowerCase().contains(query.toLowerCase());
    // }).toList();

    // setState(() {
    //   if (newNoteList.isEmpty) {
    //     noteList = context
    //         .read(noteProvider)
    //         .where((element) => element.tags!.contains(widget.tag))
    //         .toList();
    //   } else {
    //     noteList = newNoteList;
    //   }
    // });
  }

  // ignore: unused_element
  Future<void> _showCreateChatBottomSheet() async {
    var _searchController = TextEditingController();
    var hasResult = true;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      useRootNavigator: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Consumer(
              builder: (context, watch, child) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 27),
                  child: FractionallySizedBox(
                    heightFactor: 0.95,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 5,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Search for students',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(height: 20),
                        CantonTextInput(
                          isTextFormField: true,
                          obscureText: false,
                          hintText: 'Search students',
                          textInputType: TextInputType.emailAddress,
                          controller: _searchController,
                        ),
                        SizedBox(height: 15),
                        // Add switch teachers, Individual gcs and other
                        CantonPrimaryButton(
                          onPressed: () async {},
                          buttonText: 'Sign in',
                          textColor: CantonColors.white,
                          containerWidth: MediaQuery.of(context).size.width / 4,
                          containerHeight: 47,
                          radius: BorderRadius.circular(37),
                          containerPadding: EdgeInsets.all(10),
                        ),
                        SizedBox(height: 20),
                        hasResult == false
                            ? Text(
                                'Incorrect email or password',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                              )
                            : Container(),
                      ],
                    ),
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
