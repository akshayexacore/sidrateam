import 'package:cluster/common_widgets/loading.dart';
import 'package:cluster/core/color_palatte.dart';
import 'package:cluster/presentation/task_operation/organisation_pages/organisation_bloc_task/organisation_task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common_widgets/custom_checkbox.dart';
import '../../dashboard_screen/home_screen/home_svg.dart';
import '../../mpos/collection_card.dart';
import '../create/create_svg.dart';
import '../create/single_row.dart';

class ToggleExpandCard extends StatefulWidget {
  final bool isExpaned;
  final VoidCallback? onTap;
  final String? label;
  const ToggleExpandCard(
      {super.key, this.isExpaned = false, this.onTap, this.label = "New"});

  @override
  State<ToggleExpandCard> createState() => _ToggleExpandCardState();
}

class _ToggleExpandCardState extends State<ToggleExpandCard> {
  @override
  Widget build(BuildContext context) {
    print("open box");
    double w1 = MediaQuery.of(context).size.width;
    double w = w1 > 700 ? 400 : w1;
    var h = MediaQuery.of(context).size.height;
    return Container(
      width: w,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xffe6ecf0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(1, 1),
          ),
        ],
        color: Color(0xffF8F8F8),
      ),
      child: Column(
        children: [
          ExpandedCardTask(
            label: widget.label,
            color: Color(0xffFFC800),
            endIcon: widget.isExpaned
                ? SvgPicture.string(HomeSvg().toggleActive)
                : SvgPicture.string(HomeSvg().toggleInActive),
            onTap: widget.onTap,
          ),
          widget.isExpaned
              ? Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 1,
                      color: ColorPalette.inactiveGrey.withOpacity(0.2),
                    ),
                    BlocBuilder<OrganisationTaskBloc, OrganisationTaskState>(
                      builder: (context, state) {
                        if (state is RoleUnderDepartmentListLoading) {
                          return customCupertinoLoading();
                        }
                        if (state is RoleUnderDepartmentListSuccess) {
                          return state.inventory!.isEmpty
                              ? Text("No Role Found...!")
                              : Container(
                                  width: w1,
                                  padding: EdgeInsets.only(top: 10),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      primary: false,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return CardCheckBox(
                                          text: state.inventory?[index].name??"",
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          Container(
                                            height: 10,
                                          ),
                                      itemCount: state.inventory!.length),
                                );
                        }
                        return Container();
                      },
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}

class CardCheckBox extends StatelessWidget {
  final String text;
  const CardCheckBox({super.key,this.text=""});

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;
    double w = w1 > 700 ? 400 : w1;
    var h = MediaQuery.of(context).size.height;
    return Container(

      child: Row(
        children: [
          CustomCheckBox(
              key: UniqueKey(),
              value: false,
              // uomCodeList
              //     .contains(state.inventory?[index].uomCode),
              onChange: (p0) {}),
          Container(
              width:w1/1.4,
              child: Text(text))
        ],
      ),
    );
  }
}
