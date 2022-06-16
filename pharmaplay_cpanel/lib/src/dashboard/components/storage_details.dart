import 'package:flutter/material.dart';
import 'package:pharmaplay_cpanel/src/dashboard/dashboard.dart';
import 'package:pharmaplay_cpanel/src/utlites/sforms_style.dart';

import 'storage_info_card.dart';

class StarageDetails extends StatelessWidget {
  const StarageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashBoardBloc, DashBoardState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: state.secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Storage Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: defaultPadding),
              // Chart(),
              StorageInfoCard(
                svgSrc: "assets/icons/Documents.svg",
                title: "Documents Files",
                amountOfFiles: "1.3GB",
                numOfFiles: 1328,
              ),
              StorageInfoCard(
                svgSrc: "assets/icons/media.svg",
                title: "Media Files",
                amountOfFiles: "15.3GB",
                numOfFiles: 1328,
              ),
              StorageInfoCard(
                svgSrc: "assets/icons/folder.svg",
                title: "Other Files",
                amountOfFiles: "1.3GB",
                numOfFiles: 1328,
              ),
              StorageInfoCard(
                svgSrc: "assets/icons/unknown.svg",
                title: "Unknown",
                amountOfFiles: "1.3GB",
                numOfFiles: 140,
              ),
            ],
          ),
        );
      },
    );
  }
}
