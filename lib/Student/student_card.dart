import 'dart:convert';
import 'package:evolvu/Parent/parentDashBoard_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import '../common/rotatedDivider_Card.dart';
import 'StudentDashboard.dart';

class StudentCard extends StatefulWidget {
  final Function(int index) onTap;
  StudentCard({super.key, required this.onTap});
  @override
  _StudentCardState createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  List<Map<String, dynamic>> students = [];
  String shortName = "";
  String url = "";
  String academicYr = "";
  String regId = "";
  List<Map<String, dynamic>> examData = [];

  Future<void> _fetchTodaysExams() async {
    final prefs = await SharedPreferences.getInstance();
    String? schoolInfoJson = prefs.getString('school_info');
    String? logUrls = prefs.getString('logUrls');

    if (logUrls != null) {
      try {
        Map<String, dynamic> logUrlsParsed = json.decode(logUrls);
        academicYr = logUrlsParsed['academic_yr'];
        regId = logUrlsParsed['reg_id'];
      } catch (e) {
        print('Error parsing log URLs: $e');
      }
    } else {
      print('Log URLs not found in SharedPreferences.');
    }

    if (schoolInfoJson != null) {
      try {
        Map<String, dynamic> parsedData = json.decode(schoolInfoJson);
        shortName = parsedData['short_name'];
        url = parsedData['url'];
      } catch (e) {
        print('Error parsing school info: $e');
      }
    }

    try {
      final response = await http.post(
        Uri.parse('$url/get_todays_exam'),
        body: {
          'reg_id': regId,
          'academic_yr': academicYr,
          'short_name': shortName,
        },
      );

      print('get_todays_exam: $response');

      if (response.statusCode == 200) {
        List<dynamic> apiResponse = json.decode(response.body);
        setState(() {
          // Use this data to dynamically display the exam data
          examData = List<Map<String, dynamic>>.from(apiResponse);
        });
      } else {
        print(
            'Failed to load exam data with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching exam data: $e');
    }
  }

  Future<void> _getSchoolInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? schoolInfoJson = prefs.getString('school_info');
    String? logUrls = prefs.getString('logUrls');

    if (logUrls != null) {
      try {
        Map<String, dynamic> logUrlsParsed = json.decode(logUrls);
        academicYr = logUrlsParsed['academic_yr'];
        regId = logUrlsParsed['reg_id'];
      } catch (e) {
        print('Error parsing log URLs: $e');
      }
    } else {
      print('Log URLs not found in SharedPreferences.');
    }

    if (schoolInfoJson != null) {
      try {
        Map<String, dynamic> parsedData = json.decode(schoolInfoJson);
        shortName = parsedData['short_name'];
        url = parsedData['url'];
      } catch (e) {
        print('Error parsing school info: $e');
      }
    } else {
      print('School info not found in SharedPreferences.');
    }

    if (url.isNotEmpty) {
      try {
        http.Response response = await http.post(
          Uri.parse(url + "get_childs"),
          body: {
            'reg_id': regId,
            'academic_yr': academicYr,
            'short_name': shortName,
          },
        );
        print('Response get_childs: ${response.body}');

        if (response.statusCode == 200) {
          List<dynamic> apiResponse = json.decode(response.body);
          setState(() {
            students = List<Map<String, dynamic>>.from(apiResponse);
          });
        } else {
          print(
              'Failed to load students with status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error during http request: $e');
      }
    } else {
      print('URL is empty, cannot make HTTP request.');
    }
  }

  @override
  void initState() {
    super.initState();
    _getSchoolInfo();
    _fetchTodaysExams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('My Child'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img.png', // Replace with your background image
              fit: BoxFit.cover,
            ),
          ),
          students.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    // Display the student cards using ListView.builder
                    ListView.builder(
                      shrinkWrap:
                          true, // Important to wrap the builder within the ListView
                      physics:
                          NeverScrollableScrollPhysics(), // Prevent nested scrolling
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        return StudentCardItem(
                          firstName: students[index]['first_name'] ?? '',
                          rollNo: students[index]['roll_no'] ?? '',
                          className: (students[index]['class_name'] ?? '') +
                              (students[index]['section_name'] ?? ''),
                          cname: (students[index]['class_name'] ?? ''),
                          secname: (students[index]['section_name'] ?? ''),
                          classTeacher: students[index]['class_teacher'] ?? '',
                          gender: students[index]['gender'] ?? '',
                          studentId: students[index]['student_id'] ?? '',
                          classId: students[index]['class_id'] ?? '',
                          secId: students[index]['section_id'] ?? '',
                          shortName: shortName,
                          url: url,
                          academicYr: academicYr,
                          onTap: widget.onTap,
                        );
                      },
                    ),
                    // Display the exam card once for all students
                    _buildExamCard(),
                  ],
                ),
        ],
      ),
    );
  }
