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


  XMonument.created() : super.created();

  @override
  void attached() {
    super.attached();
    // Load thumbnail
    getThumbnailSrc(name).then((String src) {
      if (src.isNotEmpty) {
        this.imageSrc = src;
      }
    });

    shadowRoot.querySelector("#show").onClick.listen((_) {
      (shadowRoot.querySelector("#dialog") as PaperDialog).toggle();
    });
  }

  Future<String> getThumbnailSrc(String name) {
    var completer = new Completer();
    String BASE_URL = "https://ajax.googleapis.com/ajax/services/search/images";
    String query = Uri.encodeQueryComponent(name + " Roma");

    jsonp.fetch(uri: BASE_URL + "?v=1.0&q=$query&callback=?").then((response) {
      completer.complete(response['responseData']['results'][0]['url']);
    });

    return completer.future;
  }

  void seeOnMaps() {
      if (address.trim().isNotEmpty) {
          window.location.assign("https://www.google.it/maps?q=" + Uri.encodeQueryComponent(address + " Roma Italia"));
      }
  }
}
