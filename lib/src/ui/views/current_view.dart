import 'package:canton_design_system/canton_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kounslr/src/config/bottom_navigation_bar.dart';
import 'package:kounslr/src/ui/styled_components/something_went_wrong.dart';
import 'package:kounslr/src/ui/views/chat_view.dart';
import 'package:kounslr/src/ui/views/hall_pass_view.dart';
import 'package:kounslr/src/ui/views/home_view.dart';
import 'package:kounslr/src/ui/views/journal_view.dart';
import 'package:kounslr/src/ui/views/no_student_data_view.dart';

class CurrentView extends StatefulWidget {
  @override
  _CurrentViewState createState() => _CurrentViewState();
}

class _CurrentViewState extends State<CurrentView> {
  final user = FirebaseFirestore.instance
      .collection('customers')
      .doc('lcps')
      .collection('schools')
      .doc('independence')
      .collection('students');

  bool studentHasData = true;

  Future<void> _checkIfStudentIsSignedIntoStudentVue() async {
    var student = await user.doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (student.data() == null || student.data()!['studentId'] == null) {
      setState(() {
        studentHasData = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfStudentIsSignedIntoStudentVue();
  }

  int _currentIndex = 0;
  final List<Widget> _views = [
    HomeView(),
    HallPassView(),
    ChatView(),
    JournalView(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return CantonScaffold(
        body: SomethingWentWrong(),
      );
    }

    return CantonScaffold(
      bottomNavBar:
          studentHasData ? BottomNavBar(_currentIndex, onTabTapped) : null,
      body: studentHasData ? _views[_currentIndex] : NoStudentDataView(),
    );
  }
}
