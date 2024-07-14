import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main/models/models.dart';
import '../main/screens/SplashScreen.dart';
import '../main/utils/Constants.dart';
import 'AppTheme.dart';
import 'main/language/AppLocalizations.dart';
import 'main/language/BaseLanguage.dart';
import 'main/models/FileModel.dart';
import 'main/screens/NoInternetScreen.dart';
import 'main/services/ChatMessagesService.dart';
import 'main/services/NotificationService.dart';
import 'main/services/UserServices.dart';
import 'main/store/AppStore.dart';
import 'main/utils/Common.dart';
import 'main/utils/DataProviders.dart';
import 'main/utils/firebase_options.dart';

AppStore appStore = AppStore();
late BaseLanguage language;
UserService userService = UserService();
ChatMessageService chatMessageService = ChatMessageService();
NotificationService notificationService = NotificationService();
late List<FileModel> fileList = [];
bool isCurrentlyOnNoInternet = false;
StreamSubscription<Position>? positionStream;

bool mIsEnterKey = false;
String mSelectedImage = "assets/default_wallpaper.png";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  });

  await initialize(aLocaleLanguageList: languageList());

  appStore.setLogin(getBoolAsync(IS_LOGGED_IN), isInitializing: true);
  appStore.setUserEmail(getStringAsync(USER_EMAIL), isInitialization: true);
  appStore.setUserProfile(getStringAsync(USER_PROFILE_PHOTO), isInitializing: true);
  appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguage));
  FilterAttributeModel? filterData = FilterAttributeModel.fromJson(getJSONAsync(FILTER_DATA));
  appStore.setFiltering(filterData.orderStatus != null || !filterData.fromDate.isEmptyOrNull || !filterData.toDate.isEmptyOrNull);

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == appThemeMode.themeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == appThemeMode.themeModeDark) {
    appStore.setDarkMode(true);
  }

  oneSignalSettings();
  defaultRadius = 10;
  runApp(MyApp());
}

Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  // late StreamSubscription<Position> _streamSubscription;
  String message = 'empty';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((e) {
      if (e == ConnectivityResult.none) {
        log('not connected');
        isCurrentlyOnNoInternet = true;
        push(NoInternetScreen());
      } else {
        if (isCurrentlyOnNoInternet) {
          pop();
          isCurrentlyOnNoInternet = false;
          toast(language.internetIsConnected);
        }
        log('connected');
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    _connectivitySubscription.cancel();
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
        title: mAppName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: SplashScreen(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          CountryLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguage.validate(value: defaultLanguage)),
      );
    });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
