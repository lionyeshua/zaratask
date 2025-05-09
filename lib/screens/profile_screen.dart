import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zaratask/providers/auth_provider.dart';
import 'package:zaratask/providers/settings_provider.dart';
import 'package:zaratask/core/utils/service_locator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  List<Widget> get _profileTiles => const [
    _EmailTile(),
    _DarkModeTile(),
    _SignOutTile(),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(title: Text('Profile')),
        SliverList.separated(
          itemCount: _profileTiles.length,
          itemBuilder: (context, index) {
            return _profileTiles[index];
          },
          separatorBuilder:
              (context, index) => const Divider(indent: 16, endIndent: 16),
        ),
      ],
    );
  }
}

class _EmailTile extends StatelessWidget {
  const _EmailTile();

  @override
  Widget build(BuildContext context) {
    return Selector<AuthProvider, String>(
      selector: (context, auth) => auth.user.email,
      builder: (context, email, child) {
        if (email.isEmpty) {
          ServiceLocator.logger.w('Email is empty while user authenticated');
        }

        return ListTile(
          leading: const Icon(Icons.email),
          onTap: () => context.push('/profile/update-email', extra: email),
          title: Text(email),
          trailing: const Icon(Icons.arrow_forward),
        );
      },
    );
  }
}

class _DarkModeTile extends StatelessWidget {
  const _DarkModeTile();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context, listen: false);

    return Selector<SettingsProvider, bool>(
      selector: (context, provider) => provider.settings.darkMode,
      builder: (context, darkMode, child) {
        return SwitchListTile(
          onChanged: (value) async {
            await provider.updateDarkMode(value);
          },
          secondary: const Icon(Icons.dark_mode),
          title: Text('Dark Mode'),
          value: darkMode,
        );
      },
    );
  }
}

class _SignOutTile extends StatelessWidget {
  const _SignOutTile();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return ListTile(
      leading: const Icon(Icons.logout),
      onTap: () async => provider.signOut(),
      title: const Text('Sign-out'),
      trailing: const Icon(Icons.arrow_forward),
    );
  }
}
