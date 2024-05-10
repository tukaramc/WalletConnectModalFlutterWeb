import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/constants/constants.dart';
import 'package:walletconnect_modal_flutter/models/listings.dart';
import 'package:walletconnect_modal_flutter/pages/wallet_list_long_page.dart';
import 'package:walletconnect_modal_flutter/services/explorer/explorer_service_singleton.dart';
import 'package:walletconnect_modal_flutter/services/utils/widget_stack/widget_stack_singleton.dart';
import 'package:walletconnect_modal_flutter/services/walletconnect_modal/i_walletconnect_modal_service.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list.dart';
import 'package:walletconnect_modal_flutter/widgets/grid_list/grid_list_wallet_item.dart';
import 'package:walletconnect_modal_flutter/widgets/qr_code_widget.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_navbar_title.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_provider.dart';

class QRCodeAndWalletListPage extends StatelessWidget {
  const QRCodeAndWalletListPage()
      : super(key: WalletConnectModalConstants.qrCodeAndWalletListPageKey);

  @override
  Widget build(BuildContext context) {
    final IWalletConnectModalService service =
        WalletConnectModalProvider.of(context).service;

    return WalletConnectModalNavBar(
      title: const WalletConnectModalNavbarTitle(
        title: 'Connect your wallet',
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height > 555
                ? MediaQuery.of(context).size.height * 0.6
                : null,
            child: QRCodeWidget(
              service: service,
              logoPath: 'assets/walletconnect_logo_white.png',
            ),
          ),
          GridList(
            state: GridListState.extraShort,
            provider: explorerService.instance!,
            viewLongList: () {
              widgetStack.instance.add(
                const WalletListLongPage(),
              );
            },
            onSelect: (WalletData data) {
              service.connectWallet(
                walletData: data,
              );
            },
            createListItem: (info, iconSize) {
              return GridListWalletItem(
                listItem: info,
                imageSize: iconSize,
              );
            },
          ),
        ],
      ),
    );
  }
}
