import 'package:flutter/material.dart';
import 'package:evolvu/common/common_style.dart';

class NoticeNoteCard extends StatelessWidget {
  final String teacher;
  final String remarksubject;
  final String type;
  final String readStatus;
  final VoidCallback onTap;

  const NoticeNoteCard({
    required this.teacher,
    required this.remarksubject,
    required this.type,
    required this.readStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = readStatus == '0' ? Colors.grey : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/notice.png',
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type,
                          style: Commonstyle.noticeText,
                        ),
                        const SizedBox(height: 5),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Created By: ',
                                style: Commonstyle.lableBold,
                              ),
                              TextSpan(
                                text: teacher,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 2, // Set the maximum number of lines
                          overflow: TextOverflow.ellipsis, // Handle text overflow with ellipsis
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Subject:',
                            style: Commonstyle.lableBold,
                          ),
                          TextSpan(
                            text: ' $remarksubject', // Add a space before the subject
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
