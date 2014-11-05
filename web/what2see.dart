import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_item.dart';
import 'monuments_list.dart';
main() {
  initPolymer().run(() {
      Polymer.onReady.then((_) {
          /* Bind menu buttons */
          // Learn Polymer!!1
          (querySelector("#learn") as PaperItem).onClick.listen((e) {
    window.location.assign("https://www.dartlang.org/polymer/");
    });

// Get the code
(querySelector("#source-code") as PaperItem).onClick.listen((e) {
    window.location.assign("https://github.com/joaobiriba/what2see");
    });


          // Infinite scrolling
          window.onScroll.listen((e) {
            if (window.scrollY + window.innerHeight >= (document.body.scrollHeight - 10)) {
              // Load more images
              (querySelector('monuments-list') as MonumentsList).loadMore();
            }
          });
      });
  });
}
