/*
Kounslr iOS & Android App
Copyright (C) 2021 Kounslr

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:kounslr/src/models/current_day.dart';
import 'package:kounslr/src/models/event.dart';
import 'package:kounslr/src/models/school.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/services/repositories/school_repository.dart';
import 'package:kounslr/src/ui/components/show_sign_in_with_studentvue_bottomsheet.dart';
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

import 'package:kounslr/src/models/assignment.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/student.dart';

class StudentVueClient {
  final String domain;
  late String reqURL;

  final bool mock;
  final String username, password;
  final bool studentAccount;
  StudentVueClient(this.username, this.password, this.domain, {this.studentAccount = true, this.mock = false}) {
    reqURL = 'https://' + domain + '/Service/PXPCommunication.asmx?WSDL';
  }

  final Dio _dio = Dio(BaseOptions(validateStatus: (_) => true));

  String _formattedStringName(String? string) {
    return string?.replaceFirst('.', '').replaceAll('/', ' ') ?? 'Assignment';
  }

  Future<String> loadInfoToDatabase({
    Function(double)? callback,
    required Student student,
    required String password,
    required void Function(void Function()) setState,
  }) async {
    try {
      final sch = await _addSchoolToDatabaseCheck(setState: setState);

      if (sch['id'] == 'notSupported') {
        return 'Kounslr doesn\'t support your school yet! 😔';
      }

      String? resData;
      if (!mock) {
        var requestData = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
          <ProcessWebServiceRequest xmlns="http://edupoint.com/webservices/">
              <userID>$username</userID>
              <password>$password</password>
              <skipLoginLog>1</skipLoginLog>
              <parent>${studentAccount ? '0' : '1'}</parent>
              <webServiceHandleName>PXPWebServices</webServiceHandleName>
              <methodName>Gradebook</methodName>
              <paramStr>&lt;Parms&gt;&lt;ChildIntID&gt;0&lt;/ChildIntID&gt;&lt;/Parms&gt;</paramStr>
          </ProcessWebServiceRequest>
      </soap:Body>
    </soap:Envelope>''';

        var headers = <String, String>{'Content-Type': 'text/xml'};

        var res =
            await _dio.post(reqURL, data: requestData, options: Options(headers: headers), onSendProgress: (one, two) {
          if (callback != null) {
            callback((one / two) * 0.5);
          }
        }, onReceiveProgress: (one, two) {
          if (callback != null) {
            callback((one / two) * 0.5 + 0.5);
          }
        });

        resData = res.data as String;
      }

      final document = XmlDocument.parse(HtmlUnescape().convert(resData!));

      var courses = document.findAllElements('Courses').first;

      await _createStudentInDatabase(student, sch['id'], student.studentId!, password);

      for (int i = 0; i < courses.children.length; i++) {
        XmlNode current = courses.children[i];

        if (current.getAttribute('Title') == null) continue;
        Class _class = Class();

        _class.name = _formattedStringName(
            current.getAttribute('Title')!.substring(0, current.getAttribute('Title')!.indexOf('(')));

        _class.block = int.tryParse(current.getAttribute('Period') ?? '0') ?? -1;
        _class.roomNumber = current.getAttribute('Room') ?? 'N/A';

        /// Gets teacher email
        final teacherEmail = current.getAttribute('StaffEMail') ?? 'N/A';

        /// Checks if teacher is in database (If [list] is empty then the teacher is not in the database)
        final teacherChecklist = await FirebaseFirestore.instance
            .collection('schools/${sch['id']}/staff')
            .where('emailAddress', isEqualTo: teacherEmail)
            .get();

        final teacher = StaffMember(
          id: const Uuid().v4(),
          name: current.getAttribute('Staff') ?? 'N/A',
          emailAddress: teacherEmail,
          role: 'Teacher',
          phoneNumber: '',
          gender: '',
        );

        if (teacherChecklist.docs.isEmpty) {
          /// Creates new teacher as well as new class and adds student
          await _addTeacherToDatabase(teacher, sch['id']);
          await _addClassToDatabase(current, teacher, student.id!, sch['id']);
        } else {
          /// Gathers list of classes that the teacher teaches
          final classChecklist = await SchoolRepository().getClassesByTeacherId(teacherChecklist.docs[0].data()['id']);
          final targetClass = classChecklist.where((element) => element.name == _class.name).toList();

          /// Checks if the teacher has the class registered in the database
          if (targetClass.isEmpty) {
            /// Creates new class and adds student
            _addClassToDatabase(current, teacher, student.id!, sch['id']);
          } else {
            /// Adds student to existing class
            final classesRef =
                FirebaseFirestore.instance.collection('schools/${sch['id']}/classes').doc(targetClass[0].id);
            final classesDoc = await classesRef.get();
            final stdnt = await SchoolRepository().getStudent(student.id!);

            await classesRef.update({
              'students': [
                ...classesDoc.data()!['students'],
                {'id': stdnt.id},
              ],
            });

            final assignmentsRef = await classesRef.collection('assignments').get();

            for (var item in assignmentsRef.docs) {
              await item.reference.update({
                'students': [
                  ...item['students'],
                  stdnt.toStudentInAssignment().toMap(),
                ],
              });
            }

            await FirebaseFirestore.instance
                .collection('schools/${sch['id']}/students')
                .doc('${stdnt.id!}/classes/${classesDoc.data()!["id"]}')
                .set(stdnt.toStudentInClass().toMap());
          }
        }

        final signUpComplete = {'studentVueSignInComplete': true};

        await FirebaseFirestore.instance
            .collection('schools/${sch['id']}/students')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .update(signUpComplete);
      }
      return 'success';
    } catch (e) {
      return 'Server error. Please try again later.';
    }
  }

  Future<void> _addTeacherToDatabase(StaffMember staffMember, String schoolId) async {
    await FirebaseFirestore.instance.collection('schools/$schoolId/staff').doc(staffMember.id).set(staffMember.toMap());
  }

  Future<void> _addClassToDatabase(XmlNode current, StaffMember teacher, String studentID, String schId) async {
    /// Creates the class and gathers info
    var schoolClass = Class(
      id: const Uuid().v4(),
      name: _formattedStringName(
          current.getAttribute('Title')!.substring(0, current.getAttribute('Title')!.indexOf('('))),
      block: int.tryParse(current.getAttribute('Period') ?? '0') ?? -1,
      markingPeriod: 1,
      roomNumber: current.getAttribute('Room') ?? 'N/A',
      teacherId: teacher.id,
      students: [StudentID(id: studentID)],
      assignments: [],
    );

    current = current.findAllElements('Assignments').first;

    for (int i = 0; i < current.children.length; i++) {
      var ass = Assignment();

      while (current.children[i].runtimeType == XmlElement) {
        ass.id = const Uuid().v4();
        ass.name = _formattedStringName(current.children[i].getAttribute('Measure')).trim();
        ass.type = (current.children[i].getAttribute('Type') ?? 'No Type').trim();
        ass.creationDate = DateFormat.yMd().parse(current.children[i].getAttribute('Date')!);
        ass.dueDate = DateFormat.yMd().parse(current.children[i].getAttribute('DueDate')!);
        ass.classId = schoolClass.id;
        ass.markingPeriod = schoolClass.markingPeriod;

        var earnedPoints = current.children[i].getAttribute('Score') == 'Not Graded'
            ? -1.0
            : double.tryParse(
                    (current.children[i].getAttribute('Points') ?? 'N/A').replaceAll(' ', '').split('/')[0]) ??
                -1.0;

        ass.students = [StudentInAssignment(id: studentID, completed: false, earnedPoints: earnedPoints)];

        if (current.children[i].getAttribute('Score') == 'Not Graded') {
          ass.possiblePoints =
              double.tryParse((current.children[i].getAttribute('Points') ?? '').replaceAll(' Points Possible', ''));
        } else {
          if (double.tryParse(current.children[i].getAttribute('Score') ?? 'N/A') == null) {
            List<String> pointsStr =
                (current.children[i].getAttribute('Points') ?? 'N/A').replaceAll(' ', '').split('/');
            if (pointsStr.length < 2) {
              ass.possiblePoints = -1;
            } else {
              double? pp = double.tryParse(pointsStr[1]);
              ass.possiblePoints = pp ?? -1;
            }
          } else {
            ass.possiblePoints = double.tryParse(current.children[i].getAttribute('Score') ?? 'N/A');
          }
        }
        schoolClass.assignments!.add(ass);
        break;
      }
    }

    /// Adds class to database
    final nClass = schoolClass.toMap();
    nClass.remove('assignments');

    final ref = FirebaseFirestore.instance.collection('schools/$schId/classes');
    final userRef = FirebaseFirestore.instance.collection('schools/$schId/students');

    await ref.doc(schoolClass.id).set(nClass);
    await userRef.doc(studentID).collection('classes').doc(schoolClass.id).set(StudentInClass(grades: []).toMap());

    for (Assignment item in schoolClass.assignments!) {
      await ref.doc(schoolClass.id).collection('assignments').doc(item.id).set(item.toDocumentSnapshot());
    }
  }

  Future<void> _createStudentInDatabase(Student student, String schoolId, String username, String password) async {
    await FirebaseFirestore.instance.collection('schools/$schoolId/students').doc(student.id).set(student.toMap());
    await FirebaseFirestore.instance.doc('students/${student.id}').update({
      'hasData': true,
      'school': schoolId,
      'studentVueUsername': username,
      'studentVuePassword': password,
    });
  }

  Future<Map<String, dynamic>> _addSchoolToDatabaseCheck({
    Function(double)? callback,
    required void Function(void Function()) setState,
  }) async {
    String? resData;
    if (!mock) {
      var requestData = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
          <ProcessWebServiceRequest xmlns="http://edupoint.com/webservices/">
              <userID>$username</userID>
              <password>$password</password>
              <skipLoginLog>1</skipLoginLog>
              <parent>${studentAccount ? '0' : '1'}</parent>
              <webServiceHandleName>PXPWebServices</webServiceHandleName>
              <methodName>StudentSchoolInfo</methodName>
              <paramStr>&lt;Parms&gt;&lt;ChildIntID&gt;0&lt;/ChildIntID&gt;&lt;/Parms&gt;</paramStr>
          </ProcessWebServiceRequest>
      </soap:Body>
    </soap:Envelope>''';

      var headers = <String, String>{'Content-Type': 'text/xml'};

      var res =
          await _dio.post(reqURL, data: requestData, options: Options(headers: headers), onSendProgress: (one, two) {
        if (callback != null) {
          callback((one / two) * 0.5);
        }
      }, onReceiveProgress: (one, two) {
        if (callback != null) {
          callback((one / two) * 0.5 + 0.5);
        }
      });

      resData = res.data as String;
    }

    final document = XmlDocument.parse(HtmlUnescape().convert(resData!));

    var current = document.findAllElements('StudentSchoolInfoListing').first;

    final ref = FirebaseFirestore.instance.collection('schools');

    final id = const Uuid().v4();
    final name = current.getAttribute('School');
    final address = current.getAttribute('SchoolAddress');
    final phoneNumber = current.getAttribute('Phone');
    final faxNumber = current.getAttribute('Phone2');
    final websiteUrl = current.getAttribute('URL');

    var currentDay = CurrentDay();

    var schoolMap = {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'faxNumber': faxNumber,
      'websiteUrl': websiteUrl,
    };

    final schoolInDb = await ref.where('name', isEqualTo: name).where('phoneNumber', isEqualTo: phoneNumber).get();

    // If empty, then it'll add a new school to the database.
    if (schoolInDb.docs.isEmpty) {
      // If school is in LCPS
      if (domain == 'portal.lcps.org') {
        setState(() {
          studentVueSignInResult =
              'You\'re the first person at $name to use Kounslr🎉 Please wait patiently as the sign in may take a while!';
        });

        final cId = const Uuid().v4();
        final cEvents = <Event>[];

        var cIndRef = await ref.doc('4952f62e-353f-4ea7-9ee6-d35f28d33d8f').get();

        final cIndCurDay = CurrentDay.fromMapFromDocumentSnapshot(cIndRef['currentDay']);

        currentDay = CurrentDay(
          id: cId,
          events: cEvents,
          dayType: cIndCurDay.dayType,
          markingPeriod: cIndCurDay.markingPeriod,
          date: cIndCurDay.date,
          startingTime: cIndCurDay.startingTime,
          endingTime: cIndCurDay.endingTime,
          blocks: cIndCurDay.blocks,
        );

        final school = School(
          id: id,
          name: name,
          address: address,
          phoneNumber: phoneNumber,
          faxNumber: faxNumber,
          websiteURL: websiteUrl,
          currentDay: currentDay,
        );

        await ref.doc(id).set(school.toDocumentSnapshot());
      } else {
        return {'id': 'notSupported'};
      }
    }

    return schoolMap;
  }

  Future<Student> loadStudentData({Function(double)? callback}) async {
    String? resData;
    if (!mock) {
      var requestData = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
            <ProcessWebServiceRequest xmlns="http://edupoint.com/webservices/">
                <userID>$username</userID>
                <password>$password</password>
                <skipLoginLog>1</skipLoginLog>
                <parent>${studentAccount ? '0' : '1'}</parent>
                <webServiceHandleName>PXPWebServices</webServiceHandleName>
                <methodName>StudentInfo</methodName>
                <paramStr>&lt;Parms&gt;&lt;ChildIntID&gt;0&lt;/ChildIntID&gt;&lt;/Parms&gt;</paramStr>
            </ProcessWebServiceRequest>
        </soap:Body>
    </soap:Envelope>''';

      var headers = <String, String>{'Content-Type': 'text/xml'};

      var res =
          await _dio.post(reqURL, data: requestData, options: Options(headers: headers), onSendProgress: (one, two) {
        if (callback != null) {
          callback((one / two) * 0.5);
        }
      }, onReceiveProgress: (one, two) {
        if (callback != null) {
          callback((one / two) * 0.5 + 0.5);
        }
      });
      resData = res.data;
    }

    final document = XmlDocument.parse(HtmlUnescape().convert(resData!));

    // the StudentInfo element is inside four other dumb elements
    final el =
        document.root.firstElementChild!.firstElementChild!.firstElementChild!.firstElementChild!.firstElementChild!;

    var student = Student(
      id: const Uuid().v4(),
      studentId: el.getElement('PermID')?.innerText,
      name: el.getElement('FormattedName')?.innerText,
      gender: el.getElement('Gender')?.innerText,
      grade: el.getElement('Grade')?.innerText,
      address: el.getElement('Address')?.innerText,
      nickname: el.getElement('NickName')?.innerText,
      birthdate: el.getElement('BirthDate')?.innerText,
      email: el.getElement('EMail')?.innerText,
      phone: el.getElement('Phone')?.innerText,
      photo: '',
    );

    final schRef = FirebaseFirestore.instance
        .collection('schools')
        .where('name', isEqualTo: el.getElement('schoolName')?.innerText);

    final sch = await schRef.get();

    await FirebaseFirestore.instance
        .collection('schools')
        .doc(sch.docs[0].id)
        .collection('students')
        .doc(student.id!)
        .set(student.toMap());

    return student;
  }
}
