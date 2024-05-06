export '../CommonPlateformFiles/Common.dart'
    if (dart.library.html) 'OnlyWeb.dart'
    if (dart.library.io) 'OnlyMob.dart';
