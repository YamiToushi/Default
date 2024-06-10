import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class WorkerProfile extends StatefulWidget {
  final String workerName;
  final String position;
  final int salary;
  final int kpi;

  const WorkerProfile({
    required this.workerName,
    required this.position,
    required this.salary,
    required this.kpi,
    super.key,
  });

  @override
  _WorkerProfileState createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
  late DateTime _currentDate;
  late String _formattedDate;
  int _absencesThisMonth = 0;
  bool _isPresent = false;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _formattedDate = DateFormat('yyyy-MM-dd').format(_currentDate);
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('turon')
        .doc('q9quQ73VUzhRIl3tbIg7') 
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> workers = data['workers'][widget.workerName];
      Map<String, dynamic> attendance = workers['attendance'] ?? {};
      int currentMonth = _currentDate.month;

      _absencesThisMonth = DateTime(_currentDate.year, currentMonth)
              .difference(DateTime(_currentDate.year, currentMonth - 1))
              .inDays -
          attendance.values
              .where((date) => DateTime.parse(date).month == currentMonth)
              .length;

      setState(() {
        _isPresent = attendance[_formattedDate] != null;
      });
    }
  }

  Future<void> _markAsPresent() async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('turon')
        .doc('q9quQ73VUzhRIl3tbIg7'); 

    DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> workers = data['workers'];
      Map<String, dynamic> workerData = workers[widget.workerName];
      Map<String, dynamic> attendance = workerData['attendance'] ?? {};

      setState(() {
        attendance[_formattedDate] = _formattedDate;
        _isPresent = true;
      });

      await docRef.update({
        'workers.${widget.workerName}.attendance': attendance,
      });
    }
  }

  Future<void> _removeWorker() async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('turon')
        .doc('q9quQ73VUzhRIl3tbIg7'); 

    DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> workers = data['workers'];

      workers.remove(widget.workerName);

      await docRef.update({'workers': workers});

      Navigator.of(context).pop(); 
    }
  }

  Future<void> _showEditWorkerBottomSheet() async {
    TextEditingController nameController =
        TextEditingController(text: widget.workerName);
    TextEditingController positionController =
        TextEditingController(text: widget.position);
    TextEditingController salaryController =
        TextEditingController(text: widget.salary.toString());
    TextEditingController kpiController =
        TextEditingController(text: widget.kpi.toString());

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Edit Worker',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(
                  labelText: 'Position',
                ),
              ),
              TextField(
                controller: salaryController,
                decoration: const InputDecoration(
                  labelText: 'Salary',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: kpiController,
                decoration: const InputDecoration(
                  labelText: 'KPI',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      String newName = nameController.text.trim();
                      String newPosition = positionController.text.trim();
                      String newSalary = salaryController.text.trim();
                      String newKpi = kpiController.text.trim();

                      DocumentReference docRef = FirebaseFirestore.instance
                          .collection('turon')
                          .doc(
                              'q9quQ73VUzhRIl3tbIg7'); // replace with your document ID

                      DocumentSnapshot doc = await docRef.get();

                      if (doc.exists) {
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;
                        Map<String, dynamic> workers = data['workers'];
                        Map<String, dynamic> workerData =
                            workers[widget.workerName];

                        if (newName.isNotEmpty &&
                            newName != widget.workerName) {
                          workers.remove(widget.workerName);
                          workerData['name'] = newName;
                          workers[newName] = workerData;
                        }

                        if (newPosition.isNotEmpty) {
                          workerData['position'] = newPosition;
                        }

                        if (newSalary.isNotEmpty) {
                          workerData['salary'] = int.parse(newSalary);
                        }

                        if (newKpi.isNotEmpty) {
                          workerData['kpi'] = int.parse(newKpi);
                        }

                        await docRef.update({'workers': workers});

                        setState(() {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkerProfile(
                                workerName: newName.isNotEmpty
                                    ? newName
                                    : widget.workerName,
                                position: newPosition.isNotEmpty
                                    ? newPosition
                                    : widget.position,
                                salary: newSalary.isNotEmpty
                                    ? int.parse(newSalary)
                                    : widget.salary,
                                kpi: newKpi.isNotEmpty
                                    ? int.parse(newKpi)
                                    : widget.kpi,
                              ),
                            ),
                          );
                        });
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workerName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Position: ${widget.position}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('Salary: ${widget.salary}',
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('KPI: ${widget.kpi}',
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
                Container(
                  height: 150,
                  width: 150,
                  color: Theme.of(context).primaryColorDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Attendance for today:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(
                    _isPresent
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: _isPresent
                        ? Colors.green
                        : Theme.of(context).primaryColorDark,
                    size: 30,
                  ),
                  onPressed: _isPresent ? null : _markAsPresent,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Existence this month: $_absencesThisMonth',
              style: const TextStyle(fontSize: 20),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _removeWorker,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text(
                    'Remove Worker',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                ElevatedButton(
                  onPressed: _showEditWorkerBottomSheet,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text(
                    'Edit Worker',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
