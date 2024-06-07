class Note {
  int? id;
  String body;

  Note({this.id, required this.body});

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      body: map['body'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
    };
  }
}
