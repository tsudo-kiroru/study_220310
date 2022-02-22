class ProfileModel {
  ProfileModel({String? name, int? totalPost}) {
    if (name != null) { this.name = name; }
    if (totalPost != null) { this.totalPost = totalPost; }
  }
  String name = "Nickname";
  int totalPost = 0;
}
