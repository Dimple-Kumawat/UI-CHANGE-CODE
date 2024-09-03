import 'dart:convert';
import 'dart:io';

import 'package:evolvu/common/common_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Teacher/Attachment.dart';
import '../Utils&Config/DownloadHelper.dart';

class RemarkInfo {
  final String description;
  final String remarkId;
  final String remarkDate;
  final List<Attachment> attachment;

  RemarkInfo({
    required this.description,
    required this.attachment,
    required this.remarkId,
    required this.remarkDate,
  });
}

class RemarkDetailPage extends StatefulWidget {
  final RemarkInfo remarkInfo;

  const RemarkDetailPage({super.key, required this.remarkInfo});

  @override
  _RemarkDetailPageState createState() => _RemarkDetailPageState();
}

class _RemarkDetailPageState extends State<RemarkDetailPage> {
  String shortName = "";
  String academic_yr = "";
  String reg_id = "";
  String projectUrl = "";
  String url = "";

  @override
  void initState() {
    super.initState();
    _getProjectUrl();
  }

  Future<String?> _getProjectUrl() async {
    final prefs = await SharedPreferences.getInstance();
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
    String? schoolInfoJson = prefs.getString('school_info');
    if (schoolInfoJson != null) {
      try {
        Map<String, dynamic> parsedData = json.decode(schoolInfoJson);
        projectUrl = parsedData['project_url'];
        shortName = parsedData['short_name'];
        url = parsedData['url'];
        return url;
      } catch (e) {
        print('Error parsing school info: $e');
        return null;
      }
    } else {
      print('School info not found in SharedPreferences.');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 720.h,
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  widget.remarkInfo.description,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          if (widget.remarkInfo.attachment.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text(
                  'Attachments:',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...widget.remarkInfo.attachment.map((attachment) {
                  bool isFileNotUploaded = (attachment.fileSize / 1024) == 0.00;
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    // Adjust padding
                    leading: Icon(Icons.file_download, size: 25),

                    title: isFileNotUploaded
                        ? Text(
                      'File is not uploaded properly',
                      style:
                      TextStyle(fontSize: 14.sp, color: Colors.red),
                    )
                        : Text(
                      attachment.imageName,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    subtitle: Text(
                      '${(attachment.fileSize / 1024).toStringAsFixed(2)} KB',
                      style: TextStyle(fontSize: 14.sp),
                    ),

                    onTap: () async {
                      DateTime now = DateTime.now();
                      String formattedDate =
                      DateFormat('yyyy-MM-dd').format(now);

                      // String? projectUrl = await _getProjectUrl();
                      if (projectUrl != null) {
                        try {
                          String downloadUrl =
                              projectUrl+'uploads/remark/${widget.remarkInfo.remarkDate}/${widget.remarkInfo.remarkId}/${attachment.imageName}';
                          downloadFile(downloadUrl, context,attachment.imageName);
                          print('Failed downloadUrl $downloadUrl');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('File downloaded successfully.'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to download file: $e'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to retrieve project URL.'),
                          ),
                        );
                      }
                    },
                  );
                }).toList(),
                // SizedBox(height: 20.h),
                // Center(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       _updateHomework();
                //       // Navigator.of(context).pushNamed('/parentDashBoardPage');
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.blue,
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 37, vertical: 6),
                //     ),
                //     child: Text(
                //       'Update',
                //       style: TextStyle(color: Colors.white, fontSize: 16.sp),
                //     ),
                //   ),
                // ),
              ],
            )
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     const Text(
          //       'Attachment:',
          //       style: TextStyle(
          //         fontSize: 15,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     const SizedBox(width: 8.0),
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Row(
          //             children: [
          //               Expanded(
          //                 child: Text(
          //                   remarkInfo.attachment,
          //                   style: const TextStyle(
          //                     fontSize: 14,
          //                   ),
          //                 ),
          //               ),
          //               IconButton(
          //                 enableFeedback: false,
          //                 onPressed: () {
          //                   // Add your action here
          //                 },
          //                 icon: const Icon(
          //                   Icons.download,
          //                   color: Colors.black,
          //                 ),
          //               ),
          //             ],
          //           ),
          //
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
  void downloadFile(String url, BuildContext context,String name) async {
    var path = "/storage/emulated/0/Download/Evolvuschool/Parent/Remark/$name";
    var file = File(path);
    var res = await get(Uri.parse(url));
    file.writeAsBytes(res.bodyBytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Download/Evolvuschool/Parent/Remark/$name File downloaded successfully. '),
      ),
    );

  }
}
