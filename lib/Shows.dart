class Show {
  String title = "", body = "", imageURL = "";
  late List<dynamic> genre = [];
  Show(String a, String b, String c, List<dynamic>? x) {
    title = a;
    body = b;
    imageURL = c;
    if (x != null) genre = [...x];
  }
  String? genres() {
    String str = "";
    for (String g in genre) str += (g.toString() + " ");
    return str;
  }
}
