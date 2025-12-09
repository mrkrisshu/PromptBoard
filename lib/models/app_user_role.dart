/// Enum representing user roles in the application
enum AppUserRole {
  user,
  admin;

  String toJson() => name;

  static AppUserRole fromJson(String json) {
    return AppUserRole.values.firstWhere(
      (role) => role.name == json,
      orElse: () => AppUserRole.user,
    );
  }
}
