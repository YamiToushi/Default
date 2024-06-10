import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerHomePage extends StatelessWidget {
  const WorkerHomePage({super.key});

  Future<Map<String, dynamic>> _getWorkerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String workerName = prefs.getString('workerName') ?? '';
    
    if (workerName.isEmpty) {
      throw Exception('Worker name not found in shared preferences');
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('turon').get();
    for (var document in querySnapshot.docs) {
      var workers = document['workers'] as Map<String, dynamic>;
      if (workers.containsKey(workerName)) {
        return workers[workerName] as Map<String, dynamic>;
      }
    }

    throw Exception('Worker data not found in Firestore');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Home Page'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getWorkerData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No worker data found'));
          } else {
            var workerData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Position: ${workerData['position']}'),
                  Text('Salary: ${workerData['salary']}'),
                  Text('KPI: ${workerData['kpi']}'),
                  const SizedBox(height: 20),
                  const Text('Attendance:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...workerData['attendance'].entries.map((entry) {
                    return Text('${entry.key}: ${entry.value}');
                  }).toList(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
