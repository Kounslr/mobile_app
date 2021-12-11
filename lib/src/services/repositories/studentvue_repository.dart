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

import 'package:dio/dio.dart';
import 'package:html_unescape/html_unescape.dart';
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

    var svData = <Class>[];

    var courses = document.findAllElements('Courses').first;
    var classes = <Class>[];
    for (int i = 0; i < courses.children.length; i++) {
      XmlNode current = courses.children[i];

      if (current.getAttribute('Title') == null) continue;
      Class _class = Class();

      _class.name = _formattedStringName(
          current.getAttribute('Title')!.substring(0, current.getAttribute('Title')!.indexOf('(')));

      _class.block = int.tryParse(current.getAttribute('Period') ?? '0') ?? -1;
      _class.roomNumber = current.getAttribute('Room') ?? 'N/A';
      // _class.teacher?.name = current.getAttribute('Staff') ?? 'N/A';
      // _class.teacher?.emailAddress =
      //     current.getAttribute('StaffEMail') ?? 'N/A';
      // _class.teacher?.role = 'Teacher';
      // _class.teacher?.phoneNumber = '';
      // _class.teacher?.id = '';

      // var mark = current.findAllElements('Mark').first;
      // _class.pctGrade = mark.getAttribute('CalculatedScoreRaw');
      // _class.letterGrade = mark.getAttribute('CalculatedScoreString');

      current = current.findAllElements('GradeCalculationSummary').first;

      current = current.parent!.findAllElements('Assignments').first;

      // _class.assignments = <Assignment>[];
      for (int i = 0; i < current.children.length; i++) {
        var ass = Assignment();

        ass.name = _formattedStringName(current.children[i].getAttribute('Measure'));
        ass.type = current.children[i].getAttribute('Type') ?? 'No Type';

        // bool dueDateIsNull = false;

        // String? dateString = dateStringMethod();

        // ass.dueDate = DateTime.parse(dateString);
        ass.dueDate = DateTime.now();

        // ass.earnedPoints =
        //     current.children[i].getAttribute('Score') == 'Not Graded'
        //         ? -1
        //         : double.tryParse(
        //                 (current.children[i].getAttribute('Points') ?? 'N/A')
        //                     .replaceAll(' ', '')
        //                     .split('/')[0]) ??
        //             -1;
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
        _class.assignments!.add(ass);
      }

      classes.add(_class);
    }
    svData = classes;

    return svData;
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

    return student;
  }
}
