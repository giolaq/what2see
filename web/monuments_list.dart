import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'monument.dart';
import 'package:csvparser/csvparser.dart';
import "package:jsonp/jsonp.dart" as jsonp;

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
      if (line['name'].isNotEmpty) {

        getThmbUrl(line['name']).then((onValue) {

          String thmbUrl = onValue['responseData']['results'][0]['url'];

          monuments.add(new Monument(line['name'], line['address'], thmbUrl));

        });



      }
      //}
    }


  }

  Future getThmbUrl(String name) {

    String query = "https://ajax.googleapis.com/ajax/services/search/images";

    String q = Uri.encodeQueryComponent(name);


    Future<dynamic> result = jsonp.fetch(uri: '$query?v=1.0&q=$name&callback=?');

    return result;
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
