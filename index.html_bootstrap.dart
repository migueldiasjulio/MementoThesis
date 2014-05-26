library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'package:memento/components/screens/allPhotos/allPhotos.dart' as i0;
import 'package:memento/components/screens/summaryDone/summaryDone.dart' as i1;
import 'package:memento/components/screens/bigSizePhoto/bigSizePhoto.dart' as i2;
import 'package:memento/components/screens/mementoApp/mementoApp.dart' as i3;
import 'package:memento/components/index.dart' as i4;
import 'package:smoke/smoke.dart' show Declaration, PROPERTY, METHOD;
import 'package:smoke/static.dart' show useGeneratedCode, StaticConfiguration;
import 'package:memento/components/screens/allPhotos/allPhotos.dart' as smoke_0;
import 'package:memento/components/core/screenModule.dart' as smoke_1;
import 'package:polymer/polymer.dart' as smoke_2;
import 'package:observe/src/metadata.dart' as smoke_3;
import 'package:memento/components/screens/summaryDone/summaryDone.dart' as smoke_4;
import 'package:memento/components/screens/bigSizePhoto/bigSizePhoto.dart' as smoke_5;
import 'package:memento/components/core/Thumbnail.dart' as smoke_6;
import 'package:memento/components/screens/mementoApp/mementoApp.dart' as smoke_7;
abstract class _M0 {} // Screen & ChangeNotifier
abstract class _M1 {} // PolymerElement & ChangeNotifier

