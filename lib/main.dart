import 'package:assignment/bloc/VideoBloc.dart';
import 'package:assignment/ui/VideoFeedPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (context) => VideoBloc(),
        child: VideoFeedPage(),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

