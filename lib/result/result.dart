import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  // Visibility flags for the cards
  int cbseCardVisible = 0; // 1 means visible, 0 means hidden
  int viewReportCardVisible = 0; // 1 means visible, 0 means hidden
  int resultChartVisible = 0; // 1 means visible, 0 means hidden

  // Sample static data to populate the design for the expandable list
  List<Map<String, dynamic>> examData = [
    {
      'Exam_name': 'Midterm Exam',
      'Details': [
        {
          'Subject': 'English',
          'Mark_headings': 'Periodic Test will be conducted in March ',
          'Marks_obtained': '25',
          'Highest_marks': '30'
        },
        {
          'Subject': 'Hindi',
          'Mark_headings': 'Term Exam',
          'Marks_obtained': '55',
          'Highest_marks': '60'
        },
        {
          'Subject': 'Math',
          'Mark_headings': 'Periodic Test is on this date',
          'Marks_obtained': '30',
          'Highest_marks': '40'
        },
        {
          'Subject': 'Science',
          'Mark_headings': 'Term Exam',
          'Marks_obtained': '50',
          'Highest_marks': '60'
        },
        {
          'Subject': 'Physics',
          'Mark_headings': 'Term Exam',
          'Marks_obtained': '50',
          'Highest_marks': '60'
        }
      ]
    },
    {
      'Exam_name': 'Final Exam',
      'Details': [
        {
          'Subject': 'English',
          'Mark_headings': 'Periodic Test',
          'Marks_obtained': '25',
          'Highest_marks': '30'
        },
        {
          'Subject': 'Hindi',
          'Mark_headings': 'Term Exam',
          'Marks_obtained': '55',
          'Highest_marks': '60'
        },
        {
          'Subject': 'Math',
          'Mark_headings': 'Periodic Test',
          'Marks_obtained': '30',
          'Highest_marks': '40'
        },
        {
          'Subject': 'Science',
          'Mark_headings': 'Term Exam',
          'Marks_obtained': '50',
          'Highest_marks': '60'
        },
        {
          'Subject': 'Physics',
          'Mark_headings': 'Term Exam',
          'Marks_obtained': '50',
          'Highest_marks': '60'
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    bool isAnyCardVisible = cbseCardVisible == 1 || viewReportCardVisible == 1 || resultChartVisible == 1;

    // Outer container with the gradient background
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make scaffold background transparent to show the gradient
        appBar: AppBar(
          toolbarHeight: 50.h,
          title: Text(
            "Result",
            style: TextStyle(fontSize: 20.sp, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              // Conditional rendering of the grid if at least one card is visible
              if (isAnyCardVisible)
                GridView.count(
                  shrinkWrap: true, // Let the grid take only the space it needs
                  crossAxisCount: 3, // Display 3 cards in each row
                  crossAxisSpacing: 7.w, // Space between columns
                  mainAxisSpacing: 7.h, // Space between rows
                  children: [
                    if (cbseCardVisible == 1)
                      _buildCard('CBSE Report Card', Icons.school, Colors.deepPurple, () {
                        // Handle CBSE Report Card tap
                      }),
                    if (viewReportCardVisible == 1)
                      _buildCard('View Report Card', Icons.insert_drive_file, Colors.teal, () {
                        // Handle View Report Card tap
                      }),
                    if (resultChartVisible == 1)
                      _buildCard('Result Chart', Icons.bar_chart, Colors.orange, () {
                        // Handle Result Chart tap
                      }),
                  ],
                ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(6),
                  itemCount: examData.length,
                  itemBuilder: (context, index) {
                    final exam = examData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildExpandableCard(exam['Exam_name'], exam['Details']),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card Builder Function for the top grid
  Widget _buildCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return FractionallySizedBox(
      widthFactor: 1, // Full width of the grid item
      heightFactor: 0.80, // Reduce the height of the card
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Card background color
            borderRadius: BorderRadius.circular(16), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Shadow color
                blurRadius: 10,
                offset: Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(icon, size: 45.sp, color: color),
              const SizedBox(height: 6),
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 119, 105, 105),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build an expandable card dynamically for exam results
  Widget _buildExpandableCard(String title, List<dynamic> details) {
    return Card(
      elevation: 4,
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            if (title == 'Final Exam') // Show certificate icon only for 'Final Exam'
              Icon(Icons.emoji_events,
                  color: Color.fromARGB(255, 197, 185, 75),
                  size: 25), // Certificate icon
          ],
        ),
        children: details.map((detail) {
          return _buildResultRow(
            detail['Subject'],
            detail['Mark_headings'],
            '${detail['Marks_obtained']}/${detail['Highest_marks']}',
          );
        }).toList(),
      ),
    );
  }

  // Function to build each result row dynamically for the expandable exam cards
  Widget _buildResultRow(String subject, String test, String score) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Subject Column with fixed width
          SizedBox(
            width: 80.w, // Fixed width for subject text
            child: Text(
              subject,
              style: TextStyle(color: Color.fromARGB(255, 34, 28, 28)),
              textAlign: TextAlign.left, // Align text to the left
              overflow: TextOverflow.ellipsis, // Handle long text
            ),
          ),
          
          // Mark Headings Column with expanded width
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                test,
                style: TextStyle(fontWeight: FontWeight.w600),
                maxLines: 2, // Limit to 2 lines
                overflow: TextOverflow.ellipsis, // Show '...' if the text exceeds
                softWrap: true, // Allow wrapping
                textAlign: TextAlign.center, // Align heading to the center
              ),
            ),
          ),
          
          // Marks Column with fixed width
          SizedBox(
            width: 50.w, // Fixed width for score text
            child: Text(
              score,
              style: TextStyle(color: Colors.blue),
              textAlign: TextAlign.right, // Align text to the right
            ),
          ),
        ],
      ),
    );
  }
}
