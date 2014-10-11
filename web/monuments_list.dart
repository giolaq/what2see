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
          if ( line['name'].isNotEmpty) {
            
            String thmbUrl = getThmbUrl(line['name']);
            monuments.add(new Monument(line['name'], line['address'], thmbUrl));

            
          }
        //}
    }


  }
  
  String getThmbUrl(String name) {
    
    String query = "https://ajax.googleapis.com/ajax/services/search/images";
    
    HttpRequest httpR = new HttpRequest();
    String q = Uri.encodeQueryComponent(name);
    httpR.open('GET', query);
    httpR.setRequestHeader('Access-Control-Allow-Origin', 'null');
    HttpRequest.getString('$query?v=1.0&q=$name')
              .then((String resp) {
      print(resp);
            });
    
    return "null";
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
