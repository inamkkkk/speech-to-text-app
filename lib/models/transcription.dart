class Transcription {
  final int? id;
  final String text;

  Transcription({this.id, required this.text});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }

  factory Transcription.fromMap(Map<String, dynamic> map) {
    return Transcription(
      id: map['id'],
      text: map['text'],
    );
  }
}