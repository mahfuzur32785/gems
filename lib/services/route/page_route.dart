import 'package:flutter/material.dart';
import 'package:village_court_gems/view/AACO/aaco_info_add.dart';
import 'package:village_court_gems/view/Profile/profile.dart';
import 'package:village_court_gems/view/Trainings/Trainings.dart';
import 'package:village_court_gems/view/activity/activity_List_Details.dart';
import 'package:village_court_gems/view/activity/activity.dart';
import 'package:village_court_gems/view/field_visit_list/field_visit_try.dart';
import 'package:village_court_gems/view/activity/activity_add.dart';
import 'package:village_court_gems/view/auth/login_page.dart';
import 'package:village_court_gems/view/home/homepage.dart';
import 'package:village_court_gems/view/home/splashscreen.dart';
import 'package:village_court_gems/view/AACO/aaco_Info.dart';
import 'package:village_court_gems/view/trainings/training_add.dart';
import 'package:village_court_gems/view/visit_report/rev_field_visit_screen.dart';

Map<String, Widget Function(BuildContext)> pageRoute(BuildContext context) {
  return {
    '/': (context) => const SPScreen(),
    LoginPage.pageName: (context) => const LoginPage(),
    Homepage.pageName: (context) => Homepage(),
    TrainingDataPage.pageName: (context) => const TrainingDataPage(),
    ActivityUpdate.pageName: (context) => const ActivityUpdate(),
    NewFieldVisit.pageName: (context) => const NewFieldVisit(),
    CompletedFieldVisitPage.pageName: (context) =>
        const CompletedFieldVisitPage(),
    TrainingsPage.pageName: (context) => const TrainingsPage(),
    ProfilePage.pageName: (context) => const ProfilePage(),
    ActivityShow.pageName: (context) => const ActivityShow(),
    ActivityListShow.pageName: (context) => ActivityListShow(),
    AACO_Info.pageName: (context) => const AACO_Info(),
    AACO_Info_Add.pageName: (context) => const AACO_Info_Add(),
  };
}
