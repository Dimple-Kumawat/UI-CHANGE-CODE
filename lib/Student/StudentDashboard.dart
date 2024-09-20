import 'dart:convert';
import 'package:evolvu/Homework/homeWork_notePage.dart';
import 'package:evolvu/Remark/remark_notePage.dart';
import 'package:evolvu/login.dart';
import 'package:evolvu/Student/student_profile_page.dart';
import 'package:evolvu/Teacher/teacher_notePage.dart';
import 'package:evolvu/result/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolvu/Student/student_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../ExamTimeTable/examTimeTable.dart';
import '../ExamTimeTable/timeTable.dart';
import '../Notice_SMS/notice_notePage.dart';
import '../SmartChat_WebView.dart';
import '../common/rotatedDivider_Card.dart';

class CardItem {
  final String? imageUrl;
  final String imagePath;
  final String title;
  final Function(BuildContext context) onTap;
  final bool showBadge; // Optional badge count
  final bool showBadgenotice; // Optional badge count
  final bool showBadgeTnote; // Optional badge count
  final bool showBadgeRemark; // Optional badge count

  CardItem({
    this.imageUrl,
    required this.imagePath,
    required this.title,
    required this.onTap,
    this.showBadge = false,
    this.showBadgenotice = false,
    this.showBadgeTnote = false,
    this.showBadgeRemark = false,
  });
}

class StudentActivityPage extends StatefulWidget {
  final String reg_id;
  final String shortName;
  final String studentId;
  final String academicYr;
  final String url;
  final String firstName;
  final String rollNo;
  final String className;
  final String cname;
  final String secname;
  final String classTeacher;
  final String gender;
  final String classId;
  final String secId;

  StudentActivityPage({
    required this.reg_id,
    required this.shortName,
    required this.studentId,
    required this.academicYr,
    required this.url,
    required this.firstName,
    required this.rollNo,
    required this.className,
    required this.cname,
    required this.secname,
    required this.classTeacher,
    required this.gender,
    required this.classId,
    required this.secId,
  });

  @override
  _StudentActivityPageState createState() => _StudentActivityPageState();
}

class _StudentActivityPageState extends State<StudentActivityPage> {


  String shortName = "";
  String academic_yr = "";
  String reg_id = "";
  String url = "";
  String imageUrl = "";
  int unreadCount = 0;
  int noticeunreadCount = 0;
  int TnoteunreadCount = 0;
  int ReamrkunreadCount = 0;

  @override
  void initState() {
    super.initState();
    fetchUnreadHomeworkCount();
    fetchUnreadnotices();
    fetchUnreadTechetNotes();
    fetchUnreadRemark();
  }

  Future<void> _getSchoolInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? schoolInfoJson = prefs.getString('school_info');
    String? logUrls = prefs.getString('logUrls');
    print('logUrls====\\\\\: $logUrls');
    if (logUrls != null) {
      try {
        Map<String, dynamic> logUrlsparsed = json.decode(logUrls);
        print('logUrls====\\\\\11111: $logUrls');

        academic_yr = logUrlsparsed['academic_yr'];
        reg_id = logUrlsparsed['reg_id'];

        print('academic_yr ID: $academic_yr');
        print('reg_id: $reg_id');
      } catch (e) {
        print('Error parsing school info: $e');
      }
    } else {
      print('School info not found in SharedPreferences.');
    }

    if (schoolInfoJson != null) {
      try {
        Map<String, dynamic> parsedData = json.decode(schoolInfoJson);

        shortName = parsedData['short_name'];
        url = parsedData['url'];

        print('Short Name: $shortName');
        print('URL: $url');
      } catch (e) {
        print('Error parsing school info: $e');
      }
    } else {
      print('School info not found in SharedPreferences.');
    }

    http.Response response = await http.post(
      Uri.parse(url + "get_student"),
      body: {
        'student_id': widget.studentId,
        'academic_yr': academic_yr,
        'short_name': shortName
      },
    );

    print('child status code: ${response.statusCode}');
    print('child Response body====:>  ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> apiResponse = json.decode(response.body);
      Map<String, dynamic> childInfo = apiResponse[0];
    }

    http.Response get_student_profile_images_details = await http.post(
      Uri.parse(url + "get_student_profile_images_details"),
      body: {
        'student_id': widget.studentId,
        'short_name': shortName
      },
    );

    // print('get_student_profile_images_details status code: ${get_student_profile_images_details.statusCode}');
    // print('get_student_profile_images_details Response body====:>  ${get_student_profile_images_details.body}');

