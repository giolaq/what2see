import 'package:polymer/polymer.dart';
import 'dart:html';
import 'monument.dart';
import 'package:csvparser/csvparser.dart';

@CustomTag('monuments-list')
class MonumentsList extends PolymerElement {

  @observable List<Monument> monuments = toObservable([]);

  MonumentsList.created() : super.created() {
    populateList();
  }


  void populateList() {
    monuments.clear();


    String data = "\"hello\",\"world\"\n\"wie\ngeht's\",\"dir\"";

    CsvParser cp = new CsvParser(data, seperator: ",", quotemark: "\"");
    while (cp.moveNext()) {
      while (cp.current.moveNext()) monuments.add(new Monument(cp.current.current, "address"));
    }


  }
}
