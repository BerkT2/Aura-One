import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart' as ml; // MapLibre Flutter plugin
import 'package:url_launcher/url_launcher.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  ml.LatLng? _currentPosition; // MapLibre'in LatLng'i
  String? _errorMessage;

  // OpenFreeMap — host edilmiş, key'siz light stiller
  static const _styleBright   = 'https://tiles.openfreemap.org/styles/bright';
  static const _stylePositron = 'https://tiles.openfreemap.org/styles/positron';

  // 0 = Bright, 1 = Positron (varsayılan)
  int _styleIndex = 1;

  ml.MaplibreMapController? _mapController;

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
          setState(() => _errorMessage = 'Location permissions are denied');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _errorMessage =
            'Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = ml.LatLng(pos.latitude, pos.longitude);
      });

      if (_mapController != null && _currentPosition != null) {
        _animateTo(_currentPosition!, zoom: 15.0);
      }
    } catch (e) {
      setState(() => _errorMessage = 'Something went wrong: ${e.toString()}');
    }
  }

  Future<void> _launchUrl(String url) async {
    await launchUrl(Uri.parse(url));
  }

  void _onMapCreated(ml.MaplibreMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      _animateTo(_currentPosition!, zoom: 15.0);
    }
  }

  Future<void> _animateTo(ml.LatLng target, {double zoom = 15}) async {
    await _mapController?.animateCamera(
      ml.CameraUpdate.newLatLngZoom(target, zoom),
    );
  }

  String get _currentStyle =>
      _styleIndex == 0 ? _styleBright : _stylePositron;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: const Text(
                'Maps',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              floating: true,
              actions: [
                PopupMenuButton<int>(
                  tooltip: 'Map Style',
                  icon: const Icon(Icons.layers),
                  initialValue: _styleIndex,
                  onSelected: (i) => setState(() => _styleIndex = i),
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(
                      value: 1,
                      child: _StyleItem(
                        icon: Icons.light_mode,
                        label: 'Positron (Light, Minimal)',
                      ),
                    ),
                    PopupMenuItem(
                      value: 0,
                      child: _StyleItem(
                        icon: Icons.map,
                        label: 'Bright (Light)',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SliverFillRemaining(child: _buildMap()),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'recenter',
            onPressed: () async {
              await _getCurrentLocation();
              if (_currentPosition != null) {
                _animateTo(_currentPosition!, zoom: 15.0);
              }
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'attr',
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => SafeArea(
                child: ListTile(
                  title: const Text('Attribution'),
                  subtitle: const Text(
                    '© OpenStreetMap contributors • OpenFreeMap (OpenMapTiles styles)',
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
            child: const Icon(Icons.info_outline),
          ),
        ],
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

    return ml.MaplibreMap(
      styleString: _currentStyle, // OpenFreeMap stil uçları
      initialCameraPosition: ml.CameraPosition(
        target: _currentPosition!,
        zoom: 15.0,
      ),
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      myLocationTrackingMode: ml.MyLocationTrackingMode.tracking,
      compassEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
    );
  }
}

// AppBar menüsü helper
class _StyleItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StyleItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Flexible(child: Text(label)),
      ],
    );
  }
}