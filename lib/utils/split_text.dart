class SplitText {
  List<String> splitJapanese(String text) {
    List<String> a = [];
    List<String> pairs = text.split('}');
    for(int i = 0 ; i< pairs.length; i++)
    {
      var k = pairs[i].split('{');
      for(int n =0 ; n< k.length;n++) {
        a.add(k[n]);
      }
    }
    return a;
  }
  String getBehind(String pair) {
    return pair.substring(pair.indexOf('|') + 1, pair.length).trim();
  }

  String getFront(String pair) {
    return pair.substring(0, pair.indexOf('|')).trim();
  }
}