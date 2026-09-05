import '../../data/database/app_database.dart';

extension CourseHolesLabel on CourseHoles {
  String get label => switch (this) {
        CourseHoles.h9 => '9 holes',
        CourseHoles.h18 => '18 holes',
        CourseHoles.h27 => '27 holes',
        CourseHoles.h36 => '36 holes',
      };
}

extension CourseKindLabel on CourseKind {
  String get label => switch (this) {
        CourseKind.public => 'Public',
        CourseKind.muni => 'Muni',
        CourseKind.resort => 'Resort',
        CourseKind.private => 'Private',
        CourseKind.executive => 'Executive',
      };
}

extension HolesPlayedLabel on HolesPlayed {
  String get label => switch (this) {
        HolesPlayed.nine => '9',
        HolesPlayed.eighteen => '18',
        HolesPlayed.partial => 'Partial',
      };
}

extension WalkedOrCartLabel on WalkedOrCart {
  String get label => switch (this) {
        WalkedOrCart.walked => 'Walked',
        WalkedOrCart.cart => 'Cart',
      };
}
