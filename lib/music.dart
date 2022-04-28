import 'dart:io';
import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:drip/ac_page.dart';
import 'package:drip/pages/audioplayerbar.dart';
import 'package:drip/pages/common/hot_keys.dart';

import 'package:drip/pages/currentplaylist.dart';
import 'package:drip/pages/expanded_audio_bar.dart';
import 'package:drip/pages/settings.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_acrylic/flutter_acrylic.dart' as acrylic;
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'datasources/audiofiles/audiocontrolcentre.dart';
import 'datasources/audiofiles/activeaudiodata.dart';

import 'homepage.dart';
import 'navigation/navigationstacks.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart' as av;
import 'theme.dart';
import 'main.dart';

const String appTitle = 'Drip';

bool darkMode = true;

void start(bool choice) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    doWhenWindowReady(() {
      appWindow.minSize = const Size(540, 540);
      appWindow.size = const Size(900, 640);
      appWindow.alignment = Alignment.center;
      appWindow.show();
      appWindow.title = 'Drip';
    });

    // SystemTheme.accentInstance;
  }

  setPathUrlStrategy();

  if (Platform.isWindows) {
    await Hive.initFlutter('Drip');
  } else {
    await Hive.initFlutter();
  }

  await openHiveBox('settings');

  await openHiveBox('Favorite Songs');
  await openHiveBox('cache', limit: true);
  DartVLC.initialize();

  if (Platform.isWindows) {
    await acrylic.Window.initialize();
    hotKeyManager.unregisterAll();
    await HotKeys.initialize();
  }
  //await Window.initialize();
  //WidgetsFlutterBinding.ensureInitialized();

  runApp(const Music());

  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.android ||
      kIsWeb) {
    darkMode = await SystemTheme.darkMode;
    await SystemTheme.accentInstance.load();
  } else {
    darkMode = true;
  }
  if (!kIsWeb &&
      [TargetPlatform.windows, TargetPlatform.linux]
          .contains(defaultTargetPlatform)) {
    //await flutter_acrylic.Window.initialize();
  }

  runApp(const Music());
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dirPath/$boxName.lock');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/drip/$boxName.hive');
      lockFile = File('$dirPath/drip/$boxName.lock');
    }
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });
  // clear box if it grows large
  if (limit && box.length > 500) {
    box.clear();
  }
}

class Music extends StatelessWidget {
  const Music({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<PlayerNotifiers>(
            create: (BuildContext context) {
              return PlayerNotifiers();
            },
          ),
          ChangeNotifierProvider<ActiveAudioData>(
            create: (BuildContext context) {
              return ActiveAudioData();
            },
          ),
        ],
        child: ChangeNotifierProvider(
            create: (_) => AppTheme(),
            builder: (context, _) {
              final appTheme = context.watch<AppTheme>();
              return FluentApp(
                  title: appTitle,
                  themeMode: appTheme.mode,
                  debugShowCheckedModeBanner: false,
                  initialRoute: '/',
                  routes: {
                    '/': (_) => const MyHomePage(),
                    '/home': (context) => HomePage(),
                    '/dashboard': (context) => MyApp(),
                    '/ac': (context) => AcPage(),
                  },
                  theme: ThemeData(
                    accentColor: appTheme.color,
                    brightness: appTheme.mode == ThemeMode.system
                        ? darkMode
                            ? Brightness.dark
                            : Brightness.light
                        : appTheme.mode == ThemeMode.dark
                            ? Brightness.dark
                            : Brightness.light,
                    visualDensity: VisualDensity.standard,
                    focusTheme: FocusThemeData(
                      glowFactor: is10footScreen() ? 2.0 : 0.0,
                    ),
                  ));
            }));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool value = false;

  int index = 0;

  late PageController _pageController;
  late List<Widget> screens;

  bool sheetCollapsed = true;

  late SheetController _sheetController;

  final colorsController = ScrollController();
  final settingsController = ScrollController();

