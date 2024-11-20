import 'package:flutter/material.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:dropdown_search/dropdown_search.dart';

///division dropdown
class DivisionDropdown extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final Division? selectedItem;
  final List<Division> itemList;
  final Function? callBackFuction;
  DivisionDropdown(
      {Key? key,
      required this.hintText,
      required this.labelText,
      this.selectedItem,
      required this.itemList,
      required this.callBackFuction})
      : super(key: key);

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ///Menu Mode with no searchBox MultiSelection
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        // borderRadius: BorderRadius.circular(5)
      ),
      child: DropdownSearch<Division>(
        //validator: (v) => v == null ? "required field" : null,
        validator: (value) {
          if (value != null) {
            return null;
          } else {
            return "Select division";
          }
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: labelText,
            suffixIconColor: Colors.grey,
            //prefixIcon: const Icon(Icons.work),
            prefixIconColor: Colors.grey,
            iconColor: Colors.grey,
            hintText: hintText,
            hintMaxLines: 1,
            hintStyle: TextStyle(color: Color(0xff4E4E4E), fontSize: 16),
            //labelText: "Menu mode *",
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            border: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.white)),
          ), //new 2
        ),
        popupProps: PopupProps.menu(
            fit: FlexFit.loose,
            //dialogProps: DialogProps(),
            // showSearchBox: true,
            showSelectedItems: true,
            itemBuilder: _customPopupItemBuilderExample),
        clearButtonProps: ClearButtonProps(isVisible: false, splashRadius: 20),
        items: itemList,
        onChanged: (value) {
          if (value != null) {
            callBackFuction!(value);
          }
        },
        selectedItem: selectedItem,
        compareFn: (item, selectedItem) => item.id == selectedItem.id,
        itemAsString: (item) => item.nameEn!,
        dropdownBuilder: _customDropDownExample,
      ),
    );
  }

  Widget _customDropDownExample(BuildContext context, Division? item) {
    if (item == null) {
      return Text(
        hintText!,
        style: TextStyle(
          color: Color(0xff4E4E4E),
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
      );
    }

    return Text(
      item.nameEn!,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, Division? item, bool isSelected) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
        padding: const EdgeInsets.only(left: 10.0, top: 2.0, bottom: 2.0),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Colors.white),
                // borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: Text(
          item!.nameEn ?? '',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ));
  }
}

///district dropdown
class DistrictDropdown extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final District? selectedItem;
  final List<District> itemList;
  final Function? callBackFuction;
  DistrictDropdown(
      {Key? key,
      required this.hintText,
      required this.labelText,
      this.selectedItem,
      required this.itemList,
      required this.callBackFuction})
      : super(key: key);

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ///Menu Mode with no searchBox MultiSelection
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        // borderRadius: BorderRadius.circular(5)
      ),
      child: DropdownSearch<District>(
        //validator: (v) => v == null ? "required field" : null,
        validator: (value) {
          if (value != null) {
            return null;
          } else {
            return "Select district";
          }
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: labelText,
            suffixIconColor: Colors.grey,
            //prefixIcon: const Icon(Icons.work),
            prefixIconColor: Colors.grey,
            iconColor: Colors.grey,
            hintText: hintText,
            hintMaxLines: 1,
            hintStyle: TextStyle(color: Color(0xff4E4E4E), fontSize: 16),
            //labelText: "Menu mode *",
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            border: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.white)),
          ), //new 2
        ),
        popupProps: PopupProps.menu(
            fit: FlexFit.loose,
            //dialogProps: DialogProps(),
            // showSearchBox: true,
            showSelectedItems: true,
            itemBuilder: _customPopupItemBuilderExample),
        clearButtonProps: ClearButtonProps(isVisible: false, splashRadius: 20),
        items: itemList,
        onChanged: (value) {
          if (value != null) {
            callBackFuction!(value);
          }
        },
        selectedItem: selectedItem,
        compareFn: (item, selectedItem) => item.id == selectedItem.id,
        itemAsString: (item) => item.nameEn!,
        dropdownBuilder: _customDropDownExample,
      ),
    );
  }

  Widget _customDropDownExample(BuildContext context, District? item) {
    if (item == null) {
      return Text(
        hintText!,
        style: TextStyle(
          color: Color(0xff4E4E4E),
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      );
    }

    return Text(
      item.nameEn!,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, District? item, bool isSelected) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
        padding: const EdgeInsets.only(left: 10.0, top: 2.0, bottom: 2.0),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Colors.white),
                // borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: Text(
          item!.nameEn ?? '',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ));
  }
}

