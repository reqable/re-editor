part of re_editor;

final kIsMacOS = !kIsWeb && Platform.isMacOS;
final kIsWindows = !kIsWeb && Platform.isWindows;
final kIsLinux = !kIsWeb && Platform.isLinux;
final kIsAndroid = !kIsWeb && Platform.isAndroid;
final kIsIOS = !kIsWeb && Platform.isIOS;
final kIsApple = !kIsWeb && (Platform.isIOS || Platform.isMacOS);
final kIsMobile = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
final kIsDesktop = !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
