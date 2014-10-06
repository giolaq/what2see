import 'package:polymer/polymer.dart';
import 'dart:html';
import 'monument.dart';
import 'package:csvparser/csvparser.dart';

@CustomTag('monuments-list')
class MonumentsList extends PolymerElement {

  @observable List<Monument> monuments = toObservable([]);

  MonumentsList.created() : super.created() {
    loadData();
  }



  void populateList(String data) {
    monuments.clear();


    CsvParser cp = new CsvParser(data, seperator: ";", quotemark: "\"", setHeaders: true);
    //set pointer below header
    cp.moveNext();
    cp.moveNext();
    cp.moveNext();
    while (cp.moveNext()) {

      //while (cp.current.moveNext())
        //{
          Map line = cp.getLineAsMap(headers: ['name', 'address']);
          if ( line['name'].isNotEmpty)
             monuments.add(new Monument(line['name'], line['address']));
        //}
    }


  }

  void loadData() {
    var url = "http://localhost:8080/Elenco_Monumenti_2011.csv";

    // call the web server asynchronously
    var request = HttpRequest.getString(url).then(onDataLoaded);
  }

// print the raw json response text from the server
  void onDataLoaded(String responseText) {
    populateList(responseText);
  }

}
