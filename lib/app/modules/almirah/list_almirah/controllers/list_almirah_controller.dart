import 'package:app/app/data/model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controllers/almirah_controller.dart';

class ListAlmirahController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final almirahController = Get.find<AlmirahController>();
  final isLoading = false.obs;
  final almirahList = <Almirah>[].obs;
  final searchedAlmirahList = <Almirah>[].obs;
  final selectedIndex = 0.obs;

  void addSearchedAlmirah(Almirah almirah) {
    almirahController.objectBoxController.searchedAlmirahBox
        .put(SearchedAlmirah()..searchedAlmirah.target = almirah);
  }

  @override
  void onReady() {
    super.onReady();
    almirahList.value =
        almirahController.objectBoxController.almirahBox.getAll();
  }
}
