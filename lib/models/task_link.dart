// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaskLink {
  String? text;
  String? link;
  TaskLink({
    this.text,
    this.link,
  });

  TaskLink copyWith({
    String? text,
    String? link,
  }) {
    return TaskLink(
      text: text ?? this.text,
      link: link ?? this.link,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'link': link,
    };
  }

  factory TaskLink.fromMap(Map<String, dynamic> map) {
    return TaskLink(
      text: map['text'] != null ? map['text'] as String : null,
      link: map['link'] != null ? map['link'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskLink.fromJson(String source) =>
      TaskLink.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TaskLink(text: $text, link: $link)';

  @override
  bool operator ==(covariant TaskLink other) {
    if (identical(this, other)) return true;

    return other.text == text && other.link == link;
  }

  @override
  int get hashCode => text.hashCode ^ link.hashCode;
}
