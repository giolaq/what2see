import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:csvparser/csvparser.dart';

class Monument {
  String name;
   String address;
   String thmbUrl;

   Monument(this.name, this.address);
}

@CustomTag('monuments-list')
class MonumentsList extends PolymerElement {

  List<Monument> buffer = [];
  int currentBufferPosition;
  @observable List<Monument> monuments = toObservable([]);

  MonumentsList.created() : super.created() {
    // Load CSV
    String url = "/Elenco_Monumenti_2011.csv";
    HttpRequest.getString(url).then((String response) {
      populateMonumentsList(response);
    });

  }

  void populateMonumentsList(String response) {
    CsvParser cp = new CsvParser(response, seperator: ";", quotemark: "\"", setHeaders: true);

    // Move three positions
    // TODO: ugly!
    cp.moveNext();
    cp.moveNext();
    cp.moveNext();

    while (cp.moveNext()) {
      Map line = cp.getLineAsMap(headers: ['name', 'address']);

      if (line['name'].isNotEmpty) {
        buffer.add(new Monument(line['name'], line['address']));
      }
    }

    for (var i = 0; i < 24; i++) {
      monuments.add(buffer[i]);
    }
    currentBufferPosition = 24;
  }

  void loadMore() {
    int nextBufferPosition;
    for (var i = currentBufferPosition; i < currentBufferPosition + 8; i++) {
      if (i < buffer.length) {
        monuments.add(buffer[i]);
        nextBufferPosition = i;
      }
    }
    currentBufferPosition = nextBufferPosition;
  }


}
