import 'package:bussines_module/frontend/admin/pages/home_page.dart';
import 'package:bussines_module/frontend/worker/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  Future<void> _submit(
      BuildContext context, int id, int password, String name) async {
    CollectionReference turonCollection =
        FirebaseFirestore.instance.collection('turon');

    QuerySnapshot querySnapshot = await turonCollection
        .where('id', isEqualTo: id)
        .where('password', isEqualTo: password)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (data['adminName'] == name) {
        await prefs.setString('userType', 'admin');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomePage()),
        );
      } else if (data['workers'] != null && data['workers'][name] != null) {
        await prefs.setString('userType', 'worker');
        await prefs.setString('workerName', name);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WorkerHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid name')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid id or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int id = 0; 
    int password = 0;
    String name = '';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              const Text(
                'Welcome',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 10),
              const Text('Please enter your ID, password, and name',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 80),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) => id = int.tryParse(value) ?? 0,
                decoration: const InputDecoration(
                    hintText: 'ID', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) => password = int.tryParse(value) ?? 0,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Password', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) => name = value,
                decoration: const InputDecoration(
                    hintText: 'Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submit(context, id, password, name),
                  child: Text('Submit',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
