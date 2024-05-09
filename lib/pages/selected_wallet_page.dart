import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_modal_flutter/constants/constants.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';
import 'package:walletconnect_modal_flutter/services/explorer/explorer_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/core/core_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_message.dart';
import 'package:walletconnect_modal_flutter/services/utils/toast/toast_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/url/url_utils_singleton.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/widgets/qr_code_widget.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_icon_button.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar_title.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_provider.dart';
import 'package:walletconnect_modal_flutter/constants/string_constants.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/services/utils/logger/logger_util.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_button.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class SelectedWallet extends StatelessWidget {
  final WalletData walletData;

  const SelectedWallet({
    Key? key,
    required this.walletData, // Add required parameter for the custom string
  }) : super(key: WalletConnectModalConstants.selectedWalletPageKey);

  @override
  Widget build(BuildContext context) {
    final service = WalletConnectModalProvider.of(context).service;

    return WalletConnectModalNavBar(
      title: const WalletConnectModalNavbarTitle(
        title: 'Connect Your Wallet',
      ),
      child: _buildSection(
          title: 'Let\'s Get Connected! 🔗',
          description: '',
          images: [const SizedBox.shrink()],
          padding: 10,
          context: context),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required List<Widget> images,
    required BuildContext context,
    double padding = 10,
  }) {
    WalletConnectModalThemeData themeData =
        WalletConnectModalTheme.getData(context);
    final service = WalletConnectModalProvider.of(context).service;
    explorerService.instance!.filterList(query: '');
    return Container(
      padding: EdgeInsets.all(padding),
      constraints: const BoxConstraints(
        maxWidth: 600,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: themeData.foreground100,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: themeData.foreground200,
            ),
          ),
          const SizedBox(height: 20),
          WalletConnectModalButton(
            height: 40,
            onPressed: () async {
              try {
                await urlUtils.instance.navigateDeepLink(
                  nativeLink: walletData.listing.mobile.native,
                  universalLink: walletData.listing.mobile.universal,
                  wcURI: service.wcUri!,
                );

                // final Uri? nativeUri = coreUtils.instance.formatNativeUrl(
                //   walletData.listing.mobile.native,
                //   service.wcUri!,
                // );
                // await launchUrl(nativeUri!);
              } catch (e) {
                toastUtils.instance.show(
                  ToastMessage(
                    type: ToastType.info,
                    text: 'Unable to connect to wallet',
                  ),
                );
              }
            },
            padding: const EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Open ${walletData.listing.name}',
                  style: TextStyle(
                    fontFamily: themeData.fontFamily,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  size: 18,
                  Icons.arrow_outward,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
