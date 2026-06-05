import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'team_data.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController teamController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? selectedSport;

  List<Map<String, String>> registeredTeams = [];

  final List<String> sports = [
    "Carrom Singles",
    "Carrom Doubles",
    "Carrom Knockout",
    "Carrom Robin",
  ];

  void registerTeam() {
    if (!_formKey.currentState!.validate()) return;

    final teamName = teamController.text.trim();
    final phone = phoneController.text.trim();

    bool isValidTeam = TeamData.createdTeams.any(
      (team) =>
          team["teamName"]!.toLowerCase().trim() == teamName.toLowerCase().trim() &&
          team["phone"] == phone,
    );

    if (!isValidTeam) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Only created teams can register"),
        ),
      );
      return;
    }

    bool alreadyRegistered = registeredTeams.any(
      (team) =>
          team["teamName"]!.toLowerCase() == teamName.toLowerCase() &&
          team["sport"] == selectedSport,
    );

    if (alreadyRegistered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text("Team already registered for this sport"),
        ),
      );
      return;
    }

    setState(() {
      registeredTeams.add({"teamName": teamName, "phone": phone, "sport": selectedSport!});
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(backgroundColor: Colors.green, content: Text("Registered Successfully")),
    );

    teamController.clear();
    phoneController.clear();

    setState(() {
      selectedSport = null;
    });
  }

  InputDecoration inputStyle(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),

      prefixIcon: Icon(icon, color: Colors.blue),

      filled: true,
      fillColor: Colors.white,

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFD6DCE5), width: 1.2),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Widget shadowWrapper({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  void dispose() {
    teamController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Tournament Registration",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    shadowWrapper(
                      child: TextFormField(
                        controller: teamController,

                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),

                        decoration: inputStyle("Team Name", Icons.groups),
                        validator: (value) => value!.isEmpty ? "Enter team name" : null,
                      ),
                    ),

                    const SizedBox(height: 15),

                    shadowWrapper(
                      child: TextFormField(
                        controller: phoneController,

                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),

                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: inputStyle("Phone Number", Icons.phone),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter phone number";
                          }
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return "Enter 10 digit number";
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 15),

                    shadowWrapper(
                      child: DropdownButtonFormField<String>(
                        value: selectedSport,

                        hint: const Text(
                          "Select Sport",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        style: const TextStyle(
                          color: Colors.black, // Selected value color
                          fontSize: 16,
                        ),

                        dropdownColor: Colors.white,

                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.sports_esports,
                            color: Colors.blue, // Icon color
                          ),

                          filled: true,
                          fillColor: Colors.white,

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Color(0xFFD6DCE5), width: 1.2),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),

                        items: sports.map((sport) {
                          return DropdownMenuItem<String>(
                            value: sport,
                            child: Text(sport, style: const TextStyle(color: Colors.black)),
                          );
                        }).toList(),

                        onChanged: (value) {
                          setState(() {
                            selectedSport = value;
                          });
                        },

                        validator: (value) => value == null ? "Select sport" : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: registerTeam,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text(
                          "Register Team",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Registered Teams",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),
            ),

            const SizedBox(height: 15),

            if (registeredTeams.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text("No teams registered yet", style: TextStyle(color: Colors.grey)),
                ),
              ),

            ...registeredTeams.map(
              (team) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10)],
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.emoji_events, color: Colors.white),
                  ),
                  title: Text(team["teamName"]!),
                  subtitle: Text("${team["phone"]} • ${team["sport"]}"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
