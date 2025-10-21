import 'package:aura/screens/maps_screen.dart';
import 'package:aura/screens/movies_screen.dart';
import 'package:aura/screens/other_screen.dart';
import 'package:aura/screens/products_screen.dart';
import 'package:aura/screens/recipes_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(viewportFraction: 0.85);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Aura',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: const Icon(Icons.person_outline),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildUrlSection(context, pageController),
          const SizedBox(height: 24),
          _buildQuickActions(context),
          const SizedBox(height: 24),
          _buildRecentActivity(context),
        ],
      ),
    );
  }

  Widget _buildUrlSection(
      BuildContext context, PageController pageController) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView(
            controller: pageController,
            children: [
              _buildUrlCard(context),
              _buildInfoCard(context),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: pageController,
          count: 2,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Theme.of(context).colorScheme.primary,
            dotColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildUrlCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analyze Content from URL',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter URL...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text('Analyze'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            const Spacer(),
            Text(
              'What can Aura do?',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Aura can analyze articles, videos, and more to give you instant insights.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionIcon(context, Icons.map_outlined, 'Maps', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MapsScreen()))),
              _buildActionIcon(context, Icons.restaurant_menu, 'Recipes', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RecipesScreen()))),
              _buildActionIcon(context, Icons.shopping_bag_outlined, 'Products', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsScreen()))),
              _buildActionIcon(context, Icons.movie_outlined, 'Movies', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MoviesScreen()))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildActivityItem(context, Icons.article_outlined, 'Article Analyzed', 'on TechCrunch'),
          const Divider(height: 32),
          _buildActivityItem(context, Icons.videocam_outlined, 'Video Analyzed', 'from YouTube'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      BuildContext context, IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
          ],
        ),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    );
  }
}