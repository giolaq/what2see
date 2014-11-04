import 'dart:html';
import 'package:polymer/polymer.dart';
import 'monuments_list.dart';
main() {
  initPolymer();
  window.onScroll.listen((e) {
    if (window.scrollY + window.innerHeight >= (document.body.scrollHeight - 10)) {
      // Load more images
      (querySelector('monuments-list') as MonumentsList).loadMore();
    }
  });
}
