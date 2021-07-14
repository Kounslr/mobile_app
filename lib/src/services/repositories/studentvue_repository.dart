import 'package:kounslr/src/models/block.dart';
import 'package:kounslr/src/models/class.dart';
import 'package:kounslr/src/models/staff_member.dart';
import 'package:kounslr/src/models/student.dart';
import 'package:kounslr/src/models/zip_code_result.dart';
import 'package:dio/dio.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:xml/xml.dart';
import 'package:kounslr/src/models/assignment.dart';
// import 'dart:developer' as dev;

class StudentVueClient {
  final domain;
  late String reqURL;

  final bool mock;
  final String username, password;
  final bool studentAccount;
  StudentVueClient(this.username, this.password, this.domain,
      {this.studentAccount = true, this.mock = false}) {
    reqURL = 'https://' + domain + '/Service/PXPCommunication.asmx?WSDL';
  }

  final Dio _dio = Dio(BaseOptions(validateStatus: (_) => true));

  String _formattedStringName(String? string) {
    return string?.replaceFirst('.', '').replaceAll('/', ' ') ?? 'Assignment';
  }

  Future<List<Class>> loadGradebook({Function(double)? callback}) async {
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

      var res = await _dio.post(reqURL,
          data: requestData,
          options: Options(headers: headers), onSendProgress: (one, two) {
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

    var svData = <Class>[];

    var courses = document.findAllElements('Courses').first;
    var classes = <Class>[];
    for (int i = 0; i < courses.children.length; i++) {
      XmlNode current = courses.children[i];

      if (current.getAttribute('Title') == null) continue;
      Class _class = Class(block: Block(), teacher: StaffMember());

      _class.className = _formattedStringName(current
          .getAttribute('Title')!
          .substring(0, current.getAttribute('Title')!.indexOf('(')));

      _class.block?.period =
          int.tryParse(current.getAttribute('Period') ?? '0') ?? -1;
      _class.roomNumber = current.getAttribute('Room') ?? 'N/A';
      _class.teacher?.name = current.getAttribute('Staff') ?? 'N/A';
      _class.teacher?.emailAddress =
          current.getAttribute('StaffEMail') ?? 'N/A';
      _class.teacher?.role = 'Teacher';
      _class.teacher?.phoneNumber = '';
      _class.teacher?.id = '';

      var mark = current.findAllElements('Mark').first;
      _class.pctGrade = mark.getAttribute('CalculatedScoreRaw');
      _class.letterGrade = mark.getAttribute('CalculatedScoreString');

      current = current.findAllElements('GradeCalculationSummary').first;

      current = current.parent!.findAllElements('Assignments').first;

      _class.assignments = <Assignment>[];
      for (int i = 0; i < current.children.length; i++) {
        Assignment ass = Assignment();

        ass.assignmentName =
            _formattedStringName(current.children[i].getAttribute('Measure'));
        ass.type = current.children[i].getAttribute('Type') ?? 'No Type';

        // bool dueDateIsNull = false;

        // String? dateString = dateStringMethod();

        // ass.dueDate = DateTime.parse(dateString);
        ass.dueDate = DateTime.now();

        ass.schoolClass = _class;

        ass.earnedPoints =
            current.children[i].getAttribute('Score') == 'Not Graded'
                ? -1
                : double.tryParse(
                        (current.children[i].getAttribute('Points') ?? 'N/A')
                            .replaceAll(' ', '')
                            .split('/')[0]) ??
                    -1;
        if (current.children[i].getAttribute('Score') == 'Not Graded') {
          ass.possiblePoints = double.tryParse(
              (current.children[i].getAttribute('Points') ?? '')
                  .replaceAll(' Points Possible', ''));
        } else {
          if (double.tryParse(
                  current.children[i].getAttribute('Score') ?? 'N/A') ==
              null) {
            List<String> pointsStr =
                (current.children[i].getAttribute('Points') ?? 'N/A')
                    .replaceAll(' ', '')
                    .split('/');
            if (pointsStr.length < 2) {
              ass.possiblePoints = -1;
            } else {
              double? pp = double.tryParse(pointsStr[1]);
              ass.possiblePoints = pp ?? -1;
            }
          } else {
            ass.possiblePoints = double.tryParse(
                current.children[i].getAttribute('Score') ?? 'N/A');
          }
        }
        _class.assignments!.add(ass);
      }

      classes.add(_class);
    }
    svData = classes;

    return svData;
  }

  Future<StudentM> loadStudentData({Function(double)? callback}) async {
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

      var res = await _dio.post(reqURL,
          data: requestData,
          options: Options(headers: headers), onSendProgress: (one, two) {
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
    final el = document.root.firstElementChild!.firstElementChild!
        .firstElementChild!.firstElementChild!.firstElementChild!;

    // final school = FirebaseFirestore.instance
    //     .collection('customers')
    //     .doc('lcps')
    //     .collection('schools')
    //     .doc('independence');

    var homeroomTeacher = StaffMember();
    // homeroomTeacher.id = Uuid().v4();
    homeroomTeacher.name = el.getElement('HomeRoomTch')?.innerText;
    homeroomTeacher.emailAddress = el.getElement('HomeRoomTchEMail')?.innerText;
    homeroomTeacher.role = 'Teacher';
    homeroomTeacher.phoneNumber = '';
    // homeroomTeacher.roomNumber = el.getElement('HomeRoom')?.innerText;

    var counselor = StaffMember();
    // counselor.id = Uuid().v4();
    counselor.name = el.getElement('CounselorName')?.innerText;
    counselor.role = 'Counselor';
    counselor.emailAddress = '';
    counselor.phoneNumber = '';

    var student = StudentM(
      // id: Uuid().v4(),
      studentId: el.getElement('PermID')?.innerText,
      name: el.getElement('FormattedName')?.innerText,
      gender: el.getElement('Gender')?.innerText,
      address: el.getElement('Address')?.innerText,
      nickname: el.getElement('NickName')?.innerText,
      birthdate: el.getElement('BirthDate')?.innerText,
      email: el.getElement('EMail')?.innerText,
      phone: el.getElement('Phone')?.innerText,
      photo: '',
    );

    // var staffMembers = await school.collection('staff').get();
    // var classes = await school.collection('school').get();

    // staffMembers.docs.forEach((element) {
    //   if (element.data()['emailAddress'] == homeroomTeacher.emailAddress) {
    //     classes.docs.forEach((element) {
    //       element.data()[''] = 3;
    //     });
    //   }
    // });

    // var student = Student(
    //   studentId: el.getElement('PermID')?.innerText,
    //   name: el.getElement('FormattedName')?.innerText,
    //   gender: el.getElement('Gender')?.innerText,
    //   grade: el.getElement('Grade')?.innerText,
    //   address: el.getElement('Address')?.innerText,
    //   nickname: el.getElement('NickName')?.innerText,
    //   birthdate: el.getElement('BirthDate')?.innerText,
    //   email: el.getElement('EMail')?.innerText,
    //   phone: el.getElement('Phone')?.innerText,
    //   currentSchool: el.getElement('CurrentSchool')?.innerText,
    //   photo: '',
    //   homeroomTeacher: homeroomTeacher,
    //   counselor: counselor,
    // );

    return student;
  }

  static Future<List<ZipCodeResult>> loadDistrictsFromZip(String zip,
      {Function(double)? callback, bool mock = false}) async {
    String? resData;
    if (!mock) {
      var requestData = '''<?xml version="1.0" encoding="utf-8"?>
<v:Envelope xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns:d="http://www.w3.org/2001/XMLSchema" xmlns:c="http://schemas.xmlsoap.org/soap/encoding/" xmlns:v="http://schemas.xmlsoap.org/soap/envelope/">
    <v:Header />
    <v:Body>
        <ProcessWebServiceRequestMultiWeb xmlns="http://edupoint.com/webservices/" id="o0" c:root="1">
            <userID i:type="d:string">EdupointDistrictInfo</userID>
            <password i:type="d:string">Edup01nt</password>
            <skipLoginLog i:type="d:string">false</skipLoginLog>
            <parent i:type="d:string">false</parent>
            <webServiceHandleName i:type="d:string">HDInfoServices</webServiceHandleName>
            <methodName i:type="d:string">GetMatchingDistrictList</methodName>
            <paramStr i:type="d:string">&lt;Parms&gt;&lt;Key&gt;5E4B7859-B805-474B-A833-FDB15D205D40&lt;/Key&gt;&lt;MatchToDistrictZipCode&gt;$zip&lt;/MatchToDistrictZipCode&gt;&lt;/Parms&gt;</paramStr>
            <webDBName i:type="d:string"></webDBName>
        </ProcessWebServiceRequestMultiWeb>
    </v:Body>
</v:Envelope>''';

      var headers = <String, List<String>>{
        'Content-Type': ['text/xml']
      };

      final _dio = Dio(BaseOptions(validateStatus: (_) => true));
      var res = await _dio.post(
          'https://support.edupoint.com/Service/HDInfoCommunication.asmx',
          data: requestData,
          options: Options(headers: headers), onSendProgress: (one, two) {
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

    return document.firstElementChild!.firstElementChild!.firstElementChild!
        .firstElementChild!.firstElementChild!.firstElementChild!.children
        .map((e) => ZipCodeResult(
            districtName: e.getAttribute('Name'),
            districtUrl: e.getAttribute('PvueURL')))
        .where((e) => e.districtUrl != null)
        .toList();
  }
}
