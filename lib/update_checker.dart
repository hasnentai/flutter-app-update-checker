import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';

const String githubApiUrl =
    'https://api.github.com/repos/hasnentai/portfolio/releases/latest'; // <- replace this

Future<void> checkForUpdate(BuildContext context) async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    final response = await http.get(
      Uri.parse(githubApiUrl),
      headers: {
        HttpHeaders.acceptHeader: 'application/vnd.github+json',
      },
    );

    if (response.statusCode != 200) return;

    final data = jsonDecode(response.body);
    final latestVersion = data['tag_name'].replaceFirst('v', '');
    final releaseNotes = data['body'] ?? '';

    if (latestVersion == currentVersion) return;

    final asset = data['assets'].firstWhere(
      (a) => a['name'].toString().endsWith('.exe'),
      orElse: () => null,
    );

    if (asset == null) return;

    final downloadUrl = asset['browser_download_url'];

    showUpdateDialog(context, latestVersion, downloadUrl, releaseNotes);
  } catch (e) {
    print("Update check failed: $e");
  }
}

void showUpdateDialog(
    BuildContext context, String newVersion, String url, String notes) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Update Available"),
      content: Text("Version $newVersion is available!\n\n$notes"),
      actions: [
        TextButton(
          child: Text("Later"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text("Update Now"),
          onPressed: () {
            Navigator.pop(context);
            downloadAndInstallUpdate(url);
          },
        ),
      ],
    ),
  );
}

Future<void> downloadAndInstallUpdate(String url) async {
  try {
    final tempDir = await getApplicationSupportDirectory();
    final filePath = '${tempDir.path}/update_installer.exe';

    final request = await HttpClient().getUrl(Uri.parse(url));
    final response = await request.close();

    if (response.statusCode != 200) {
      print('Failed to download update');
      return;
    }

    final file = File(filePath);
    final sink = file.openWrite();

    await response.forEach(sink.add);
    await sink.close();

    // Launch the installer silently
    await Process.start(filePath, ['/SILENT']);
    exit(0);
  } catch (e) {
    print('Error downloading update: $e');
  }
}
