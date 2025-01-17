import 'dart:io';

import 'package:cluster/common_widgets/loading.dart';
import 'package:cluster/common_widgets/no_glow.dart';
import 'package:cluster/common_widgets/reusable_textfield.dart';
import 'package:cluster/core/color_palatte.dart';
import 'package:cluster/core/utils/variables.dart';
import 'package:cluster/presentation/authentication/authentication.dart';
import 'package:cluster/presentation/dashboard_screen/home_screen/home_svg.dart';
import 'package:cluster/presentation/dashboard_screen/home_screen/homescreen_widget/appbar.dart';
import 'package:cluster/presentation/order_app/order_svg.dart';
import 'package:cluster/presentation/order_app/utils/custom_check_box.dart';
import 'package:cluster/presentation/promotion_app/blocs/discount_bloc/discount_bloc.dart';
import 'package:cluster/presentation/promotion_app/dropdown_card.dart';
import 'package:cluster/presentation/promotion_app/models_promotion/discount_models/model_discount.dart';
import 'package:cluster/presentation/promotion_app/promotion_sale/promotion_sale.dart';
import 'package:cluster/presentation/promotion_app/promotion_svg.dart';
import 'package:cluster/presentation/promotion_app/widget/file_upload_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import '../../../common_widgets/gradient_button.dart';

class PromotionSaleForm extends StatefulWidget {
  final String? restorationId;
  PromotionSaleForm({Key? key, this.restorationId}) : super(key: key);

  @override
  State<PromotionSaleForm> createState() => _NewPromotionState();
}

