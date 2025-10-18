import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Privacy Policy
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () => _openPrivacyPolicy(),
          ),

          const SizedBox(height: 8),

          // Terms & Conditions
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            subtitle: 'Read our terms and conditions',
            onTap: () => _openTermsAndConditions(),
          ),

          const SizedBox(height: 8),

          // Share App
          _buildSettingsTile(
            icon: Icons.share_outlined,
            title: 'Share App',
            subtitle: 'Share LockTV with friends',
            onTap: () => _shareApp(),
          ),

          const SizedBox(height: 8),

          // Rate Us
          _buildSettingsTile(
            icon: Icons.star_outline,
            title: 'Rate Us',
            subtitle: 'Rate LockTV on Play Store',
            onTap: () => _rateApp(),
          ),

          const SizedBox(height: 24),

          // App Info
          _buildAppInfo(),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAppInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('App Name', 'LockTV'),
            _buildInfoRow('Version', '1.0.0'),
            _buildInfoRow('Developer', 'LockTV Team'),
            _buildInfoRow('Data Source', 'The Movie Database (TMDB)'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy() {
    // You can replace this with your actual privacy policy URL
    _launchUrl('https://example.com/privacy-policy');
  }

  void _openTermsAndConditions() {
    // You can replace this with your actual terms & conditions URL
    _launchUrl('https://example.com/terms-conditions');
  }

  void _shareApp() {
    Share.share(
      'Check out LockTV - The best app for discovering movies and TV shows! Download it now.',
      subject: 'LockTV - Movie & TV Show Discovery App',
    );
  }

  void _rateApp() {
    // You can replace this with your actual Play Store URL
    _launchUrl('https://play.google.com/store/apps/details?id=com.locktv.app');
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      // Direct launch without canLaunchUrl check to avoid channel errors
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Handle URL launch error gracefully
      print('URL launch error: $e');
    }
  }
}
