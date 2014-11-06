// Import the HTML library (needed for DOM manipulation, client-side http req)
import 'dart:html';
// Import the async library, needed for the Future object
import 'dart:async';

// Import the polymer package
import 'package:polymer/polymer.dart';
// Import the paper_dialog library from the paper_elements package
import 'package:paper_elements/paper_dialog.dart';
// Import the jsonp library using `jsonp` as namespace
import 'package:jsonp/jsonp.dart' as jsonp;

// Define this class to be a custom element
// `x-monument` is the custom tag
@CustomTag('x-monument')
class XMonument extends PolymerElement {

  // With the `@published` annotation, we define these as attributes, e.g.
  // <x-monument address="Route 66"></x-monument>
  @published String name = "";
  @published String address = "";

  // This will hold the URL of the image retrieved by Google Search Images API
  @observable String imageSrc = "";

  // Runs the create() method of its superclass (PolymerElement)
  XMonument.created() : super.created();

  // Runs when the element is attached to DOM
  @override
  void attached() {
    super.attached();
    // Runs the getThumbnailSrc method to retrieve the image
    getThumbnailSrc(name).then((String src) {
      if (src.isNotEmpty) {
        // Sets the field imageSrc to src. Changes are immediately reflected
        // on the GUI
        this.imageSrc = src;
      }
    });

    // Selects the #show element from the Shadow DOM.
    shadowRoot.querySelector("#show").onClick.listen((_) {
      // Selects the #dialog element, casts it as a PaperDialog element and
      // runs the .toggle() method.
      (shadowRoot.querySelector("#dialog") as PaperDialog).toggle();
    });
  }

  // This method returns a Future. This means that this method doesn't return
  // immediately a value, but it returns it when the value is available.
  // In this case, the value is available when the function jsonp.fetch() returns.
  Future<String> getThumbnailSrc(String name) {
    var completer = new Completer();
    String BASE_URL = "https://ajax.googleapis.com/ajax/services/search/images";
    String query = Uri.encodeQueryComponent(name + " Roma");

    jsonp.fetch(uri: BASE_URL + "?v=1.0&q=$query&callback=?").then((response) {
      // When the request returns a response, the Future can "complete"
      completer.complete(response['responseData']['results'][0]['url']);
    });

    // Returns a value when available
    return completer.future;
  }

  // This method redirects the user to Google Maps using the address of the monument
  void seeOnMaps() {
      if (address.trim().isNotEmpty) {
          window.location.assign("https://www.google.it/maps?q=" + Uri.encodeQueryComponent(address + " Roma Italia"));
      }
  }
}
