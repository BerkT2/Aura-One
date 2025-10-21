import 'dart:ui';
import 'dart:math' as math;
import 'package:aura/screens/maps_screen.dart';
import 'package:aura/screens/movies_screen.dart';
import 'package:aura/screens/products_screen.dart';
import 'package:aura/screens/recipes_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
                _buildHeroCard(),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
                _buildQuickStats(),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
                _buildSectionTitle('Quick Access'),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                _buildCategoryGrid(),
                const SliverToBoxAdapter(child: SizedBox(height: 140)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -100 + (_floatController.value * 50),
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF60A5FA).withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100 - (_floatController.value * 30),
              left: -100,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFA78BFA).withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  SliverToBoxAdapter _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (math.sin(_pulseController.value * 2 * math.pi) * 0.05),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF60A5FA), Color(0xFFA78BFA)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF60A5FA).withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF60A5FA), Color(0xFFA78BFA)],
                      ).createShader(bounds),
                      child: Text(
                        'Aura',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeroCard() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF60A5FA),
                    const Color(0xFFA78BFA),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF60A5FA).withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Transform.rotate(
                      angle: _shimmerController.value * 2 * math.pi,
                      child: Icon(
                        Icons.auto_awesome,
                        size: 100,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.analytics_outlined, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'AI Analysis',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Unlock powerful insights with AI',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _urlController,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter URL to analyze...',
                            hintStyle: GoogleFonts.inter(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: const Icon(Icons.link_rounded, color: Color(0xFF60A5FA)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_urlController.text.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Analyzing: ${_urlController.text}'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF1E293B),
                                  margin: const EdgeInsets.only(bottom: 120, left: 16, right: 16),
                                ),
                              );
                              _urlController.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF60A5FA),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.rocket_launch_rounded, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Start Analysis',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildQuickStats() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(child: _buildStatCard('127', 'Analyses', Icons.insights_rounded, const Color(0xFF60A5FA))),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('4.8', 'Rating', Icons.star_rounded, const Color(0xFFFCD34D))),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('23', 'Saved', Icons.bookmark_rounded, const Color(0xFFA78BFA))),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  SliverPadding _buildCategoryGrid() {
    final categories = [
      {'icon': Icons.map_rounded, 'title': 'Maps', 'color': const Color(0xFF60A5FA), 'screen': const MapsScreen()},
      {'icon': Icons.restaurant_rounded, 'title': 'Recipes', 'color': const Color(0xFFF97316), 'screen': const RecipesScreen()},
      {'icon': Icons.shopping_bag_rounded, 'title': 'Products', 'color': const Color(0xFFA78BFA), 'screen': const ProductsScreen()},
      {'icon': Icons.movie_rounded, 'title': 'Movies', 'color': const Color(0xFFEF4444), 'screen': const MoviesScreen()},
      {'icon': Icons.explore_rounded, 'title': 'Explore', 'color': const Color(0xFF14B8A6), 'screen': null},
      {'icon': Icons.favorite_rounded, 'title': 'Favorites', 'color': const Color(0xFFEC4899), 'screen': null},
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final category = categories[index];
            return _buildCategoryCard(
              context,
              category['icon'] as IconData,
              category['title'] as String,
              category['color'] as Color,
              category['screen'] as Widget?,
            );
          },
          childCount: categories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, IconData icon, String title, Color color, Widget? screen) {
    return GestureDetector(
      onTap: () {
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title coming soon!'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF1E293B),
              margin: const EdgeInsets.only(bottom: 120, left: 16, right: 16),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: Icon(
                icon,
                size: 80,
                color: color.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}