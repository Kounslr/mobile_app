import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kounslr/src/models/journal_entry.dart';
import 'package:kounslr/src/ui/styled_components/journal_entry_card.dart';

class JournalEntriesView extends StatefulWidget {
  const JournalEntriesView();

  @override
  _JournalEntriesViewState createState() => _JournalEntriesViewState();
}

class _JournalEntriesViewState extends State<JournalEntriesView> {
  @override
  Widget build(BuildContext context) {
    return CantonScaffold(
      body: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _header(),
        _journalEntriesListView(context),
      ],
    );
  }

  Widget _header() {
    return ViewHeaderTwo(
      title: 'Journal Entries',
      backButton: true,
      isBackButtonClear: true,
    );
  }

  Widget _journalEntriesListView(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;

    var _stream = FirebaseFirestore.instance
        .collection('customers')
        .doc('lcps')
        .collection('schools')
        .doc('independence')
        .collection('students')
        .doc(user.uid)
        .collection('journal entries')
        .snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print(_listOfEntries(snapshot).length);
          return Expanded(
            child: ListView.builder(
              itemCount: _tagList.length,
              itemBuilder: (context, index) {
                return _tagCard(
                  context,
                  _listOfEntries(snapshot)[index].tags[0],
                  _listOfEntries(snapshot)
                      .where(
                          (element) => element.tags.contains(_tagList[index]))
                      .toList(),
                );
              },
            ),
          );
        } else {
          return Center(child: Loading());
        }
      },
    );
  }

  List<JournalEntry> _listOfEntries(
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
  ) {
    var entries = snapshot.data.docs;
    List<JournalEntry> e = [];
    List<Tag> _tags = [];
    for (var item in entries) {
      e.add(JournalEntry.fromMap(item.data()));
    }
    for (var entry in e) {
      for (var tag in entry.tags) if (!_tags.contains(tag)) _tags.add(tag);
    }

    _tagList = _tags;

    return e;
  }

  List<Tag> _tagList = [];

  Widget _tagCard(BuildContext context, Tag tag, List<JournalEntry> entries) {
    List<Widget> children = [];

    for (var entry in entries) {
      children.add(JournalEntryCard(entry));
    }

    return Card(
      child: CantonExpansionTile(
        childrenPadding: const EdgeInsets.all(8.0),
        iconColor: Theme.of(context).primaryColor,
        title: Text(
          tag.name,
          style: Theme.of(context).textTheme.headline6,
        ),
        children: children,
      ),
    );
  }
}
