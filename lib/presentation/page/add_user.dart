import 'package:flutter/material.dart';
import 'package:posrem_webapp/presentation/page/home_user.dart';
import 'package:posrem_webapp/presentation/provider/add_user_provider.dart';
import 'package:provider/provider.dart';

class AddUser extends StatelessWidget {
  const AddUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SizedBox(
            width: 500,
            height: double.infinity,
            child: FormAddUser(),
          ),
        ),
      ),
    );
  }
}

class FormAddUser extends StatelessWidget {
  const FormAddUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final addProvider = Provider.of<AddUserProvider>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextFormField(
          controller: addProvider.nameController,
          decoration: const InputDecoration(
            label: Text('Name'),
          ),
        ),
        DropDownGender(),
        TextFormField(
          controller: addProvider.bornController,
          decoration: const InputDecoration(
            label: Text('Born'),
          ),
        ),
        TextFormField(
          controller: addProvider.religionController,
          decoration: const InputDecoration(
            label: Text('Religion'),
          ),
        ),
        TextFormField(
          controller: addProvider.addressController,
          decoration: const InputDecoration(
            label: Text('Address'),
          ),
        ),
        TextFormField(
          controller: addProvider.educationController,
          decoration: const InputDecoration(
            label: Text('Education'),
          ),
        ),
        TextFormField(
          controller: addProvider.phoneNumController,
          decoration: const InputDecoration(
            label: Text('Phone Number'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const ButtonAddUser(),
      ],
    );
  }
}

class ButtonAddUser extends StatelessWidget {
  const ButtonAddUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddUserProvider>(
      builder: (context, addUserProvider, child) {
        return ElevatedButton(
          onPressed: () {
            addUserProvider.addUser();

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
          },
          child: Text(
            addUserProvider.isLoading ? "Loading..." : 'Add User',
          ),
        );
      },
    );
  }
}

class DropDownGender extends StatelessWidget {
  DropDownGender({super.key});

  final List<String> genderList = ['Perempuan', 'Pria'];

  @override
  Widget build(BuildContext context) {
    return Selector<AddUserProvider, String>(
      selector: (context, provider) => provider.selectedGender,
      builder: (context, selectedGender, child) {
        return DropdownButtonFormField(
          value: selectedGender,
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF4B4B4B)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: const TextStyle(color: Color(0xFF4B4B4B)),
          items: genderList
              .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              // Memastikan perubahan pada gender hanya terjadi jika nilainya valid
              context.read<AddUserProvider>().setGender(value);
            }
          },
        );
      },
    );
  }
}
