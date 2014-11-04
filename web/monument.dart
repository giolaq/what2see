import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_dialog.dart';
import 'package:jsonp/jsonp.dart' as jsonp;


@CustomTag('x-monument')
class XMonument extends PolymerElement {

  @published String name = "";
  @published String address = "";
  @published String imageSrc = "";

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
    print("Prelevo img");
    var completer = new Completer();
    String BASE_URL = "https://ajax.googleapis.com/ajax/services/search/images";
    String query = Uri.encodeQueryComponent(name + " Roma");

    jsonp.fetch(uri: BASE_URL + "?v=1.0&q=$query&callback=?").then((response) {
      completer.complete(response['responseData']['results'][0]['url']);
    });

    return completer.future;
  }
}