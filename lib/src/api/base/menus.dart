import 'package:pronote_dart/src/core/clients/base.dart';
import 'package:pronote_dart/src/core/request.dart';
import 'package:pronote_dart/src/models/enums/tab_location.dart';
import 'package:pronote_dart/src/models/week_menu.dart';
import 'package:pronote_dart/src/utils/pronote_date.dart';

extension PronoteBaseMenus on PronoteBaseClient {
  Future<WeekMenu> menus({DateTime? date}) async {
    date ??= DateTime.now();

    final request = Request(session, 'PageMenus', {
      '_Signature_': {
        'onglet': TabLocation.menus.code
      },

      'donnees': {
        'date': {
          '_T': 7,
          'V': encodePronoteDate(date)
        }
      }
    });

    final response = await request.send();

    return WeekMenu.fromJSON(response.data['donnees']);
  }
}