void main() {
  useGeneratedCode(new StaticConfiguration(
      checkedMode: false,
      getters: {
        #atExcluded: (o) => o.atExcluded,
        #atStandBy: (o) => o.atStandBy,
        #atSummary: (o) => o.atSummary,
        #buildSummary: (o) => o.buildSummary,
        #disableSelection: (o) => o.disableSelection,
        #enableSelection: (o) => o.enableSelection,
        #export: (o) => o.export,
        #exportSummary: (o) => o.exportSummary,
        #first: (o) => o.first,
        #height: (o) => o.height,
        #incSummaryNumber: (o) => o.incSummaryNumber,
        #keys: (o) => o.keys,
        #length: (o) => o.length,
        #moveToExcluded: (o) => o.moveToExcluded,
        #moveToStandBy: (o) => o.moveToStandBy,
        #moveToSummary: (o) => o.moveToSummary,
        #moving: (o) => o.moving,
        #myScreen: (o) => o.myScreen,
        #myScreenChanged: (o) => o.myScreenChanged,
        #navigate: (o) => o.navigate,
        #numberOfPhotosDefined: (o) => o.numberOfPhotosDefined,
        #pageName: (o) => o.pageName,
        #returnToSummary: (o) => o.returnToSummary,
        #screens: (o) => o.screens,
        #selectedPhotos: (o) => o.selectedPhotos,
        #selection: (o) => o.selection,
        #show: (o) => o.show,
        #showImage: (o) => o.showImage,
        #src: (o) => o.src,
        #subSummaryNumber: (o) => o.subSummaryNumber,
        #thumbToDisplay: (o) => o.thumbToDisplay,
        #thumbnail: (o) => o.thumbnail,
        #thumbnails: (o) => o.thumbnails,
        #thumbnailsExcluded: (o) => o.thumbnailsExcluded,
        #thumbnailsStandBy: (o) => o.thumbnailsStandBy,
        #thumbnailsSummary: (o) => o.thumbnailsSummary,
        #title: (o) => o.title,
        #width: (o) => o.width,
      },
      setters: {
        #atExcluded: (o, v) { o.atExcluded = v; },
        #atStandBy: (o, v) { o.atStandBy = v; },
        #atSummary: (o, v) { o.atSummary = v; },
        #export: (o, v) { o.export = v; },
        #moving: (o, v) { o.moving = v; },
        #myScreen: (o, v) { o.myScreen = v; },
        #numberOfPhotosDefined: (o, v) { o.numberOfPhotosDefined = v; },
        #pageName: (o, v) { o.pageName = v; },
        #selection: (o, v) { o.selection = v; },
        #thumbToDisplay: (o, v) { o.thumbToDisplay = v; },
      },
      parents: {
        smoke_1.Screen: smoke_1.ScreenModule,
        smoke_1.ScreenModule: smoke_2.PolymerElement,
        smoke_0.AllPhotos: _M0,
        smoke_5.BigSizePhoto: _M0,
        smoke_7.MementoApp: _M1,
        smoke_4.SummaryDone: _M0,
        _M0: smoke_1.Screen,
        _M1: smoke_2.PolymerElement,
      },
      declarations: {
        smoke_0.AllPhotos: {
          #numberOfPhotosDefined: const Declaration(#numberOfPhotosDefined, String, kind: PROPERTY, annotations: const [smoke_3.reflectable, smoke_3.observable]),
        },
        smoke_5.BigSizePhoto: {
          #moving: const Declaration(#moving, bool, kind: PROPERTY, annotations: const [smoke_3.reflectable, smoke_3.observable]),
          #selection: const Declaration(#selection, bool, kind: PROPERTY, annotations: const [smoke_3.reflectable, smoke_3.observable]),
          #thumbToDisplay: const Declaration(#thumbToDisplay, smoke_6.Thumbnail, kind: PROPERTY, annotations: const [smoke_3.reflectable, smoke_2.published]),
        },
        smoke_7.MementoApp: {
          #myScreen: const Declaration(#myScreen, smoke_1.Screen, kind: PROPERTY, annotations: const [smoke_3.reflectable, smoke_3.observable]),
          #myScreenChanged: const Declaration(#myScreenChanged, Function, kind: METHOD),
          #pageName: const Declaration(#pageName, String, kind: PROPERTY, annotations: const [smoke_3.reflectable, smoke_2.published]),
        },
        smoke_4.SummaryDone: {
          #atExcluded: const Declaration(#atExcluded, bool, kind: PROPERTY, annotations: const [smoke_3.reflectable, smoke_3.observable]),
          #atStandBy: const Declaration(#atStandBy, bool, kind: PROPERTY, annotations: const [smoke_3.reflectable, smoke_3.observable]),
          #atSummary: const Declaration(#atSummary, bool, kind: PROPERTY, annotations: const [smoke_3.reflectable, smoke_3.observable]),
          #export: const Declaration(#export, bool, kind: PROPERTY, annotations: const [smoke_3.reflectable, smoke_3.observable]),
          #selection: const Declaration(#selection, bool, kind: PROPERTY, annotations: const [smoke_3.reflectable, smoke_3.observable]),
        },
      },
      names: {
        #atExcluded: r'atExcluded',
        #atStandBy: r'atStandBy',
        #atSummary: r'atSummary',
        #buildSummary: r'buildSummary',
        #disableSelection: r'disableSelection',
        #enableSelection: r'enableSelection',
        #export: r'export',
        #exportSummary: r'exportSummary',
        #first: r'first',
        #height: r'height',
        #incSummaryNumber: r'incSummaryNumber',
        #keys: r'keys',
        #length: r'length',
        #moveToExcluded: r'moveToExcluded',
        #moveToStandBy: r'moveToStandBy',
        #moveToSummary: r'moveToSummary',
        #moving: r'moving',
        #myScreen: r'myScreen',
        #myScreenChanged: r'myScreenChanged',
        #navigate: r'navigate',
        #numberOfPhotosDefined: r'numberOfPhotosDefined',
        #pageName: r'pageName',
        #returnToSummary: r'returnToSummary',
        #screens: r'screens',
        #selectedPhotos: r'selectedPhotos',
        #selection: r'selection',
        #show: r'show',
        #showImage: r'showImage',
        #src: r'src',
        #subSummaryNumber: r'subSummaryNumber',
        #thumbToDisplay: r'thumbToDisplay',
        #thumbnail: r'thumbnail',
        #thumbnails: r'thumbnails',
        #thumbnailsExcluded: r'thumbnailsExcluded',
        #thumbnailsStandBy: r'thumbnailsStandBy',
        #thumbnailsSummary: r'thumbnailsSummary',
        #title: r'title',
        #width: r'width',
      }));
  configureForDeployment([
      () => Polymer.register('all-photos', i0.AllPhotos),
      () => Polymer.register('summary-done', i1.SummaryDone),
      () => Polymer.register('big-size-photo', i2.BigSizePhoto),
      () => Polymer.register('memento-app', i3.MementoApp),
    ]);
  i4.main();
}
