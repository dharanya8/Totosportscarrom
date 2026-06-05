class Member {
  String name;
  String phone;

  Member({required this.name, required this.phone});
}

class Team {
  String teamName;
  String phone;
  List<Member> members;

  Team({required this.teamName, required this.phone, required this.members});
}

class TeamModel {
  static List<Team> createdTeams = [];

  static List<Team> registeredTeams = [];

  static void clearTeams() {
    createdTeams.clear();
    registeredTeams.clear();
  }
}

//
