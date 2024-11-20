import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:dartx/dartx.dart';
import 'package:village_court_gems/models/area_model/all_location_data.dart';
import 'package:village_court_gems/models/field_visit_model/updated_new_loc_model.dart';

class FieldVisitLocalUtil {
  List<AllLocationData> haversineFormula(List<AllLocationData> locations, double userLatitude, double userLongitude, double maxDistance) {
    print("skjhkjasdghf ${maxDistance}");
    List<AllLocationData> nearestLocations = locations.where((e) {
      double earthRadius = 6371000; // Earth radius in meters

      double lat1 = _degToRad(userLatitude);
      double lon1 = _degToRad(userLongitude);
      double lat2 = _degToRad(double.tryParse(e.latitude.toString()) ?? 0.0);
      double lon2 = _degToRad(double.tryParse(e.longitude.toString()) ?? 0.0);

      double dLat = lat2 - lat1;
      double dLon = lon2 - lon1;

      // Use Haversine formula to calculate distance between two points
      double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
      double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      double distance = earthRadius * c;

      e.distance = distance;
      return distance <= maxDistance;
    }).toList();
    var data = nearestLocations;
    dev.log('filtloc data ${jsonEncode(data)}');
    return nearestLocations;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  List<UpdNewLocationData> formatFilteredLocation(List<AllLocationData> locations, double userLatitude, double userLongitude, double distance) {
    List<UpdNewLocationData> locationData = [];
    final nearestLocation = haversineFormula(locations, userLatitude, userLongitude, distance);
    final filteredLocation = nearestLocation.sortedBy((element) => element.distance!);
    String? districtName;
    String? unionName;
    String? upazilaName;
    locationData = filteredLocation.map((e) {
      districtName = null;
      unionName = null;
      upazilaName = null;

      // districtName = filteredLocation.firstWhere((element) => element.districtId == e.districtId).nameEn ?? '';
      //upazilaName = filteredLocation.firstWhere((element) => element.upazilaId == e.upazilaId).nameEn ?? '';
      //districtName = filteredLocation.firstWhere((element) => element.unionId == e.unionId).nameEn ?? '';

      String officeTypeName = '';
      if (e.officeTypeId == 4) {
        if (e.upazilaId == null && e.unionId == null) {
          upazilaName = null;
          unionName = null;
          districtName = e.nameEn;
          officeTypeName = '${e.nameEn} - ${e.officeTitle}';
        } else {
          districtName = locations.firstWhere((element) => element.districtId == e.districtId).nameEn;
          upazilaName = locations
              .firstWhere(
                (element) => element.upazilaId == e.upazilaId,
                orElse: () => AllLocationData(upazilaId: null),
              )
              .nameEn;
          unionName = locations.firstWhere((element) => element.unionId == e.unionId).nameEn;
          officeTypeName = '${e.nameEn} - ${e.officeTitle}';
        }
      } else if (e.officeTypeId == 3) {
        districtName = locations.firstWhere((element) => element.districtId == e.districtId).nameEn ?? '';
        upazilaName = locations.firstWhere((element) => element.upazilaId == e.upazilaId).nameEn ?? '';
        unionName = e.nameEn;
        officeTypeName = 'UP Office - ${e.nameEn}';
      } else if (e.officeTypeId == 2) {
        districtName = locations.firstWhere((element) => element.districtId == e.districtId).nameEn ?? '';
        upazilaName = e.nameEn;
        unionName = null;
        officeTypeName = 'UNO Office - ${e.nameEn}';
      } else if (e.officeTypeId == 1) {
        districtName = e.nameEn;
        upazilaName = null;
        unionName = null;
        officeTypeName = 'DC/DDLG Office - ${e.nameEn}';
      }
      return UpdNewLocationData(
          id: e.id,
          districtId: e.districtId ?? null,
          divisionId: e.divisionId,
          officeTypeName: officeTypeName,
          districtName: districtName,
          upazilaName: upazilaName,
          upazilaId: e.upazilaId,
          unionName: unionName,
          unionId: e.unionId,
          officeTypeId: e.officeTypeId,
          locationId: e.id,
          distance: e.distance == null ? null : e.distance.toString(),
          officeTitle: e.officeTitle);
    }).toList();

    dev.log('Final Filtered Data ${jsonEncode(locationData)}');
    return locationData;
  }
}
