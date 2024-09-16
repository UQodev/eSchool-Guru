// import 'package:eschool_saas_staff/app/appTranslation.dart';
import 'package:eschool_saas_staff/data/models/leaveDetails.dart';
import 'package:eschool_saas_staff/ui/widgets/customTextContainer.dart';
import 'package:eschool_saas_staff/ui/widgets/profileImageContainer.dart';
import 'package:eschool_saas_staff/ui/widgets/textWithFadedBackgroundContainer.dart';
import 'package:eschool_saas_staff/utils/constants.dart';
// import 'package:eschool_saas_staff/utils/labelKeys.dart';
import 'package:eschool_saas_staff/utils/utils.dart';
import 'package:flutter/material.dart';

class LeaveDetailsContainer extends StatelessWidget {
  final LeaveDetails leaveDetails;
  const LeaveDetailsContainer({super.key, required this.leaveDetails});

  String translateRole(String role) {
    final Map<String, String> roleTranslations = {
      "Teacher": "Guru",
    };

    return roleTranslations[role] ?? role;
  }

  String translateLeaveType(String leaveType) {
    final Map<String, String> leaveTranslations = {
      "Full": "Sehari Penuh",
      "First Half": "Setengah Pertama",
      "Second Half": "Setengah Kedua",
    };
    String translated = leaveTranslations[leaveType] ?? leaveType ?? '';
    print("Translating $leaveType to $translated");
    return translated;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: appContentHorizontalPadding),
      padding: EdgeInsets.symmetric(
          horizontal: appContentHorizontalPadding,
          vertical: appContentHorizontalPadding),
      width: double.maxFinite,
      height: 140,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.5),
          color: Theme.of(context).scaffoldBackgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextWithFadedBackgroundContainer(
                backgroundColor:
                    Theme.of(context).colorScheme.error.withOpacity(0.1),
                textColor: Theme.of(context).colorScheme.error,
                titleKey: translateLeaveType(leaveDetails.type ?? ""),
              ),
              const Spacer(),
              TextWithFadedBackgroundContainer(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                textColor: Theme.of(context).colorScheme.primary,
                titleKey: leaveDetails.leaveDate ?? "",
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              ProfileImageContainer(
                imageUrl: leaveDetails.leave?.user?.image ?? "",
              ),
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextContainer(
                      textKey: leaveDetails.leave?.user?.fullName ?? "",
                      style: const TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    CustomTextContainer(
                      textKey:
                          "${Utils.getTranslatedLabel('role')}: ${translateRole(leaveDetails.leave?.user?.roles?.first.name ?? '')}",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
