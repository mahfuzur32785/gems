// class LocalFVSync{
//    Future<void> fieldSubmitAutoSync({required BuildContext context}) async {
//     LocalStore localStore = LocalStore();

//     final localFieldSubmitData = localStore.fieldSubmitBox.values.toList();
//     if (localFieldSubmitData.isNotEmpty) {
//       backUpFieldSubmitProcessing = true;
//       notifyListeners();
//       for (var item in localFieldSubmitData) {
//         if (item.syncStatus == 'offline') {
//           List<String> imgPath = [];
//           if (item.locimg1 != null) {
//             imgPath.add(item.locimg1!);
//           }
//           if (item.locimg2 != null) {
//             imgPath.add(item.locimg2!);
//           }
//           if (item.locimg3 != null) {
//             imgPath.add(item.locimg3!);
//           }
//           final response = await Repositores().uploadDataAndImage(
//             division_id: item.divisionID.toString(),
//             district_id: item.districtID.toString(),
//             upazila_id: item.upazillaID == null ? '' : item.upazillaID.toString(),
//             union_id: item.unionID == null ? '' : item.unionID.toString(),
//             latitude: item.latitude.toString(),
//             longitude: item.longitude.toString(),
//             office_type: item.officeTypeID.toString(),

//             //isit_purpose: visitPurposeController.text,
//             // office_type: selectedOffice == "DC/DDLG Office"
//             //     ? "1"
//             //     : selectedOffice == "UNO Office"
//             //         ? "3"
//             //         : selectedOffice == "UP Office"
//             //             ? "2"
//             //             : selectedOffice == "Other Office"
//             //                 ? "4"
//             //                 : "",
//             office_title: item.officeTypeID.toString() == "4" ? item.officeTitle.toString() : "",
//             location_match: item.locationMatch.toString(),
//             imageFile: null,
//             imagesPath: imgPath,
//           );
//           print('local response message $response');
//           if (response == "success") {
//             localStore.fieldSubmitBox.clear();
//             backUpFieldSubmitProcessing = false;
//             AllService().tost("Successfully Synced Data");
//             notifyListeners();
//             break;
//           } else {
//             backUpFieldSubmitProcessing = false;
//             localStore.fieldSubmitBox.clear();
//             AllService().tost("Failed to Sync Data, Try again");
//             notifyListeners();
//             return;
//           }
//         }
//       }
//     } else {
//       return;
//     }
//   }

//   changeLocationAutoSync({required BuildContext context}) async {
//     //  backUpFieldSubmitProcessing = true;
//     //  notifyListeners();
//     LocalStore localStore = LocalStore();
//     final localData = localStore.addChangeLocationBox.values.toList();
//     if (localData.isNotEmpty) {
//       for (var element in localData) {
//         if (element.syncStatus == 'offline') {
//           if (element.isChangeLocation == 'true') {
//             final response = await Repositores().addChangeLocation(
//               division_id: element.divisionID.toString(),
//               district_id: element.districtID.toString(),
//               upazila_id: element.upazillaID != null ? element.upazillaID.toString() : "",
//               union_id: element.unionID != null ? element.unionID.toString() : "",
//               latitude: element.latitude.toString(),
//               longitude: element.longitude.toString(),
//               remark: element.remark.toString(),
//               office_type_id: element.officeTypeID.toString(),
//               // office_type_id: selectedOffice == "DC/DDLG Office"
//               //     ? "1"
//               //     : selectedOffice == "UNO Office"
//               //         ? "3"
//               //         : selectedOffice == "UP Office"
//               //             ? "2"
//               //             : selectedOffice == "Other Office"
//               //                 ? "4"
//               //                 : "",
//               office_title: element.officeTypeID.toString() == "4" ? element.officeTitle.toString() : "",
//             );
//             if (response == "success") {
//               localStore.addChangeLocationBox.clear();
//               backUpFieldSubmitProcessing = false;
//               AllService().tost("Successfully Synced Data");
//               notifyListeners();
//               break;
//             } else {
//               backUpFieldSubmitProcessing = false;
//               localStore.addChangeLocationBox.clear();
//               AllService().tost("Failed to Sync Data, Try again");

//               notifyListeners();
//               return;
//             }
//           }
//         }
//       }
//     }
//   }
// }