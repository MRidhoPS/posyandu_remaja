import 'package:flutter/material.dart';
import 'package:posrem_webapp/presentation/page/detail_user.dart';
import 'package:posrem_webapp/presentation/provider/list_provider.dart';
import 'package:provider/provider.dart';

class DataUsers extends StatefulWidget {
  const DataUsers({super.key});

  @override
  State<DataUsers> createState() => _DataUsersState();
}

class _DataUsersState extends State<DataUsers> {
  @override
  void initState() {
    super.initState();
    // load semua user saat halaman dibuka
    Future.microtask(() {
      context.read<ListProvider>().fethAllUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Users'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔎 Search Input
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (val) {
                    if (val.isEmpty) {
                      // kalau kosong, tampilkan semua data
                      context.read<ListProvider>().fethAllUser();
                    } else {
                      context
                          .read<ListProvider>()
                          .searchUser(val.toLowerCase());
                    }
                  },
                ),
              ),
            ),

            // 📋 List Data
            Expanded(
              child: Consumer<ListProvider>(
                builder: (context, listProvider, child) {
                  if (listProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (listProvider.error != null) {
                    return Center(
                      child: Text('Error: ${listProvider.error}'),
                    );
                  } else if (listProvider.users.isEmpty) {
                    return const Center(
                      child: Text('No data found'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: listProvider.users.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> user = listProvider.users[index];
                        return ListTile(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailUser(userId: user['id']),
                              ),
                            );
                            // 🔄 refresh lagi setelah back
                            if (context.mounted) {
                              context.read<ListProvider>().fethAllUser();
                            }
                          },
                          title: Text(user['name'] ?? 'No Name'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
