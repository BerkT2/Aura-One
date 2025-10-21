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
  ml.LatLng? _currentPosition;
  String? _errorMessage;

  // OpenFreeMap Bright (light, key'siz)
  static const _styleBright = 'https://tiles.openfreemap.org/styles/bright';

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
                    '© OpenStreetMap contributors • OpenFreeMap (OpenMapTiles Bright Style)',
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
      styleString: _styleBright, // sadece Bright stili
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