import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evolvu/common/common_style.dart';
import 'package:evolvu/Notice_SMS/notice_noteCard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Teacher/Attachment.dart';
import 'notice_DeatilCard.dart';

class Notice {
  final String noticeId;
  final String unqId;
  final String subject;
  final String noticeDesc;
  final String noticeDate;

  final String startDate;
  final String endDate;
  final String classId;
  final String sectionId;
  final String teacherId;
  final String noticeType;
  final String startTime;
  final String endTime;
  final String academicYr;
  final String publish;
  final String teacherName;
  final String className;
  final String noticeRLogId;
  final String readStatus;
  final List<Attachment> imageList;

  Notice({
    required this.noticeId,
    required this.unqId,
    required this.subject,
    required this.noticeDesc,
    required this.noticeDate,
    required this.startDate,
    required this.endDate,
    required this.classId,
    required this.sectionId,
    required this.teacherId,
    required this.noticeType,
    required this.startTime,
    required this.endTime,
    required this.academicYr,
    required this.publish,
    required this.teacherName,
    required this.className,
    required this.noticeRLogId,
    required this.readStatus,
    required this.imageList,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      noticeId: json['notice_id']?.toString() ?? '',
      unqId: json['unq_id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      noticeDesc: json['notice_desc']?.toString() ?? '',
      noticeDate: json['notice_date']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      classId: json['class_id']?.toString() ?? '',
      sectionId: json['section_id']?.toString() ?? '',
      teacherId: json['teacher_id']?.toString() ?? '',
      noticeType: json['notice_type']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      academicYr: json['academic_yr']?.toString() ?? '',
      publish: json['publish']?.toString() ?? '',
      teacherName: json['teachername']?.toString() ?? '',
      className: json['classname']?.toString() ?? '',
      noticeRLogId: json['notice_r_log_id']?.toString() ?? '',
      readStatus: json['read_status']?.toString() ?? '',
      imageList: (json['image_list'] as List)
          .map((item) => Attachment.fromJson(item))
          .toList(),
    );
  }
  String get formattedNoticeDate {
    // Assuming noticeDate is in yyyy-mm-dd format, convert it to dd-mm-yyyy
    if (noticeDate.isNotEmpty && noticeDate.length >= 10) {
      List<String> parts = noticeDate.split('-');
      if (parts.length >= 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}';
      }
    }
    return noticeDate; // Return as is if format is unexpected
  }
}


class NoticeNotePage extends StatefulWidget {
  final String studentId;
  final String academic_yr;
  final String shortName;
  final String classId;
  final String secId;

  NoticeNotePage(
      {required this.studentId, required this.academic_yr, required this.shortName, required this.classId, required this.secId});

  @override
  _NoticeNotePageState createState() => _NoticeNotePageState();
}

class _NoticeNotePageState extends State<NoticeNotePage> {
  late Future<List<Notice>> futureNotice;
  List<Notice> allNotices = [];
  List<Notice> filteredNotices = [];

  TextEditingController _searchController = TextEditingController();
  String shortName = "";
  String academic_yr = "";
  String reg_id = "";
  String url = "";

  Future<List<Notice>> fetchNotices() async {
    final prefs = await SharedPreferences.getInstance();
    String? schoolInfoJson = prefs.getString('school_info');
    String? logUrls = prefs.getString('logUrls');

    if (logUrls != null) {
      try {
        Map<String, dynamic> logUrlsparsed = json.decode(logUrls);
        academic_yr = logUrlsparsed['academic_yr'];
        reg_id = logUrlsparsed['reg_id'];
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

    final response = await http.post(
      Uri.parse(url + 'get_notice_with_multiple_attachment'),
      body: {
        'parent_id': reg_id,
        'academic_yr': academic_yr,
        'short_name': shortName,
        'class_id': widget.classId,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Notice.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notices');
    }
  }

  @override
  void initState() {
    super.initState();
    futureNotice = fetchNotices();
    futureNotice.then((notices) {
      setState(() {
        allNotices = notices;
        filteredNotices = notices;
      });
    });
    _searchController.addListener(() {
      filterNotes();
    });
  }

  void filterNotes() {
    final query = _searchController.text.toLowerCase();
    print('Filtering notices with query: $query'); // Debugging statement
    setState(() {
      filteredNotices = allNotices.where((notice) {
        return notice.subject.toLowerCase().contains(query) ||
            notice.teacherName.toLowerCase().contains(query) ||
            notice.noticeType.toLowerCase().contains(query) ||
            notice.noticeDate.toLowerCase().contains(query);
      }).toList();
      print('Filtered notices count: ${filteredNotices.length}'); // Debugging statement
    });
  }

  Map<String, List<Notice>> groupByDate(List<Notice> notes) {
    final Map<String, List<Notice>> groupedNotes = {};
    for (var note in notes) {
      if (groupedNotes.containsKey(note.formattedNoticeDate)) {
        groupedNotes[note.formattedNoticeDate]!.add(note);
      } else {
        groupedNotes[note.formattedNoticeDate] = [note];
      }
    }
    return groupedNotes;
  }

  Future<void> refreshNotices() async {
    List<Notice> notices = await fetchNotices();
    setState(() {
      futureNotice = fetchNotices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 50.h,
        title: Text(
          "${widget.shortName} EvolvU Smart Parent App(${widget.academic_yr})",
          style: TextStyle(fontSize: 14.sp, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: FutureBuilder<List<Notice>>(
          future: futureNotice,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Notice & SMS'));
            } else {
              final groupedNotes = groupByDate(filteredNotices);
              return Column(
                children: [
                  SizedBox(height: 80.h),
                  Text(
                    "Notice/SMS",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextField(
                        controller: _searchController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          hintText: "Search Subject",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 5.h),
                      itemCount: groupedNotes.keys.length,
                      itemBuilder: (context, index) {
                        final date = groupedNotes.keys.elementAt(index);
                        final dateNotes = groupedNotes[date]!;
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 18,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        date,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        const SizedBox(height: 10),
                                        Column(
                                          children: dateNotes.map((note) {
                                            return NoticeNoteCard(
                                              teacher: note.teacherName,
                                              remarksubject: note.subject,
                                              type: note.noticeType,
                                              // attachments: note.imageList,
                                              // date: note.noticeDate,
                                              readStatus: note.readStatus,
                                              onTap: () async {
                                                final result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                          NoticeDetailCard(
                                                              teacher: note.teacherName,
                                                              remarksubject: note.subject,
                                                              type: note.noticeType,
                                                            date: note.noticeDate,
                                                            noticeID: note.noticeId,
                                                            academic_yr: note.academicYr,
                                                            shortName: widget.shortName,
                                                            classname: note.className,
                                                            noticeDesc: note.noticeDesc,
                                                            attachment: note.imageList,
                                                            ),
                                                          ),
                                                    );
                                                if (result == true) {
                                                  refreshNotices();
                                                }
                                                },
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
  String truncateEndDate(String endDate) {
    List<String> parts = endDate.split(' ');
    if (parts.length > 1) {
      return parts[0]; // Return the date part only
    }
    return endDate;
  }

}