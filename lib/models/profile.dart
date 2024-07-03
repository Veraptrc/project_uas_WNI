class Profile {
  String? id;
  String? profileUrl;
  final String username;
  final String alamat;
  String? email;
  final String noTelp;
  final String tanggalLahir;
  final String jenisKelamin;

  Profile(
      {this.id,
      this.profileUrl,
      required this.username,
      required this.alamat,
      this.email,
      required this.noTelp,
      required this.tanggalLahir,
      required this.jenisKelamin});
}