class _NewPromotionState extends State<PromotionSaleForm>
    with RestorationMixin {
  bool isAvailable = true;
  bool isPriority = false;
  bool isActive = false;
  List<String> segmentListttt = [];
  List<GetTypeApplying> availableCustomerList = [];
  String _selectedDate1 = '';
  String _dateCount = '';
  String _range = '';
  String _range2 = '';
  String _rangeCount = '';
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('yyyy-MM-dd').format(args.value.startDate)} -'
            ' ${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
        _range2 = '${DateFormat('dd-MM-yyyy').format(args.value.startDate)} -'
            ' ${DateFormat('dd-MM-yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate1 = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  GetOfferPeriod? offerperiodRead;
  GetOfferGroup? offerGroup;
  String? offerPeriodName;
  String? offerGroupName;
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.white, // <-- SEE HERE
              onPrimary: Colors.green, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  // primary: Colors.red, // button text color
                  ),
            ),
          ),
          child: DatePickerDialog(
            restorationId: 'date_picker_dialog',
            initialEntryMode: DatePickerEntryMode.calendar,
            initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
            firstDate: DateTime(2021),
            lastDate: DateTime(2022),
          ),
        );
      },
    );
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  @override
  void initState() {
    context.read<DiscountBloc>().add(const GetSegmentListEvent());
    context.read<DiscountBloc>().add(PaginatedOfferPeriodEvent("", ""));
    context.read<DiscountBloc>().add(PaginatedChannelListEvent(""));
    context.read<DiscountBloc>().add(PaginatedOfferGroupEvent(""));
    context.read<DiscountBloc>().add(GetOfferAppliyingBasedOnReadEvent());
    context.read<DiscountBloc>().add(PaginatedCustomerGroupEvent("", ""));
    super.initState();
  }

  final picker = ImagePicker();
  File? cropImage;
  bool _cropped = false;
  dynamic? imageId;
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
      print(_time);
    }
  }

  String? segmentName;
  List<GetSegmentList> segmentList = [];
  List<GetSegmentList> discountSegment = [];
  List<GetTypeApplying> customerList = [];
  List<GetOfferPeriod> offerPeriodList = [];
  List<GetOfferGroup> offergroupList = [];
  List<ChannelList> channelList = [];
  List<String> basedOn = [];
  String? basedOnValue;
  TextEditingController promotionTitle = TextEditingController();
  TextEditingController promotionDescription = TextEditingController();
  TextEditingController promotiondiscount = TextEditingController();
  int? offerperiodId;
  int? offergroupId;
  String? discountChannelCode;
  DiscountList? readDiscount;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BackAppBar(label: "New Promotion"),
      ),
      body: ScrollConfiguration(
        behavior: NoGlow(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.string(PromotionSvg().progressDesign),
                SizedBox(
                  height: 30,
                ),
                DropDownCard(
                  selValue: segmentName,
                  onTap: () {
                    _showModalBottomSheet();
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormReusable(
                  label: "Promotion Title",
                  hint: "Eg. SEM",
                  controller: promotionTitle,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormReusable(
                  label: "Description",
                  hint: "Eg. Lorem ipsum dolar sit amet.",
                  controller: promotionDescription,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Customer Group",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: w / 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xffe6ecf0),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x05000000),
                        blurRadius: 8,
                        offset: Offset(1, 1),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: isAvailable
                            ? const EdgeInsets.all(10)
                            : const EdgeInsets.only(
                                left: 10, top: 10, bottom: 0, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Is Available for All",
                              style: GoogleFonts.roboto(
                                color: const Color(0xff151522),
                                fontSize: w / 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isAvailable = !isAvailable;
                                });
                              },
                              child: isAvailable
                                  ? SvgPicture.string(HomeSvg().toggleActive)
                                  : SvgPicture.string(HomeSvg().toggleInActive),
                            )
                          ],
                        ),
                      ),
                      isAvailable
                          ? Container()
                          : Column(
                              children: [
                                const Divider(
                                  indent: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 0, bottom: 10, right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showModalBottomSheetCustomer();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Eg. Lorem ipsum dolar sit amet.",
                                          style: TextStyle(
                                            color: const Color(0x7f666161),
                                            fontSize: w / 24,
                                          ),
                                        ),
                                        const Icon(
                                            Icons.keyboard_arrow_down_outlined)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                DropDownCard(
                  selValue: offerPeriodName,
                  label: "Offer Period",
                  onTap: () {
                    _showModalBottomSheetOfferPeriod();
                  },
                ),
                // const SizedBox(
                //   height: 16,
                // ),
                // DropDownCard(
                //   selValue: offerGroupName,
                //   label: "Offer Group",
                //   onTap: (){
                //     _showModalBottomSheetOfferGroup();
                //   },
                // ),
                const SizedBox(
                  height: 16,
                ),
                Flex(direction: Axis.vertical, children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Based On",
                        style: GoogleFonts.roboto(
                          color: ColorPalette.black,
                          fontSize: w / 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                          width: w,
                          padding: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xffe6ecf0)),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton<String>(
                            underline: Container(),
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 220),
                              child: Icon(Icons.arrow_drop_down_circle),
                            ),
                            hint: const Text("Based On"),
                            value: basedOnValue,
                            onChanged: (value) {
                              setState(() {
                                basedOnValue = value;
                              });
                            },
                            items: basedOn
                                .map<DropdownMenuItem<String>>(
                                    (String _value) => DropdownMenuItem<String>(
                                        value: _value,
                                        child: Text(
                                          _value ?? "",
                                        )))
                                .toList(),
                          )
                          //     :Padding(
                          // padding: const EdgeInsets.only(top: 10,bottom: 10),
                          // child: Text(codeChannel.toString()),
                          // ),
                          ),
                    ],
                  ),
                ]),
                const SizedBox(
                  height: 16,
                ),
                TextFormReusable(
                  label: "Discount Percentage / Price",
                  hint: "Eg. Lorem ipsum dollar sit amet.",
                  controller: promotiondiscount,
                ),
                const SizedBox(
                  height: 10,
                ),
                FileUploadCard(
                  label: imageId == null ? "No file chosen" : "Image Selected",
                  onTap: () {
                    getCoverImage(ImageSource.gallery);
                  },
                ),

                const SizedBox(
                  height: 30,
                ),
                GradientButton(
                    color: ColorPalette.primary,
                    onPressed: () {
                      print("IFFF$offergroupId");
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: PromotionSaleFormTwo(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    },
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [ColorPalette.primary, ColorPalette.primary]),
                    child: Text(
                      "Continue",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: w / 22,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showModalBottomSheet() {
    final TextEditingController groupName = TextEditingController();
    int select = 0;

    void onselect(int index) {
      setState(() {
        select = index;
      });
    }

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
        context: context,
        builder: (context) {
          print("qqqqqqqqqqqqqqqqq${segmentListttt}");
          var h = MediaQuery.of(context).size.height;
          var w = MediaQuery.of(context).size.width;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 450,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    )),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Select Segments",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: w / 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.separated(
                              primary: true,
                              shrinkWrap: true,
                              itemCount: segmentList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Row(
                                children: [
                                  CustomCheckBox(
                                    key: UniqueKey(),
                                    value:
                                        // widget.readUser,
                                        segmentListttt
                                            .contains(segmentList[index].name),
                                    onChange: (p0) {
                                      if (p0) {
                                        segmentListttt
                                            .add(segmentList[index].name ?? "");
                                        discountSegment.add(GetSegmentList(
                                            segmentName:
                                                segmentList[index].name,
                                            segmentCode:
                                                segmentList[index].code));
                                      } else {
                                        segmentListttt.remove(
                                            segmentList[index].name ?? "");
                                        discountSegment.remove(GetSegmentList(
                                            name: segmentList[index].name,
                                            code: segmentList[index].code));
                                      }
                                      // widget.listuser(widget.userList);
                                      print("seg-list${segmentListttt}");
                                      print("seg-list${discountSegment}");
                                    },
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    segmentList[index].name ?? "",
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: w / 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              separatorBuilder: (context, index) => Container(
                                color: ColorPalette.divider,
                                height: 1,
                                width: w,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GradientButton(
                                color: ColorPalette.primary,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      ColorPalette.primary,
                                      ColorPalette.primary
                                    ]),
                                child: Text(
                                  "Select and Continue",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: w / 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  _showModalBottomSheetCustomer() {
    final TextEditingController groupName = TextEditingController();
    int select = 0;

    void onselect(int index) {
      setState(() {
        select = index;
      });
    }

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
        context: context,
        builder: (context) {
          print("qqqqqqqqqqqqqqqqq${availableCustomerList}");
          var h = MediaQuery.of(context).size.height;
          var w = MediaQuery.of(context).size.width;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 450,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    )),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Select Customer Group",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: w / 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.separated(
                              primary: true,
                              shrinkWrap: true,
                              itemCount: customerList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Row(
                                children: [
                                  CustomCheckBox(
                                    key: UniqueKey(),
                                    value:
                                        // widget.readUser,
                                        availableCustomerList
                                            .contains(customerList[index].name),
                                    onChange: (p0) {
                                      if (p0) {
                                        availableCustomerList
                                            .add(GetTypeApplying(
                                          customerGroupId:
                                              customerList[index].code,
                                          customerGroupCode:
                                              customerList[index].code,
                                        ));
                                      } else {
                                        availableCustomerList
                                            .remove(GetTypeApplying(
                                          customerGroupId:
                                              customerList[index].code,
                                          customerGroupCode:
                                              customerList[index].code,
                                        ));
                                      }
                                      // widget.listuser(widget.userList);
                                      print(
                                          "customer list${availableCustomerList}");
                                    },
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    customerList[index].name ?? "",
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: w / 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              separatorBuilder: (context, index) => Container(
                                color: ColorPalette.divider,
                                height: 1,
                                width: w,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GradientButton(
                                color: ColorPalette.primary,
                                onPressed: () {
                                  Navigator.pop(context);
                                  // PersistentNavBarNavigator.pushNewScreen(
                                  //   context,
                                  //   screen: const NewPromotion(),
                                  //   withNavBar: true, // OPTIONAL VALUE. True by default.
                                  //   pageTransitionAnimation: PageTransitionAnimation.fade,
                                  // );  da
                                },
                                gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      ColorPalette.primary,
                                      ColorPalette.primary
                                    ]),
                                child: Text(
                                  "Select and Continue",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: w / 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  _showModalBottomSheetNew(BuildContext context, bool edit) {
    final TextEditingController title = TextEditingController();
    final TextEditingController discription = TextEditingController();
    final TextEditingController note = TextEditingController();
    String? fromDate;
    String? toDate;
    String? fromTime;
    String? toTime;

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          var h = MediaQuery.of(context).size.height;
          var w = MediaQuery.of(context).size.width;
          return BlocListener<DiscountBloc, DiscountState>(
            listener: (context, state) {
              if (state is GetOfferPeriodReadLoading) {
                customCupertinoLoading();
              }
              if (state is GetOfferPeriodReadSuccess) {
                offerperiodRead = state.offerPeriod;
                title.text = state.offerPeriod.title ?? "";
                discription.text = state.offerPeriod.description ?? "";
                note.text = state.offerPeriod.notes ?? "";
                fromDate = state.offerPeriod.fromDate ?? "";
                toDate = state.offerPeriod.toDate ?? "";
                fromTime = state.offerPeriod.fromTime ?? "";
                toTime = state.offerPeriod.toTime ?? "";
                setState(() {});
              }
            },
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: EdgeInsets.all(20),
                  height: h / 1.35,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      )),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        edit ? "Update Offer Period" : "Create Offer Period",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormReusable(
                        label: "Name",
                        hint: "Enter name",
                        controller: title,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormReusable(
                        controller: discription,
                        label: "Description",
                        hint: "Enter Description",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormReusable(
                        controller: note,
                        label: "Notes",
                        hint: "Enter Notes",
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 300,
                                        child: Scaffold(
                                          body: SfDateRangePicker(
                                            backgroundColor: Colors.white,
                                            endRangeSelectionColor:
                                                ColorPalette.primary,
                                            startRangeSelectionColor:
                                                ColorPalette.primary,
                                            rangeSelectionColor: ColorPalette
                                                .primary
                                                .withOpacity(0.1),
                                            selectionColor: Colors.grey,
                                            todayHighlightColor:
                                                ColorPalette.primary,
                                            onSelectionChanged:
                                                _onSelectionChanged,
                                            selectionMode:
                                                DateRangePickerSelectionMode
                                                    .range,
                                            initialSelectedRange:
                                                PickerDateRange(
                                                    DateTime.now().subtract(
                                                        const Duration(
                                                            days: 4)),
                                                    DateTime.now()
                                                        .add(const Duration(
                                                            days: 3))),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: w / 3,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          alignment: Alignment.center,
                                          color: ColorPalette.primary,
                                          child: Text(
                                            "Ok",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.string(PromotionSvg().calenderIcon),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Start Date",
                                  style: GoogleFonts.roboto(
                                    color: Color(0xff151522),
                                    fontSize: w / 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              edit
                                  ? fromDate ?? ""
                                  : _range.isEmpty
                                      ? "Choose Date"
                                      : _range.split(" - ")[0],
                              textAlign: TextAlign.right,
                              style: GoogleFonts.roboto(
                                color: Color(0xff797979),
                                fontSize: w / 22,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: ColorPalette.divider,
                        thickness: 1.1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.string(PromotionSvg().calenderIcon),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "End Date",
                                style: GoogleFonts.roboto(
                                  color: Color(0xff151522),
                                  fontSize: w / 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          Text(
                            edit
                                ? toDate ?? ""
                                : _range.isEmpty
                                    ? "Choose Date"
                                    : _range.split(" - ")[1],
                            textAlign: TextAlign.right,
                            style: GoogleFonts.roboto(
                              color: Color(0xff797979),
                              fontSize: w / 22,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: ColorPalette.divider,
                        thickness: 1.1,
                      ),
                      GestureDetector(
                        onTap: _selectTime,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.string(PromotionSvg().clockIcon),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Start Time",
                                  style: GoogleFonts.roboto(
                                    color: Color(0xff151522),
                                    fontSize: w / 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              edit
                                  ? fromTime ?? ""
                                  : "${_time.hour}"
                                          ":"
                                          "${_time.minute} ${_time.period.name}" ??
                                      "",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.roboto(
                                color: Color(0xff797979),
                                fontSize: w / 22,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: ColorPalette.divider,
                        thickness: 1.1,
                      ),
                      GestureDetector(
                        onTap: _selectTime,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.string(PromotionSvg().clockIcon),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "End Time",
                                  style: GoogleFonts.roboto(
                                    color: Color(0xff151522),
                                    fontSize: w / 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              edit
                                  ? toTime ?? ""
                                  : "${_time.hour}"
                                          ":"
                                          "${_time.minute} ${_time.period.name}" ??
                                      "",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.roboto(
                                color: Color(0xff797979),
                                fontSize: w / 22,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GradientButton(
                          color: ColorPalette.primary,
                          onPressed: () {
                            edit
                                ? BlocProvider.of<DiscountBloc>(context).add(
                                    UpdateOfferPeriodEvent(
                                        id: offerperiodRead?.id,
                                        isActive: offerperiodRead?.isActive,
                                        createdBy: offerperiodRead?.createdBy,
                                        description: discription.text ?? "",
                                        fromTime: fromTime == ""
                                            ? "${_time.hour}"
                                                ":"
                                                "${_time.minute} ${_time.period.name}"
                                            : fromTime.toString(),
                                        note: note.text,
                                        title: title.text,
                                        toDate: toDate == ""
                                            ? _range.split(" - ")[1]
                                            : toDate.toString(),
                                        toTime: toTime == ""
                                            ? "${_time.hour}"
                                                ":"
                                                "${_time.minute} ${_time.period.name}"
                                            : toTime.toString(),
                                        fromDate: fromTime == ""
                                            ? _range.split(" - ")[0]
                                            : fromTime.toString()))
                                : BlocProvider.of<DiscountBloc>(context).add(
                                    CreateOfferPeriodEvent(
                                        isActive: true,
                                        createdBy: authentication
                                            .authenticatedUser.code,
                                        description: discription.text ?? "",
                                        fromTime: "${_time.hour}"
                                                ":"
                                                "${_time.minute} ${_time.period.name}" ??
                                            "",
                                        note: note.text,
                                        title: title.text,
                                        toDate: _range.split(" - ")[1],
                                        toTime: "${_time.hour}"
                                                ":"
                                                "${_time.minute} ${_time.period.name}" ??
                                            "",
                                        fromDate: _range.split(" - ")[0]));
                          },
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: const [
                                ColorPalette.primary,
                                ColorPalette.primary
                              ]),
                          child: Text(
                            edit ? "Update" : "Create New",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      edit
                          ? GradientButton(
                              color: ColorPalette.primary,
                              onPressed: () {
                                BlocProvider.of<DiscountBloc>(context).add(
                                    DeleteOfferPeriodEvent(
                                        offerperiodRead?.id ?? 0));
                              },
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    ColorPalette.primary,
                                    ColorPalette.primary
                                  ]),
                              child: Text(
                                "Delete",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                          : Container()
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  _showModalBottomSheetOfferPeriod() {
    final TextEditingController groupName = TextEditingController();
    int select = 0;
    void onselect(int index) {
      setState(() {
        select = index;
      });
    }

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
        context: context,
        builder: (context) {
          var h = MediaQuery.of(context).size.height;
          var w = MediaQuery.of(context).size.width;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    )),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "Select Offer Period",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: w / 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.separated(
                              primary: true,
                              shrinkWrap: true,
                              itemCount: offerPeriodList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      onselect(index);
                                      setState(() {});
                                      offerperiodId =
                                          offerPeriodList[index].id ?? 0;
                                      offerPeriodName =
                                          offerPeriodList[index].title ?? "";
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 8,
                                          bottom: 10,
                                          top: 5,
                                          right: 8),
                                      child: SvgPicture.string(select == index
                                          ? HomeSvg().radioButtonActive
                                          : HomeSvg().radioInActive),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    offerPeriodList[index].title ?? "",
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: w / 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      context.read<DiscountBloc>().add(
                                          GetOfferPeriodReadEvent(
                                              offerPeriodList[index].id ?? 0));
                                      _showModalBottomSheetNew(context, true);
                                    },
                                    child: Text(
                                      "View",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: ColorPalette.primary,
                                          fontSize: w / 24),
                                    ),
                                  )
                                ],
                              ),
                              separatorBuilder: (context, index) => Container(
                                color: ColorPalette.divider,
                                height: 1,
                                width: w,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GradientButton(
                                color: ColorPalette.primary,
                                onPressed: () {
                                  _showModalBottomSheetNew(context, false);
                                },
                                gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      ColorPalette.primary,
                                      ColorPalette.primary
                                    ]),
                                child: Text(
                                  "Create New",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: w / 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  _showModalBottomSheetOfferGroup() {
    final TextEditingController groupName = TextEditingController();
    int select = 0;
    void onselect(int index) {
      setState(() {
        select = index;
      });
    }

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
        context: context,
        builder: (context) {
          var h = MediaQuery.of(context).size.height;
          var w = MediaQuery.of(context).size.width;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    )),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "Select Offer Group",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: w / 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.separated(
                              primary: true,
                              shrinkWrap: true,
                              itemCount: offergroupList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      onselect(index);
                                      setState(() {});
                                      offergroupId =
                                          offergroupList[index].id ?? 0;
                                      discountChannelCode =
                                          offergroupList[index].channelCode ??
                                              "";
                                      offerGroupName =
                                          offergroupList[index].title ?? "";
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 8,
                                          bottom: 10,
                                          top: 5,
                                          right: 8),
                                      child: SvgPicture.string(select == index
                                          ? HomeSvg().radioButtonActive
                                          : HomeSvg().radioInActive),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    offergroupList[index].title ?? "",
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: w / 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Variable.offerGroupId =
                                          offergroupList[index].id ?? 0;
                                      print("OFFFER${Variable.offerGroupId}");
                                      context.read<DiscountBloc>().add(
                                          GetOfferGroupReadEvent(
                                              offergroupList[index].id ?? 0));
                                      setState(() {});
                                      _showModalBottomSheetGroupCreate(
                                          context, true);
                                    },
                                    child: Text(
                                      "View",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: ColorPalette.primary,
                                          fontSize: w / 24),
                                    ),
                                  )
                                ],
                              ),
                              separatorBuilder: (context, index) => Container(
                                color: ColorPalette.divider,
                                height: 1,
                                width: w,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GradientButton(
                                color: ColorPalette.primary,
                                onPressed: () {
                                  _showModalBottomSheetGroupCreate(
                                      context, false);
                                },
                                gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      ColorPalette.primary,
                                      ColorPalette.primary
                                    ]),
                                child: Text(
                                  "Create New",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: w / 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  _showModalBottomSheetGroupCreate(BuildContext context, bool edit) {
    final TextEditingController titlegroup = TextEditingController();
    final TextEditingController discriptiongroup = TextEditingController();
    final TextEditingController note = TextEditingController();
    String? codeChannel;
    String? drop;

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          var h = MediaQuery.of(context).size.height;
          var w = MediaQuery.of(context).size.width;
          return BlocListener<DiscountBloc, DiscountState>(
            listener: (context, state) {
              print("THAT STATE$state");
              if (state is GetOfferGroupReadLoading) {
                customCupertinoLoading();
              }
              if (state is GetOfferGroupReadSuccess) {
                offerGroup = state.offerGroup;
                titlegroup.text = state.offerGroup.title ?? "";
                discriptiongroup.text = state.offerGroup.description ?? "";
                codeChannel = state.offerGroup.channelCode ?? "";

                setState(() {});
              }
            },
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: EdgeInsets.all(20),
                  height: h / 1.5,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      )),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        edit ? "Update Offer Group" : "Create Offer Group",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FileUploadCard(
                        onTap: () {
                          getCoverImage(ImageSource.gallery);
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormReusable(
                        label: "Title",
                        hint: "Enter Title",
                        controller: titlegroup,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormReusable(
                        controller: discriptiongroup,
                        label: "Description",
                        hint: "Enter Description",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flex(direction: Axis.vertical, children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Channel",
                              style: GoogleFonts.roboto(
                                color: ColorPalette.black,
                                fontSize: w / 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                                width: w,
                                padding: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xffe6ecf0)),
                                    borderRadius: BorderRadius.circular(10)),
                                child: DropdownButton<String>(
                                  underline: Container(),
                                  icon: const Padding(
                                    padding: EdgeInsets.only(left: 160),
                                    child: Icon(Icons.arrow_drop_down_circle),
                                  ),
                                  hint: const Text("Select Channel"),
                                  value: drop,
                                  onChanged: (value) {
                                    setState(() {
                                      drop = value;
                                    });
                                  },
                                  items: channelList
                                      .map<DropdownMenuItem<String>>(
                                          (ChannelList _value) =>
                                              DropdownMenuItem<String>(
                                                  value: _value.channelCode,
                                                  child: Text(
                                                    _value.channelCode ?? "",
                                                  )))
                                      .toList(),
                                )
                                //     :Padding(
                                // padding: const EdgeInsets.only(top: 10,bottom: 10),
                                // child: Text(codeChannel.toString()),
                                // ),
                                ),
                          ],
                        ),
                      ]),
                      SizedBox(
                        height: 30,
                      ),
                      GradientButton(
                          color: ColorPalette.primary,
                          onPressed: () {
                            print("AAAAAAAAAAA${Variable.offerGroupId}");
                            print("AAAAAAAAAAA${drop}");
                            edit
                                ? BlocProvider.of<DiscountBloc>(context).add(
                                    UpdateOfferGroupEvent(
                                        priority: 0,
                                        id: Variable.offerGroupId,
                                        isActive: offerGroup?.isActive,
                                        createdBy: authentication
                                            .authenticatedUser.code,
                                        description:
                                            discriptiongroup.text ?? "",
                                        img: imageId ?? 0,
                                        title: titlegroup.text ?? ""))
                                : BlocProvider.of<DiscountBloc>(context).add(
                                    CreateOfferGroupEvent(
                                        priorty: 0,
                                        isActive: true,
                                        createdBy: authentication
                                            .authenticatedUser.code,
                                        description:
                                            discriptiongroup.text ?? "",
                                        title: titlegroup.text,
                                        image: imageId ?? 0,
                                        channelCode: drop ?? "",
                                        inventoryId: authentication
                                                .authenticatedUser
                                                .organisationCode ??
                                            ""));
                          },
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: const [
                                ColorPalette.primary,
                                ColorPalette.primary
                              ]),
                          child: Text(
                            edit ? "Update" : "Create Group",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      edit
                          ? GradientButton(
                              color: ColorPalette.primary,
                              onPressed: () {
                                BlocProvider.of<DiscountBloc>(context).add(
                                    DeleteOfferGroupEvent(
                                        Variable.offerGroupId ?? 0));
                              },
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    ColorPalette.primary,
                                    ColorPalette.primary
                                  ]),
                              child: Text(
                                "Delete",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                          : Container()
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  Future<void> getCoverImage(source) async {
    try {
      final pickedFile =
          await picker.pickImage(source: source, maxHeight: 512, maxWidth: 512);

      cropImage = (pickedFile != null ? File(pickedFile.path) : null)!;

      if (cropImage != null) {
        BlocProvider.of<DiscountBloc>(context)
            .add(PostImageDiscountEvent(cropImage!));
      }
      setState(() {
        _cropped = true;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