  Map<int?, GlobalKey?> navigatorKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
  };
  @override
  void initState() {
    super.initState();
    index = 0;

    screens = [
      FirstPageStack(navigatorKey: navigatorKeys[0]),
      SecondPageStack(
          searchArgs: '', fromFirstPage: false, navigatorKey: navigatorKeys[1]),
      CurrentPlaylist(
        fromMainPage: true,
        navigatorKey: navigatorKeys[2],
      ),
      SettingsPage(
        navigatorKey: navigatorKeys[3],
      )
    ];
    _pageController = PageController(initialPage: index);

    _sheetController = SheetController();
  }

  bool onWillPop() {
    if (Navigator.of(context).canPop()) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    colorsController.dispose();
    settingsController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return SafeArea(
      child: Stack(
        children: [
          NavigationView(
            appBar: NavigationAppBar(
                automaticallyImplyLeading: true,
                // leading: Padding(
                //   padding: const EdgeInsets.only(top: 10.0),
                //   child: IconButton(
                //       onPressed: () {
                //
                //        Navigator.pushNamed(context, '/home');
                //
                //       },
                //       icon: const Icon(FluentIcons.back)),
                // ),
                title: Platform.isWindows
                    ? const TopBar()
                    : const SizedBox.shrink()),
            pane: NavigationPane(
              selected: index,
              scrollController: mat.ScrollController(),
              onChanged: (i) {
                index = i;

                _pageController.animateToPage(index,
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(milliseconds: 400));
                setState(() {
                  if (!sheetCollapsed) {
                    _sheetController.collapse();
                    sheetCollapsed = true;
                  }
                });
              },
              size: const NavigationPaneSize(
                openWidth: 200,
                openMinWidth: 200,
                openMaxWidth: 200,
              ),
              // header: Container(
              //     height: kOneLineTileHeight,
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              //     child:
              displayMode: Platform.isWindows
                  ? PaneDisplayMode.compact
                  : PaneDisplayMode.top,
              indicatorBuilder: () {
                switch (appTheme.indicator) {
                  case NavigationIndicators.end:
                    return NavigationIndicator.end;
                  case NavigationIndicators.sticky:
                  default:
                    return NavigationIndicator.sticky;
                }
              }(),
              items: [
                // It doesn't look good when resizing from compact to open
                // PaneItemHeader(header: Text('User Interaction')),
                PaneItemAction(
                  icon: const Icon(FluentIcons.back),
                  title: const Text('Back'),
                  onTap: () {
                    // start(false);
                    Navigator.pushNamed(context, '/home');
                    return;
                  },
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.home),
                  title: const Text('Home'),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.search),
                  title: const Text('Search'),
                ),
                // PaneItem(
                //   icon: const Icon(FluentIcons.personalize),
                //   title: const Text('Artists'),
                // ),
                PaneItemSeparator(),
                PaneItem(
                  icon: const mat.Icon(FluentIcons.playlist_music),
                  title: const Text('Play queue'),
                ),
                PaneItemSeparator(),
                PaneItem(
                  icon: const Icon(FluentIcons.settings),
                  title: const Text('Settings'),
                ),
              ],
              autoSuggestBoxReplacement: const Icon(FluentIcons.search),
            ),
            content: PageView(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: screens,
            ),
          ),
          SlidingSheet(
            closeOnBackButtonPressed: true,
            color: Colors.transparent,

            closeOnBackdropTap: true,
            duration: const Duration(milliseconds: 200),
            controller: _sheetController,
            //elevation: 8,
            cornerRadius: 3,
            snapSpec: SnapSpec(
              snap: sheetCollapsed,
              snappings: [100, 200, double.infinity],
              positioning: SnapPositioning.pixelOffset,
            ),
            builder: (context, state) {
              return ClipRect(
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  color: Colors.transparent,
                  child: const ExpandedAudioBar(),
                ),
              );
            },
            footerBuilder: (context, state) {
              return Container(
                alignment: Alignment.center,
                height: 100,
                child: Stack(children: [
                  ClipRect(
                    child: mat.Material(
                      child: Acrylic(
                        child: const SizedBox(
                          child: AudioPlayerBar(),
                          width: double.infinity,
                          height: 100,
                        ),
                        elevation: 10,
                        shape: mat.RoundedRectangleBorder(
                            borderRadius: mat.BorderRadius.circular(8)),
                        tint: context
                            .watch<ActiveAudioData>()
                            .albumExtracted
                            .toAccentColor(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 3,
                    child: IconButton(
                      icon: const Icon(FluentIcons.playlist_music),
                      onPressed: () {
                        setState(() {
                          if (sheetCollapsed) {
                            _sheetController.expand();
                            sheetCollapsed = false;
                          } else {
                            _sheetController.collapse();
                            sheetCollapsed = true;
                          }
                        });
                      },

                      // hoverColor: Colors.red.shade400,
                    ),
                  )
                ]),
              );
            },
          ),
          Positioned(
            bottom: 70.5,
            left: 5,
            right: 5,
            child: ValueListenableBuilder<ProgressBarState>(
              valueListenable: progressNotifier,
              builder: (_, value, __) {
                return av.ProgressBar(
                  thumbGlowColor: Colors.blue,
                  baseBarColor:
                      context.watch<AppTheme>().color.withOpacity(0.3),
                  thumbColor: context.watch<AppTheme>().color,
                  progressBarColor: context.watch<AppTheme>().color,
                  progress: value.current,
                  // buffered: value.buffered,
                  total: value.total,
                  onSeek: (position) => AudioControlClass.seek(position),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = context.watch<AppTheme>().mode == ThemeMode.dark ||
            context.watch<AppTheme>().mode == ThemeMode.system
        ? Colors.grey[30]
        : Colors.grey[150];

    return SizedBox(
      height: 35.0,
      child: WindowTitleBarBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: MoveWindow(
              child: Container(
                margin: const mat.EdgeInsets.only(top: 8, left: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/driplogocircle.png',
                      filterQuality: FilterQuality.high,
                      alignment: Alignment.center,
                      height: 30,
                      width: 30,

                      //height: 10,
                      //width: 10,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Drip',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            )),
            Expanded(child: MoveWindow()),
            Row(
              children: [
                MinimizeWindowButton(
                  colors: WindowButtonColors(iconNormal: color),
                ),
                MaximizeWindowButton(
                    colors: WindowButtonColors(iconNormal: color)),
                CloseWindowButton(colors: WindowButtonColors(iconNormal: color))
              ],
            )
          ],
        ),
      ),
    );
  }
}
//
// GetIt locator = GetIt.instance;
//
// void setupLocator() {
//   locator.registerLazySingleton(() => PopNavigationService());
// }
