import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/utils.dart';

enum LetterAlignment { left, right }

class AlphabetScrollView extends StatefulWidget {
  final List<AlphaModel> list;

  /// defaults to ```true```
  /// if specified as ```false```
  /// all alphabets will be shown regardless of
  /// whether the item in the [list] exists starting with
  /// that alphabet.

  final bool isAlphabetsFiltered;

  /// Widget to show beside the selected alphabet
  /// if not specified it will be hidden.
  /// ```
  /// overlayWidget:(value)=>
  ///    Container(
  ///       height: 50,
  ///       width: 50,
  ///       alignment: Alignment.center,
  ///       color: Theme.of(context).primaryColor,
  ///       child: Text(
  ///                 '$value'.toUpperCase(),
  ///                  style: TextStyle(fontSize: 20, color: Colors.white),
  ///              ),
  ///      )
  /// ```

  final Widget Function(BuildContext, int, AlphaModel) itemBuilder;
  AlphabetScrollView({
    Key? key,
    required this.list,
    this.isAlphabetsFiltered = true,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  AlphabetScrollViewState createState() => AlphabetScrollViewState();
}

class AlphabetScrollViewState extends State<AlphabetScrollView> {
  void init() {
    widget.list
        .sort((x, y) => x.name.toLowerCase().compareTo(y.name.toLowerCase()));
    _list = widget.list;
    setState(() {});

    /// filter Out AlphabetList
    if (widget.isAlphabetsFiltered) {
      List<String> temp = [];
      for (var letter in alphabets) {
        AlphaModel? firstAlphabetElement = _list.firstWhereOrNull(
            (item) => item.name.toLowerCase().startsWith(letter.toLowerCase()));
        if (firstAlphabetElement != null) {
          temp.add(letter);
        }
      }
      _filteredAlphabets = temp;
    } else {
      _filteredAlphabets = alphabets;
    }
    calculateFirstIndex();
    setState(() {});
  }

  @override
  void initState() {
    init();
    if (listController.hasClients) {
      maxScroll = listController.position.maxScrollExtent;
    }
    super.initState();
  }

  ScrollController listController = ScrollController();
  final _selectedIndexNotifier = ValueNotifier<int>(0);
  final positionNotifer = ValueNotifier<Offset>(Offset(0, 0));
  final Map<String, int> firstIndexPosition = {};
  List<String> _filteredAlphabets = [];
  final letterKey = GlobalKey();
  List<AlphaModel> _list = [];
  bool isLoading = false;

  /// @var		bool	isFocused
  bool isFocused = false;
  final key = GlobalKey();

  @override
  void didUpdateWidget(covariant AlphabetScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.list != widget.list ||
        oldWidget.isAlphabetsFiltered != widget.isAlphabetsFiltered) {
      _list.clear();
      firstIndexPosition.clear();
      init();
    }
  }

  int getCurrentIndex(double vPosition) {
    double kAlphabetHeight = letterKey.currentContext!.size!.height;
    return (vPosition ~/ kAlphabetHeight);
  }

  /// calculates and Maintains a map of
  /// [letter:index] of the position of the first Item in list
  /// starting with that letter.
  /// This helps to avoid recomputing the position to scroll to
  /// on each Scroll.
  void calculateFirstIndex() {
    for (var letter in _filteredAlphabets) {
      AlphaModel? firstElement = _list.firstWhereOrNull(
          (item) => item.name.toLowerCase().startsWith(letter));
      if (firstElement != null) {
        int index = _list.indexOf(firstElement);
        firstIndexPosition[letter] = index;
      }
    }
  }

  void scrolltoIndex(int x, Offset offset) {
    int index = firstIndexPosition[_filteredAlphabets[x].toLowerCase()]!;
    final scrollToPostion = 50.0 * index;
    listController.animateTo((scrollToPostion),
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    positionNotifer.value = offset;
  }

  void onVerticalDrag(Offset offset) {
    int index = getCurrentIndex(offset.dy);
    if (index < 0 || index >= _filteredAlphabets.length) return;
    _selectedIndexNotifier.value = index;
    setState(() {
      isFocused = true;
    });
    scrolltoIndex(index, offset);
  }

  double? maxScroll;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          controller: listController,
          scrollDirection: Axis.vertical,
          itemCount: _list.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (_, x) {
            return widget.itemBuilder(_, x, _list[x]);
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            key: key,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: SingleChildScrollView(
              child: GestureDetector(
                onVerticalDragStart: (z) => onVerticalDrag(z.localPosition),
                onVerticalDragUpdate: (z) => onVerticalDrag(z.localPosition),
                onVerticalDragEnd: (z) {
                  setState(() {
                    isFocused = false;
                  });
                },
                child: ValueListenableBuilder<int>(
                    valueListenable: _selectedIndexNotifier,
                    builder: (context, int selected, Widget? child) {
                      return Container(
                        padding: EdgeInsets.zero,
                        width: 25.w,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade100,
                          borderRadius:
                              BorderRadius.circular(30), //border corner radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple
                                  .withOpacity(0.5), //color of shadow
                              spreadRadius: 5.sp, //spread radius
                              blurRadius: 7.sp, // blur radius
                              offset: const Offset(
                                  0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _filteredAlphabets.length,
                              (x) => GestureDetector(
                                key: x == selected ? letterKey : null,
                                onTap: () {
                                  _selectedIndexNotifier.value = x;
                                  scrolltoIndex(x, positionNotifer.value);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  child: Text(
                                    _filteredAlphabets[x].toUpperCase(),
                                    style: selected == x
                                        ? TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 82, 54, 244))
                                        : TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black),
                                  ),
                                ),
                              ),
                            )),
                      );
                    }),
              ),
            ),
          ),
        ),
        !isFocused
            ? Container()
            : ValueListenableBuilder<Offset>(
                valueListenable: positionNotifer,
                builder:
                    (BuildContext context, Offset position, Widget? child) {
                  return Positioned(
                      right: 40,
                      top: position.dy,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            size: 50,
                            color: Color.fromARGB(255, 111, 54, 244),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _filteredAlphabets[_selectedIndexNotifier.value]
                                  .toUpperCase(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ));
                })
      ],
    );
  }
}

class AlphaModel<T> {
  final T item;
  final String name;
  AlphaModel(this.item, this.name);
}

const List<String> alphabets = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
  'अ',
  'आ',
  'इ',
  'ई',
  'उ',
  'ऊ',
  'ऋ',
  'ए',
  'ऐ',
  'ओ',
  'औ',
  'अं',
  'अः',
  'क',
  'ख',
  'ग',
  'घ',
  'ङ',
  'च',
  'छ',
  'ज',
  'झ',
  'ञ',
  'ट',
  'ठ',
  'ड',
  'ढ',
  'ण',
  'त',
  'थ',
  'द',
  'ध',
  'न',
  'प',
  'फ',
  'ब',
  'भ',
  'म',
  'य',
  'र',
  'ल',
  'व',
  'श',
  'ष',
  'स',
  'ह',
  'क्ष',
  'त्र',
  'ज्ञ',
  'श्र',
];
