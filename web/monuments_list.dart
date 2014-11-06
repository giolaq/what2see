// Imports the HTML library, needed for DOM manipulations, client-side http req.
import 'dart:html';

// Imports the polymer package
import 'package:polymer/polymer.dart';
// Imports the csvparser package
import 'package:csvparser/csvparser.dart';

// Defines the Monument class
class Monument {
  String name;
  String address;

  // Terse syntax for a constructor
  Monument(this.name, this.address);
}

// Defines this class to be a custom element.
// The tag name will be `monuments-list`
@CustomTag('monuments-list')
class MonumentsList extends PolymerElement {

  // This holds all the Monument class instances
  List<Monument> buffer = [];
  // We use this as a cursor. Holds the position of the current element of buffer.
  int currentBufferPosition;
  // When a Monument is ready to be displayed, we copy it from `buffer` to `monuments`.
  // As this list is "observable", changes to this list will immediately reflect
  // on the GUI
  @observable List<Monument> monuments = toObservable([]);

  MonumentsList.created() : super.created() {
    // Load CSV
    String url = "/Elenco_Monumenti_2011.csv";
    HttpRequest.getString(url).then((String response) {
      populateMonumentsList(response);
    });

  }

  // Parses the CSV, and loads the first 24 monuments
  void populateMonumentsList(String response) {
    CsvParser cp = new CsvParser(response, seperator: ";", quotemark: "\"", setHeaders: true);

    // Move three positions
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

  // Triggered by the infinite scrolling function, this will load more elements
  // e.g., will copy elements from `buffer` to `monuments`
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