///upzilla dropdown
class UpzillaDropdown extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final Upazila? selectedItem;
  final List<Upazila> itemList;
  final Function? callBackFuction;
  UpzillaDropdown(
      {Key? key,
      required this.hintText,
      required this.labelText,
      this.selectedItem,
      required this.itemList,
      required this.callBackFuction})
      : super(key: key);

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ///Menu Mode with no searchBox MultiSelection
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        // borderRadius: BorderRadius.circular(5)
      ),
      child: DropdownSearch<Upazila>(
        //validator: (v) => v == null ? "required field" : null,
        validator: (value) {
          if (value != null) {
            return null;
          } else {
            return "Select upazila";
          }
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: labelText,
            suffixIconColor: Colors.grey,
            //prefixIcon: const Icon(Icons.work),
            prefixIconColor: Colors.grey,
            iconColor: Colors.grey,
            hintText: hintText,
            hintMaxLines: 1,
            hintStyle: TextStyle(color: Color(0xff4E4E4E), fontSize: 16),
            //labelText: "Menu mode *",
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            border: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.white)),
          ), //new 2
        ),
        popupProps: PopupProps.menu(
            fit: FlexFit.loose,

            //dialogProps: DialogProps(),
            // showSearchBox: true,
            showSelectedItems: true,
            itemBuilder: _customPopupItemBuilderExample),
        clearButtonProps: ClearButtonProps(isVisible: false, splashRadius: 20),
        items: itemList,
        onChanged: (value) {
          if (value != null) {
            callBackFuction!(value);
          }
        },
        selectedItem: selectedItem,
        compareFn: (item, selectedItem) => item.id == selectedItem.id,
        itemAsString: (item) => item.nameEn!,
        dropdownBuilder: _customDropDownExample,
      ),
    );
  }

  Widget _customDropDownExample(BuildContext context, Upazila? item) {
    if (item == null) {
      return Text(
        hintText!,
        style: TextStyle(
          color: Color(0xff4E4E4E),
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      );
    }

    return Text(
      item.nameEn!,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, Upazila? item, bool isSelected) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
        padding: const EdgeInsets.only(left: 10.0, top: 2.0, bottom: 2.0),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Colors.white),
                // borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: Text(
          item!.nameEn ?? '',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ));
  }
}

///Union
class UnionDropdown extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final Union? selectedItem;
  final List<Union> itemList;
  final Function? callBackFuction;
  UnionDropdown(
      {Key? key,
      required this.hintText,
      required this.labelText,
      this.selectedItem,
      required this.itemList,
      required this.callBackFuction})
      : super(key: key);

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ///Menu Mode with no searchBox MultiSelection
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        // borderRadius: BorderRadius.circular(5)
      ),
      child: DropdownSearch<Union>(
        //validator: (v) => v == null ? "required field" : null,
        validator: (value) {
          if (value != null) {
            return null;
          } else {
            return "Select union";
          }
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: labelText,
            suffixIconColor: Colors.grey,
            //prefixIcon: const Icon(Icons.work),
            prefixIconColor: Colors.grey,
            iconColor: Colors.grey,
            hintText: hintText,
            hintMaxLines: 1,
            hintStyle: TextStyle(color: Color(0xff4E4E4E), fontSize: 16),
            //labelText: "Menu mode *",
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            border: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.white)),
          ), //new 2
        ),
        popupProps: PopupProps.menu(
            fit: FlexFit.loose,

            //dialogProps: DialogProps(),
            showSearchBox: false,
            showSelectedItems: true,
            itemBuilder: _customPopupItemBuilderExample),
        clearButtonProps: ClearButtonProps(isVisible: false, splashRadius: 20),
        items: itemList,
        onChanged: (value) {
          if (value != null) {
            callBackFuction!(value);
          }
        },
        selectedItem: selectedItem,
        compareFn: (item, selectedItem) => item.id == selectedItem.id,
        itemAsString: (item) => item.nameEn!,
        dropdownBuilder: _customDropDownExample,
      ),
    );
  }

  Widget _customDropDownExample(BuildContext context, Union? item) {
    if (item == null) {
      return Text(
        hintText!,
        style: TextStyle(
          color: Color(0xff4E4E4E),
          fontWeight: FontWeight.normal,
        ),
      );
    }

    return Text(
      item.nameEn!,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, Union? item, bool isSelected) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
        padding: const EdgeInsets.only(left: 10.0, top: 2.0, bottom: 2.0),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Colors.white),
                // borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: Text(
          item!.nameEn ?? '',
          style: TextStyle(
            color: Colors.black,
          ),
        ));
  }
}
