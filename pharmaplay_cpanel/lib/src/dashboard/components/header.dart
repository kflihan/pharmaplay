import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharma_repository/pharma_repository.dart';
import 'package:pharmaplay_cpanel/generated/l10n.dart';
import 'package:pharmaplay_cpanel/src/authentication/authentication.dart';
import 'package:pharmaplay_cpanel/src/dashboard/bloc/dashboard_bloc.dart';
import 'package:pharmaplay_cpanel/src/dashboard/druggroup/druggroup.dart';
import 'package:pharmaplay_cpanel/src/dashboard/drugs/drug.dart';
import 'package:pharmaplay_cpanel/src/utlites/responsive.dart';
import 'package:pharmaplay_cpanel/src/utlites/sforms_style.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              context.read<DashBoardBloc>().add(SideMenuClicked(context));
            },
          ),
        if (!Responsive.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.headline6,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        Expanded(child: SearchField()),
        const ProfileCard(),

        //----

        //---
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale newLocale = context.read<DashBoardBloc>().state.localeUI;

    return BlocBuilder<DashBoardBloc, DashBoardState>(
      builder: (context, state) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // radius of 10
                // border: Border.all(
                //     color: context.read<DashBoardBloc>().state.fontbodyColor),
                color: context
                    .read<DashBoardBloc>()
                    .state
                    .secondaryColor // green as background color
                ),
            child: Row(
              children: [
                FloatingActionButton(
                    child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    // print(
                    //    '---=-=-=-=-=-=-= state Avatar : ' + state.user!.id ??
                    //        'nnnnn');
                    return CircleAvatar(
                      radius: 25,
                      backgroundImage: (state.user?.IsGuest() == false)
                          ? const AssetImage("assets/images/profile_pic.png")
                          : const AssetImage("assets/images/flutter_logo.png"),
                    );
                  },
                ), onPressed: () {
                  print('hihhhii');
                  context.read<DashBoardBloc>().add(RightMenuClicked(context));
                }),
                if (!Responsive.isMobile(context))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                    child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
                        return Text(context
                                .read<AuthenticationBloc>()
                                .state
                                .user
                                ?.email ??
                            'Guest');
                      },
                    ),
                  ),
                ClipOval(
                  child: Material(
                    color: context
                        .read<DashBoardBloc>()
                        .state
                        .secondaryColor, // button color
                    child: InkWell(
                      // splashColor: Colors.red, // inkwell color
                      child: const SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.more_vert_rounded)),
                      onTap: () {
                        context
                            .read<DashBoardBloc>()
                            .add(RightMenuClicked(context));
                      },
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }
}

class SearchField extends StatelessWidget {
  SearchField({
    Key? key,
  }) : super(key: key);
  final headerSerachFieldCTextCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashBoardBloc, DashBoardState>(
      builder: (context, state) {
        return TextField(
          controller: headerSerachFieldCTextCtrl,
          onChanged: (value) {
            //  print(value);
            context.read<DashBoardBloc>().add(HeaderSerachFieldChanged(value));
          },
          decoration: InputDecoration(
            hintText: SLang.of(context).search,
            fillColor: context.read<DashBoardBloc>().state.secondaryColor,
            filled: true,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            suffixIcon: InkWell(
              onTap: () {
                context
                    .read<DashBoardBloc>()
                    .add(const HeaderSerachSubmitted());
                print('Searching!!!!' +
                    context.read<DashBoardBloc>().state.localeUI.languageCode);

                var _serachValue =
                    context.read<DashBoardBloc>().state.headerSerachField;
                if (context
                    .read<DashBoardBloc>()
                    .state
                    .headSearchFilterApplied) {
                  headerSerachFieldCTextCtrl.clear();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                margin:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                decoration: BoxDecoration(
                  color: context.read<DashBoardBloc>().state.secondaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child:
                    context.read<DashBoardBloc>().state.headSearchFilterApplied
                        ? const Icon(Icons.dangerous)
                        : const Icon(Icons.search),
                //SvgPicture.asset("assets/icons/Search.svg"),
              ),
            ),
          ),
        );
      },
    );
  }
}
