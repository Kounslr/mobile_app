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
        ViewHeaderTwo(
          title: 'Journal Entries',
          backButton: true,
          isBackButtonClear: true,
        ),
        _journalEntriesListView(context),
      ],
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
          var entries = snapshot.data.docs;
          return Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return JournalEntryCard(
                  JournalEntry.fromMap(
                    entries[index].data(),
                  ),
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
}
