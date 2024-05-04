import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_dapp/models/chain_metadata.dart';
import 'package:walletconnect_flutter_dapp/pages/wcm_page.dart';
import 'package:walletconnect_flutter_dapp/utils/crypto/chain_data.dart';
import 'package:walletconnect_flutter_dapp/utils/crypto/helpers.dart';
import 'package:walletconnect_flutter_dapp/utils/dart_defines.dart';
import 'package:walletconnect_flutter_dapp/utils/string_constants.dart';
import 'package:walletconnect_flutter_dapp/widgets/event_widget.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.swapTheme,
  });

  final void Function() swapTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  IWeb3App? _web3App;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    initialize();
  }

  Future<void> initialize() async {
    _web3App = Web3App(
      core: Core(
        projectId: 'DartDefines.projectId',
      ),
      metadata: const PairingMetadata(
        name: 'Flutter Dapp Example',
        description: 'Flutter Dapp Example',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );

    _web3App!.onSessionPing.subscribe(_onSessionPing);
    _web3App!.onSessionEvent.subscribe(_onSessionEvent);

    await _web3App!.init();

    // Loop through all the chain data
    for (final ChainMetadata chain in ChainData.chains) {
      // Loop through the events for that chain
      for (final event in getChainEvents(chain.type)) {
        _web3App!.registerEventHandler(
          chainId: chain.namespace,
          event: event,
          handler: null,
        );
      }
    }

    setState(() {
      _initialized = true;
    });
  }

  @override
  void dispose() {
    _web3App!.onSessionPing.unsubscribe(_onSessionPing);
    _web3App!.onSessionEvent.unsubscribe(_onSessionEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Center(
        child: CircularProgressIndicator(
          color: WalletConnectModalTheme.getData(context).primary100,
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // WCMPage(web3App: _web3App!),
          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              children: [
                _buildIconButton(
                  Icons.theater_comedy_outlined,
                  widget.swapTheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, void Function()? onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(
          48,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        iconSize: 24,
        onPressed: onPressed,
      ),
    );
  }

  void _onSessionPing(SessionPing? args) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EventWidget(
          title: StringConstants.receivedPing,
          content: 'Topic: ${args!.topic}',
        );
      },
    );
  }

  void _onSessionEvent(SessionEvent? args) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EventWidget(
          title: StringConstants.receivedEvent,
          content:
              'Topic: ${args!.topic}\nEvent Name: ${args.name}\nEvent Data: ${args.data}',
        );
      },
    );
  }
}
