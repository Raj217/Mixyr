import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mixyr/packages/settings_ui/settings_ui.dart';
import 'package:mixyr/state_handlers/proxy/proxy_handler.dart';
import 'package:mixyr/state_handlers/storage/storage_handler.dart';
import 'package:mixyr/widgets/buttons/expanded_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SettingsList(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpandedButton(
                  icon: Icons.close,
                  onTap: () {
                    Navigator.pop(context);
                  })
            ],
          ),
          sections: [
            SettingsSection(
                name: 'Network',
                tiles: [
                  SettingsTile(
                    icon: CupertinoIcons.globe,
                    title: 'Proxy',
                    showToggleButton: true,
                    initialToggleValue: StorageHandler().isProxyEnabled,
                    onToggleButtonChange: (val) async {
                      await (StorageHandler().isProxyEnabled = val);
                      if (val) {
                        await ProxyHandler.setUpProxy(
                            host: '172.16.199.40', port: '8080');
                      } else {
                        ProxyHandler.removeProxy();
                      }
                    },
                  ),
                ],
                gap: 10),
          ],
          gap: 10,
        ),
      ),
    );
  }
}
