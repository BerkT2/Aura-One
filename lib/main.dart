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
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              width: 1.5,
              color: Colors.white.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 20),
              ),
              BoxShadow(
                color: const Color(0xFF60A5FA).withOpacity(0.2),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                left: _getIndicatorPosition(),
                top: 12,
                child: Container(
                  width: 100,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF60A5FA).withOpacity(0.8),
                        const Color(0xFFA78BFA).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF60A5FA).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
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
    );
  }

  double _getIndicatorPosition() {
    final screenWidth = MediaQuery.of(context).size.width;
    final navBarWidth = screenWidth - 48;
    final itemWidth = navBarWidth / 3;
    return (_currentIndex * itemWidth) + (itemWidth / 2) - 50;
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: AnimatedBuilder(
            animation: _iconControllers[index],
            builder: (context, child) {
              final animation = _iconControllers[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: 1.0 + (animation.value * 0.15),
                    child: Icon(
                      icon,
                      size: 28,
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: GoogleFonts.inter(
                      fontSize: isSelected ? 13 : 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      letterSpacing: 0.5,
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