// Method to build the exam card that shows exams for all students with separate cards for each exam

Widget _buildExamCard() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title for the Exam section
        Text(
          'Exams',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),

        // Display exams grouped by student name, with each exam in a separate card
        Column(
          children: examData.map((exam) {
            String examSubject = exam['s_name'] ?? ''; // Fetch subject name
            bool isStudyLeave =
                examSubject.isEmpty || exam['study_leave'] == 'Y';

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              color: isStudyLeave ? Colors.grey[300] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 26.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Student's first name
                    Expanded(
                      flex: 1,
                      child: Text(
                        exam['first_name'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Exam date
                    Expanded(
                      flex: 1,
                      child: Text(
                        exam['date'] ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Show 'Study Leave' if subject name is empty, else show subject name
                    Expanded(
                      flex: 1,
                      child: Text(
                        isStudyLeave ? 'Study Leave' : examSubject + "jghjghghfffffffff",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isStudyLeave ? Colors.redAccent : Colors.black,
                        ),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}



}

class StudentCardItem extends StatefulWidget {
  final String firstName;
  final String rollNo;
  final String className;
  final String cname;
  final String secname;
  final String classTeacher;
  final String gender;
  final String studentId;
  final String shortName;
  final String url;
  final String academicYr;
  final String classId;
  final String secId;
  final Function(int index) onTap;

  StudentCardItem({
    required this.firstName,
    required this.rollNo,
    required this.className,
    required this.cname,
    required this.secname,
    required this.classTeacher,
    required this.gender,
    required this.studentId,
    required this.shortName,
    required this.url,
    required this.academicYr,
    required this.classId,
    required this.secId,
    required this.onTap,
  });

  @override
  _StudentCardItemState createState() => _StudentCardItemState();
}

class _StudentCardItemState extends State<StudentCardItem> {
  String attendance = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
    // _fetchTodaysExams();
  }

  Future<List<Map<String, dynamic>>> _fetchTodaysExams() async {
    try {
      print('regid: $reg_id');

      final response = await http.post(
        Uri.parse('${widget.url}get_todays_exam'),
        body: {
          'short_name': widget.shortName,
          'reg_id': reg_id,
          'academic_yr': widget.academicYr,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> examList = json.decode(response.body);
        // Assuming we are dealing with one student's exam data
        return List<Map<String, dynamic>>.from(examList);
      } else {
        print('Failed to load exams: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching exams: $e');
      return [];
    }
  }

  Future<void> _fetchAttendance() async {
    http.Response response = await http.post(
      Uri.parse(widget.url + "get_student_attendance_percentage"),
      body: {
        'student_id': widget.studentId,
        'acd_yr': widget.academicYr,
        'short_name': widget.shortName,
      },
    );

    print('Response percentage: ${response.body}');

    if (response.statusCode == 200) {
      String apiValue = response.body;
      setState(() {
        attendance = apiValue;
      });
    } else {
      setState(() {
        attendance = "N/A";
      });
      print('Failed to load attendance');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var x = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentActivityPage(
              reg_id: reg_id,
              shortName: widget.shortName,
              studentId: widget.studentId,
              academicYr: widget.academicYr,
              url: widget.url,
              firstName: widget.firstName,
              rollNo: widget.rollNo,
              className: widget.className,
              cname: widget.cname,
              secname: widget.secname,
              classTeacher: widget.classTeacher,
              gender: widget.gender,
              classId: widget.classId,
              secId: widget.secId,
            ),
          ),
        );
        if (x == null) return;
        widget.onTap(x as int);
      },
      child: Column(
        children: [
          _buildStudentInfoCard(),
        ],
      ),
    );
  }

  Widget _buildStudentInfoCard() {
    return SizedBox(
      height: 100.h,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Card(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox.square(
                    dimension: 55.w,
                    child: Image.asset(
                      widget.gender == 'M'
                          ? 'assets/boy.png'
                          : 'assets/girl.png',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(3, 3, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: 'Attendance ',
                        style: TextStyle(fontSize: 10.sp, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: '$attendance%',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.firstName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp),
                      ),
                      Text(
                        "RollNo: ${widget.rollNo}",
                        style: TextStyle(fontSize: 10.sp, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.rotate(
                angle: -math.pi / 180.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    width: 2.w,
                    height: 70.h,
                    color: const Color.fromARGB(255, 175, 167, 167),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Class",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.className,
                      style: TextStyle(fontSize: 10.sp, color: Colors.red),
                    ),
                  ],
                ),
              ),
              const RotatedDivider(),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Teacher",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.classTeacher,
                        style: TextStyle(fontSize: 10.sp, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
