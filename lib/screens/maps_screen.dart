import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the new package

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  LatLng? _currentPosition;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage =
              'Location permissions are permanently denied, we cannot request permissions.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong: ${e.toString()}';
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      // You could show an error snackbar here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics:
              const NeverScrollableScrollPhysics(), // Disable scrolling on the background
          slivers: [
            SliverAppBar(
              title: const Text(
                'Maps',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              floating: true,
            ),
            SliverFillRemaining(
              child: _buildMap(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // --- Start of Changes ---

    // 1. Check for dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 2. Set the tile URL based on the theme
    final tileUrl = isDarkMode
        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
        : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';

    return FlutterMap(
      options: MapOptions(
        initialCenter: _currentPosition!,
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: tileUrl,
          // 3. Add subdomains for CartoDB
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName:
              'com.example.aura', // Replace with your app's package name
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _currentPosition!,
              width: 80,
              height: 80,
              child: Icon(
                Icons.location_on,
                size: 40.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        // 4. Add attribution for the map providers
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              '© OpenStreetMap contributors',
              onTap: () =>
                  _launchUrl('https://openstreetmap.org/copyright'),
            ),
            TextSourceAttribution(
              '© CARTO',
              onTap: () => _launchUrl('https://carto.com/attributions'),
            ),
          ],
        ),
        // --- End of Changes ---
      ],
    );
  }
}