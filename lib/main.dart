import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'core/bloc_observer/bloc_observer.dart';
import 'core/helpers/cache_helper.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  runApp(const MyApp());
}
