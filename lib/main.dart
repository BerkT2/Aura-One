import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const AuraApp());
}

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF60A5FA),
          secondary: Color(0xFFA78BFA),
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
          onPrimary: Color(0xFF0F172A),
          onSecondary: Color(0xFF0F172A),
          onSurface: Color(0xFFF8FAFC),
          onBackground: Color(0xFFF8FAFC),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF60A5FA),
          secondary: Color(0xFFA78BFA),
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
          onPrimary: Color(0xFF0F172A),
          onSecondary: Color(0xFF0F172A),
          onSurface: Color(0xFFF8FAFC),
          onBackground: Color(0xFFF8FAFC),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late List<AnimationController> _iconControllers;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _iconControllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    _iconControllers[0].forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    for (var controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;
    
    _iconControllers[_currentIndex].reverse();
    _iconControllers[index].forward();
    
    setState(() {
      _currentIndex = index;
    });
    
    _scaleController.forward(from: 0);
    _slideController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: _buildModernNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildModernNavBar() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: const Color(0xFF60A5FA).withOpacity(0.25),
            blurRadius: 50,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1E293B).withOpacity(0.9),
                  const Color(0xFF0F172A).withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                width: 1,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOutCubic,
                  left: _getIndicatorPosition(),
                  top: 8,
                  bottom: 8,
                  child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF60A5FA),
                          Color(0xFFA78BFA),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF60A5FA).withOpacity(0.6),
                          blurRadius: 25,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      index: 0,
                    ),
                    _buildNavItem(
                      icon: Icons.explore_rounded,
                      label: 'Explore',
                      index: 1,
                    ),
                    _buildNavItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      index: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getIndicatorPosition() {
    final screenWidth = MediaQuery.of(context).size.width;
    final navBarWidth = screenWidth - 48;
    final itemWidth = navBarWidth / 3;
    return (_currentIndex * itemWidth) + (itemWidth / 2) - 45;
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.only(top: 12),
          child: AnimatedBuilder(
            animation: _iconControllers[index],
            builder: (context, child) {
              final animation = _iconControllers[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 1.0 + (animation.value * 0.12),
                    child: Icon(
                      icon,
                      size: 26,
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      letterSpacing: 0.3,
                      height: 1,
                    ),
                    child: Text(label),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}