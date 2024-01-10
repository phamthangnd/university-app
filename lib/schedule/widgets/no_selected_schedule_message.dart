import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/colorful_button.dart';

class NoSelectedScheduleMessage extends StatelessWidget {
  const NoSelectedScheduleMessage({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isTable = MediaQuery.of(context).size.width > tabletBreakpoint;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: isTable ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/Saly-2.png',
                height: 200,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Active group not set",
              style: AppTextStyle.h5,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Download the schedule for at least one group to display the calendar.",
              style: AppTextStyle.captionL.copyWith(
                color: AppTheme.colors.deactive,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: isTable ? 420 : double.infinity,
              child: ColorfulButton(
                text: "Điều chỉnh",
                onClick: onTap,
                backgroundColor: AppTheme.colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
