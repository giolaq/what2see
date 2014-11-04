import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_dialog.dart';


@CustomTag('x-monument')
class XMonument extends PolymerElement {

  @published String name = "";
  @published String address = "";

  XMonument.created() : super.created();

  @override
  void attached() {
    super.attached();
    // TODO: qua vanno i calcoli
    shadowRoot.querySelector("#show").onClick.listen((_) {
      print("asd");
      (shadowRoot.querySelector("#dialog") as PaperDialog).toggle();
    });
  }
}