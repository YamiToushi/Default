import 'package:bussines_module/frontend/admin/pages/total.dart';
import 'package:bussines_module/frontend/admin/pages/worker_profile.dart'; 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              child: Text(
                'Turon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminHomePage(),
                      ),
                    );
                  });
                }),
            ListTile(
              leading: const Icon(Icons.monetization_on_outlined),
              title: const Text('Total'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Total(),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('turon').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No workers found'));
          }

          var workers = (snapshot.data!.docs.first.data()
              as Map<String, dynamic>)['workers'];

          return ListView.builder(
            itemCount: workers.length,
            itemBuilder: (context, index) {
              var workerName = workers.keys.elementAt(index);
              var workerData = workers[workerName] as Map<String, dynamic>;
              var salary = workerData['salary'] ?? 'N/A';
              var kpi = workerData['kpi'] ?? 'N/A';
              var position = workerData['position'] ?? 'N/A';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(workerName),
                    subtitle: Text('Position: $position'),
                    subtitleTextStyle: const TextStyle(color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkerProfile(
                            workerName: workerName,
                            position: workerData['position'] ?? 'N/A',
                            salary: salary,
                            kpi: kpi,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddWorkerBottomSheet(context);
        },
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showAddWorkerBottomSheet(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController salaryController = TextEditingController();
    TextEditingController kpiController = TextEditingController();
    TextEditingController positionController = TextEditingController();

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
                'Add Worker',
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
              TextField(
                controller: positionController,
                decoration: const InputDecoration(
                  labelText: 'Position',
                ),
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
                    onPressed: () {
                      String name = nameController.text.trim();
                      String salary = salaryController.text.trim();
                      String kpi = kpiController.text.trim();
                      String position = positionController.text.trim();

                      if (name.isNotEmpty &&
                          salary.isNotEmpty &&
                          kpi.isNotEmpty &&
                          position.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection('turon')
                            .doc('q9quQ73VUzhRIl3tbIg7')
                            .update({
                          'workers.$name': {
                            'salary': int.parse(salary),
                            'kpi': int.parse(kpi),
                            'position': position,
                          },
                        }).then((_) {
                          setState(() {});
                          Navigator.of(context).pop();
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
}
