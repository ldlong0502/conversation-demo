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
  List<String> splitFuriganaVoc(String text) {
    return text.split(',');
  }
  String getBehind(String pair) {
    return pair.substring(pair.indexOf('|') + 1, pair.length).trim();
  }

  String getFront(String pair) {
    return pair.substring(0, pair.indexOf('|')).trim();
  }

  List<String> extractPathDataList(String inputString) {
    final regex = RegExp(r'<path d="([^"]+)"\/>');
    final matches = regex.allMatches(inputString);

    final pathDataList = <String>[];
    for (final match in matches) {
      final pathData = match.group(1);
      pathDataList.add(pathData!);
    }

    return pathDataList;
  }

  List<String> extractRhythmKanji(String text) {
    return text.split('/');
  }
  List<int> extractVocabularies(String text) {
    var listVoc = <int>[];
    final list = text.split(';');
    for(var item in list){
      listVoc.add(int.parse(item.trim()));
    }
    return listVoc;
  }
}