    if (get_student_profile_images_details.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(get_student_profile_images_details.body);
      imageUrl = responseData['image_url'];
      print('Image URL: $imageUrl');
    if (imageUrl.hashCode == 404) {
      print('Image not found, using default image.');
      imageUrl = ""; // or set a default image URL if available
    } else {
      print('Error fetching image details: ${get_student_profile_images_details.statusCode}');
    }
  }
  }

  Future<int> fetchUnreadHomeworkCount() async {
    print('fetching unread remarks count: $reg_id');

    try {
      final response = await http.post(
        Uri.parse(widget.url + "get_count_of_unread_homeworks"),
        body: {
          'student_id': widget.studentId,
          'parent_id': widget.reg_id,
          'acd_yr': widget.academicYr,
          'short_name': widget.shortName
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        unreadCount = int.tryParse(data[0]['unread_homeworks']) ?? 0;
        print('fetching unread remarks count: $unreadCount');

      } else {
        print('Failed to fetch unread remarks count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching unread remarks count: $e');
    }

    return unreadCount;
  }
  Future<int> fetchUnreadnotices() async {

    try {
      final response = await http.post(
        Uri.parse(widget.url + "get_count_of_unread_notices"),
        body: {
          'student_id': widget.studentId,
          'parent_id': widget.reg_id,
          'acd_yr': widget.academicYr,
          'short_name': widget.shortName
        },
      );

      if (response.statusCode == 200) {

        List<dynamic> data = json.decode(response.body);
        noticeunreadCount = int.tryParse(data[0]['unread_notices']) ?? 0;
        print('fetching unread noticeunreadCount count: $noticeunreadCount');

      } else {
        print('Failed to fetch unread noticeunreadCount count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching unread noticeunreadCount count: $e');
    }

    return noticeunreadCount;
  }
  Future<int> fetchUnreadTechetNotes() async {

    try {
      final response = await http.post(
        Uri.parse(widget.url + "get_count_of_unread_notes"),
        body: {
          'student_id': widget.studentId,
          'parent_id': widget.reg_id,
          'acd_yr': widget.academicYr,
          'short_name': widget.shortName
        },
      );

      if (response.statusCode == 200) {

        List<dynamic> data = json.decode(response.body);
        TnoteunreadCount = int.tryParse(data[0]['unread_notes']) ?? 0;
        print('fetching unread TnoteunreadCount count: $TnoteunreadCount');

      } else {
        print('Failed to fetch unread TnoteunreadCount count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching unread TnoteunreadCount count: $e');
    }

    return TnoteunreadCount;
  }
  Future<int> fetchUnreadRemark() async {

    try {
      final response = await http.post(
        Uri.parse(widget.url + "get_count_of_unread_remarks"),
        body: {
          'student_id': widget.studentId,
          'parent_id': widget.reg_id,
          'acd_yr': widget.academicYr,
          'short_name': widget.shortName
        },
      );

      if (response.statusCode == 200) {

        List<dynamic> data = json.decode(response.body);
        ReamrkunreadCount = int.tryParse(data[0]['unread_remarks']) ?? 0;
        print('fetching unread ReamrkunreadCount count: $ReamrkunreadCount');

      } else {
        print('Failed to fetch unread ReamrkunreadCount count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching unread ReamrkunreadCount count: $e');
    }

    return ReamrkunreadCount;
  }


  @override
  Widget build(BuildContext context) {
    final List<CardItem> cardItems = [
      CardItem(
        imagePath: widget.gender == 'F' ? 'assets/girl.png' : 'assets/boy.png', // Local fallback image
        title: 'Student Profile',
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentProfilePage(studentId: widget.studentId,shortName: shortName,cname: widget.cname,
                secname: widget.secname,academic_yr: academic_yr
                ,),
            ),
          );
        },
      ),
      CardItem(
        imagePath: 'assets/teacher.png',
        title: 'Teacher Note',
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherNotePage(studentId: widget.studentId,shortName: shortName,academic_yr: academic_yr
                  ,classId: widget.classId,secId:widget.secId),
            ),
          );
          },
        showBadgeTnote: true,
      ),
      CardItem(
        imagePath: 'assets/books.png',
        title: 'Homework',
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeWorkNotePage(studentId: widget.studentId,shortName: shortName,academic_yr: academic_yr
                  ,classId: widget.classId,secId:widget.secId),
            ),
          );
          },
        showBadge: true, // Show badge on this card
      ),

      CardItem(
        imagePath: 'assets/studying.png',
        title: 'Remark',
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RemarkNotePage(studentId: widget.studentId,shortName: shortName,academic_yr: academic_yr
                  ,classId: widget.classId,secId:widget.secId),
            ),
          );
          },
        showBadgeRemark: true,
      ),
      CardItem(
        imagePath: 'assets/notice.png',
        title: 'Notice/SMS',
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoticeNotePage(studentId: widget.studentId,shortName: shortName,academic_yr: academic_yr
                  ,classId: widget.classId,secId:widget.secId),
            ),
          );
          },
        showBadgenotice: true,
      ),

      CardItem(
        imagePath: 'assets/calendar.png',
        title: 'Exam/TimeTable',

        onTap: (context) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,

                content:
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigator.of(context).pushNamed(timeTablePage);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimeTablePage(studentId: widget.studentId,shortName: shortName,academic_yr: academic_yr
                                ,classId: widget.classId,secId:widget.secId, className: widget.className),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Image.asset( 'assets/calendar.png',),

                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text("TimeTable"),
                          )

                        ],
                      ),
                    ),

                    const SizedBox(height: 15,),
                    GestureDetector(
                      onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExamTimeTablePage(studentId: widget.studentId,shortName: shortName,academic_yr: academic_yr
                                  ,classId: widget.classId,secId:widget.secId, className: widget.className,),
                            ),
                          );
                      },
                      child: Row(
                        children: [
                          SizedBox(
                              height: 50,
                              child: Image.asset('assets/examt.webp')),

                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text("ExamTimeTable"),
                          )

                        ],
                      ),
                    ),


                  ],
                ),

              );
            },
          );
        },

      ),
        CardItem(
        imagePath: 'assets/notice.png',
        title: 'Result',
         
       onTap: (context) {
          Navigator.push(
              context,
          MaterialPageRoute(
           builder: (context) => ResultPage(),
          //   builder: (context) => ExamResult(),
          ),
          );
        },
      ),


      CardItem(
        imagePath: 'assets/smartchat.png',
        title: 'Smart Chat',
        onTap: (context) {
          Navigator.push(
              context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(studentId: widget.studentId,shortName: shortName,academicYr: academic_yr
                ,classId: widget.classId,secId:widget.secId),
          ),
          );
        },
      ),
      // CardItem(
      //   imagePath: 'assets/new_module.png', // Path to the new module image
      //   title: 'New Module',
      //   onTap: (context) {
      //     Navigator.pushNamed(context, '/newModulePage'); // New module page route
      //   },
      // ),
    ];

    return FutureBuilder(
      future: _getSchoolInfo(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              "$shortName EvolvU Smart Parent App $academic_yr",
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink, Colors.blue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 120.h,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: SizedBox.square(
                                    dimension: 60.w,
                                    child: imageUrl.isNotEmpty
                                        ? Image.network(
                                      imageUrl + '?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                      height: 60,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          widget.gender == 'M' ? 'assets/boy.png' : 'assets/girl.png',
                                        );
                                      },
                                    )
                                        : Image.asset(
                                      widget.gender == 'M' ? 'assets/boy.png' : 'assets/girl.png',
                                    ),
                                  ),
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
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
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
                                      color: Color.fromARGB(255, 175, 167, 167),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
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
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 25),
                                   // padding: const EdgeInsets.all(13.0),
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
                      ),
                      Text(
                        "Student Activity",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 1.2,
                        padding: const EdgeInsets.only(top: 10,left: 20,right: 30),
                        children: List.generate(cardItems.length, (index) {
                          final item = cardItems[index];
                          return Card(
                            color: Colors.white,
                              child: Stack(
                              alignment: Alignment.center,
                              children: [
                              InkWell(
                                onTap: () => item.onTap(context),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      item.imagePath,
                                      height: 60,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                if (item.showBadge) // Conditionally show the badge
                                if (unreadCount != 0) // Conditionally show the badge
                                  Positioned(
                                    top: 1,
                                    right: 6,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '$unreadCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (item.showBadgenotice)
                                  if (noticeunreadCount != 0)// Conditionally show the badge
                                  Positioned(
                                    top: 1,
                                    right: 6,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '$noticeunreadCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (item.showBadgeTnote)
                                  if (TnoteunreadCount != 0)// Conditionally show the badge
                                  Positioned(
                                    top: 1,
                                    right: 6,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '$TnoteunreadCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ), if (item.showBadgeRemark)
                                  if (ReamrkunreadCount != 0)// Conditionally show the badge
                                  Positioned(
                                    top: 1,
                                    right: 6,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '$ReamrkunreadCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                              ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   items: const <BottomNavigationBarItem>[
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.dashboard),
          //       label: 'Dashboard',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.calendar_today),
          //       label: 'Calendar',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.person),
          //       label: 'Profile',
          //     ),
          //   ],
          // ),
          bottomNavigationBar: buildMyNavBar(context),
        );
      },


    );
  }
}
Container buildMyNavBar(BuildContext context) {
  return Container(
      height: 80.h,
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                enableFeedback: true,
                onPressed: () {
                  Navigator.of(context).pop(0);
                },
                icon: const Icon(
                  Icons.dashboard,
                  color: Colors.white,

                  size: 30,
                ),
              ),
              Text('Dashboard', style: TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  Navigator.of(context).pop(1);

                },
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,

                  size: 30,
                ),
              ),
              const Text('Calendar', style: TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  Navigator.of(context).pop(2);

                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,

                  size: 30,
                ),
              ),
              Text('Profile', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
      );
      }