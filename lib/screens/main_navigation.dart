import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/common.dart';
import '../services/ad_manager.dart';
import '../widgets/WorkingNativeAdWidget.dart';
import 'movies_screen.dart';
import 'tv_shows_screen.dart';
import 'account_screen.dart';
import 'games_screen.dart';
import 'favorites_list_screen.dart';
import 'quiz_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _lastBackPress;

  final List<Widget> _screens = [
    const MoviesScreen(),
    const TVShowsScreen(),
    const QuizScreen(),
    const GamesScreen(),
  ];

  final List<String> _tabLabels = ['Movies', 'TV Shows', 'Quiz', 'Games'];

  final List<IconData> _tabIcons = [
    Icons.movie,
    Icons.tv,
    Icons.quiz,
    Icons.games,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _screens.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _tabController.animateTo(index);
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
      _lastBackPress = now;
      _showExitDialog();
      return false;
    }
    return true;
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (BuildContext context) {
        return _ExitDialog();
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: 'Menu',
        ),
      ),
      title: const Text(
        'LokTV',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              if (Common.adsopen == "2") {
                Common.openUrl();
              }
              AdManager().showInterstitialAd();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesListScreen(
                    type: 'favorites',
                    mediaType: 'all',
                  ),
                ),
              );
            },
            icon: Icon(Icons.playlist_add),
          ),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicatorColor: colorScheme.primary,
        indicatorWeight: 3,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        tabs: List.generate(
          _tabLabels.length,
          (index) => Tab(
            icon: Icon(_tabIcons[index], size: 20),
            text: _tabLabels[index],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF0D1117), const Color(0xFF161B22)],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.movie,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LokTV',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your Entertainment Hub',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 8),
                  _buildDrawerItem(
                    icon: Icons.movie,
                    title: 'Movies',
                    subtitle: 'Browse popular movies',
                    index: 0,
                    colorScheme: colorScheme,
                  ),
                  _buildDrawerItem(
                    icon: Icons.tv,
                    title: 'TV Shows',
                    subtitle: 'Discover TV series',
                    index: 1,
                    colorScheme: colorScheme,
                  ),
                  _buildDrawerItem(
                    icon: Icons.quiz,
                    title: 'Quiz',
                    subtitle: 'Test your knowledge',
                    index: 2,
                    colorScheme: colorScheme,
                  ),
                  _buildDrawerItem(
                    icon: Icons.games,
                    title: 'Games',
                    subtitle: 'Play fun games',
                    index: 3,
                    colorScheme: colorScheme,
                  ),
                  _buildDrawerItem(
                    icon: Icons.person,
                    title: 'Account',
                    subtitle: 'Profile & settings',
                    onTap: () {
                      if (Common.adsopen == "2") {
                        Common.openUrl();
                      }
                      AdManager().showInterstitialAd();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountScreen(),
                        ),
                      );
                    },
                    colorScheme: colorScheme,
                  ),
                  const Divider(height: 32),
                  // Additional Options
                  _buildDrawerItem(
                    icon: Icons.search,
                    title: 'Search',
                    subtitle: 'Find movies & TV shows',
                    onTap: () {
                      if (Common.adsopen == "2") {
                        Common.openUrl();
                      }
                      AdManager().showInterstitialAd();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/search');
                    },
                    colorScheme: colorScheme,
                  ),
                  _buildDrawerItem(
                    icon: Icons.favorite,
                    title: 'Favorites',
                    subtitle: 'Your favorite content',
                    onTap: () {
                      if (Common.adsopen == "2") {
                        Common.openUrl();
                      }
                      AdManager().showInterstitialAd();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesListScreen(
                            type: 'favorites',
                            mediaType: 'all',
                          ),
                        ),
                      );
                    },
                    colorScheme: colorScheme,
                  ),
                  _buildDrawerItem(
                    icon: Icons.bookmark,
                    title: 'Bookmarks',
                    subtitle: 'Saved for later',
                    onTap: () {
                      if (Common.adsopen == "2") {
                        Common.openUrl();
                      }
                      AdManager().showInterstitialAd();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesListScreen(
                            type: 'bookmarks',
                            mediaType: 'all',
                          ),
                        ),
                      );
                    },
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    int? index,
    VoidCallback? onTap,
    required ColorScheme colorScheme,
  }) {
    final isSelected = index != null && _tabController.index == index;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.2)
              : colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.7),
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      selected: isSelected,
      selectedTileColor: colorScheme.primary.withValues(alpha: 0.1),
      onTap:
          onTap ??
          () {
            if (Common.adsopen == "2") {
              Common.openUrl();
            }
            AdManager().showInterstitialAd();
            Navigator.pop(context);
            if (index != null) {
              _onTabTapped(index);
            }
          },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          _onWillPop();
        }
      },
      child: Scaffold(
        drawer: _buildDrawer(),
        appBar: _buildAppBar(),
        body: TabBarView(controller: _tabController, children: _screens),
      ),
    );
  }
}

class _ExitDialog extends StatefulWidget {
  const _ExitDialog();

  @override
  State<_ExitDialog> createState() => _ExitDialogState();
}

class _ExitDialogState extends State<_ExitDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _exitApp() {
    SystemNavigator.pop();
  }

  void _cancel() {
    _controller.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.surface,
                    colorScheme.surface.withValues(alpha: 0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.red.withValues(alpha: 0.2),
                          Colors.orange.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer pulsing circle
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.0),
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        // Icon
                        Icon(Icons.exit_to_app, size: 50, color: Colors.red),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  Text(
                    'Exit LokTV?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Message
                  Text(
                    'Are you sure you want to exit?\nYour favorites and bookmarks are saved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  WorkingNativeAdWidget(),
                  const SizedBox(height: 16),
                  // Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: _AnimatedButton(
                          label: 'Cancel',
                          onPressed: _cancel,
                          isPrimary: false,
                          colorScheme: colorScheme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Exit Button
                      Expanded(
                        child: _AnimatedButton(
                          label: 'Exit',
                          onPressed: _exitApp,
                          isPrimary: true,
                          colorScheme: colorScheme,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final ColorScheme colorScheme;

  const _AnimatedButton({
    required this.label,
    required this.onPressed,
    required this.isPrimary,
    required this.colorScheme,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.05),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: widget.isPrimary
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.red, Colors.red.shade700],
                      )
                    : null,
                color: widget.isPrimary
                    ? null
                    : widget.colorScheme.surface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: widget.isPrimary
                    ? null
                    : Border.all(
                        color: widget.colorScheme.onSurface.withValues(
                          alpha: 0.2,
                        ),
                        width: 1,
                      ),
                boxShadow: widget.isPrimary
                    ? [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.isPrimary
                        ? Colors.white
                        : widget.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
