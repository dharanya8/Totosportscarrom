import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'teammodel.dart';

class AppColors {
  static const Color background = Color(0xFFF5F7FB);
  static const Color card = Colors.white;

  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFFEAF2FF);

  static const Color text = Color(0xFF1E293B);
  static const Color subtitle = Color(0xFF64748B);
  static const Color hint = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);

  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);
}

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userPhone;

  const ProfileScreen({super.key, required this.userName, required this.userPhone});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showTeams = false;
  bool showCreateTeam = false;
  Map<int, bool> showMemberForm = {};
  final teamController = TextEditingController();
  final phoneController = TextEditingController();

  final memberNameController = TextEditingController();
  final memberPhoneController = TextEditingController();

  @override
  void dispose() {
    teamController.dispose();
    phoneController.dispose();
    memberNameController.dispose();
    memberPhoneController.dispose();
    super.dispose();
  }

  void createTeam() {
    if (teamController.text.trim().isEmpty || phoneController.text.trim().length != 10) {
      return;
    }

    TeamModel.createdTeams.add(
      Team(teamName: teamController.text.trim(), phone: phoneController.text.trim(), members: []),
    );

    teamController.clear();
    phoneController.clear();

    setState(() {
      showCreateTeam = false;
      showTeams = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Team Created Successfully"),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void logout() {
    TeamModel.clearTeams();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget customField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.text, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.hint),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget actionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: cardDecoration(),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: AppColors.primaryLight,
                      child: const Icon(Icons.person, size: 50, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.userPhone, style: const TextStyle(color: AppColors.subtitle)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: actionButton(
                    title: "My Teams",
                    icon: Icons.groups,
                    onTap: () {
                      setState(() {
                        showTeams = !showTeams;
                        showCreateTeam = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: actionButton(
                    title: "Create Team",
                    icon: Icons.add,
                    onTap: () {
                      setState(() {
                        showCreateTeam = !showCreateTeam;
                        showTeams = false;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (showCreateTeam)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: cardDecoration(),
                child: Column(
                  children: [
                    const Text(
                      "Create Team",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 20),
                    customField(teamController, "Team Name"),
                    const SizedBox(height: 15),
                    customField(phoneController, "Phone Number"),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: createTeam,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text("Create Team", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),

            if (showTeams) ...[
              const SizedBox(height: 20),

              TeamModel.createdTeams.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: cardDecoration(),
                      child: const Center(
                        child: Text(
                          "No Teams Created Yet",
                          style: TextStyle(color: AppColors.subtitle),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: TeamModel.createdTeams.length,
                      itemBuilder: (context, index) {
                        final team = TeamModel.createdTeams[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: cardDecoration(),
                          child: ExpansionTile(
                            title: Text(
                              team.teamName,
                              style: const TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              team.phone,
                              style: const TextStyle(color: AppColors.subtitle),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    customField(memberNameController, "Member Name"),
                                    const SizedBox(height: 12),
                                    customField(memberPhoneController, "Member Phone"),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        if (memberNameController.text.isEmpty ||
                                            memberPhoneController.text.length != 10) {
                                          return;
                                        }

                                        team.members.add(
                                          Member(
                                            name: memberNameController.text,
                                            phone: memberPhoneController.text,
                                          ),
                                        );

                                        memberNameController.clear();
                                        memberPhoneController.clear();

                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                      ),
                                      icon: const Icon(Icons.person_add),
                                      label: const Text("Add Member"),
                                    ),
                                    const SizedBox(height: 15),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: team.members.length,
                                      itemBuilder: (context, memberIndex) {
                                        final member = team.members[memberIndex];

                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: AppColors.primaryLight,
                                            child: const Icon(
                                              Icons.person,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          title: Text(
                                            member.name,
                                            style: const TextStyle(color: AppColors.text),
                                          ),
                                          subtitle: Text(
                                            member.phone,
                                            style: const TextStyle(color: AppColors.subtitle),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],

            const SizedBox(height: 25),

            SizedBox(
              width: 285,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
