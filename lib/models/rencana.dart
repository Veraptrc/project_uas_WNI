class Rencana {
  String? id;
  final String wisataId;
  final DateTime waktuBerangkat;
  final String userId;

  Rencana({
    this.id,
    required this.wisataId,
    required this.waktuBerangkat,
    required this.userId,
  });
}
