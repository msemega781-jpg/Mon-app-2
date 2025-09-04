import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_games_bottom_sheet.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/game_card_widget.dart';
import './widgets/game_context_menu.dart';
import './widgets/search_header_widget.dart';
import './widgets/sort_bottom_sheet.dart';

class GameLibrary extends StatefulWidget {
  const GameLibrary({super.key});

  @override
  State<GameLibrary> createState() => _GameLibraryState();
}

class _GameLibraryState extends State<GameLibrary> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;
  String _currentSort = 'recent';
  List<String> _activeFilters = [];
  List<Map<String, dynamic>> _filteredGames = [];
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _mockGames = [
    {
      "id": 1,
      "title": "Cyberpunk 2077",
      "artwork":
          "https://images.unsplash.com/photo-1542751371-adc38448a05e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "platforms": ["PC", "Émulé"],
      "status": "installe",
      "size": "70.2 GB",
      "lastPlayed": DateTime.now().subtract(const Duration(hours: 2)),
      "installDate": DateTime.now().subtract(const Duration(days: 15)),
      "rating": 4.2,
      "progress": 100,
    },
    {
      "id": 2,
      "title": "Elden Ring",
      "artwork":
          "https://images.unsplash.com/photo-1511512578047-dfb367046420?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "platforms": ["PC"],
      "status": "installation",
      "size": "49.8 GB",
      "lastPlayed": null,
      "installDate": null,
      "rating": 4.8,
      "progress": 67,
    },
    {
      "id": 3,
      "title": "Red Dead Redemption 2",
      "artwork":
          "https://images.unsplash.com/photo-1493711662062-fa541adb3fc8?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "platforms": ["Cloud"],
      "status": "installe",
      "size": "116.4 GB",
      "lastPlayed": DateTime.now().subtract(const Duration(days: 1)),
      "installDate": DateTime.now().subtract(const Duration(days: 30)),
      "rating": 4.6,
      "progress": 100,
    },
    {
      "id": 4,
      "title": "The Witcher 3",
      "artwork":
          "https://images.unsplash.com/photo-1518709268805-4e9042af2176?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "platforms": ["PC", "Cloud"],
      "status": "non_installe",
      "size": "35.7 GB",
      "lastPlayed": null,
      "installDate": null,
      "rating": 4.9,
      "progress": 0,
    },
    {
      "id": 5,
      "title": "Assassin's Creed Valhalla",
      "artwork":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "platforms": ["Émulé"],
      "status": "installe",
      "size": "47.2 GB",
      "lastPlayed": DateTime.now().subtract(const Duration(days: 3)),
      "installDate": DateTime.now().subtract(const Duration(days: 45)),
      "rating": 4.1,
      "progress": 100,
    },
    {
      "id": 6,
      "title": "Call of Duty: Warzone",
      "artwork":
          "https://images.unsplash.com/photo-1552820728-8b83bb6b773f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "platforms": ["PC", "Cloud"],
      "status": "non_installe",
      "size": "89.1 GB",
      "lastPlayed": null,
      "installDate": null,
      "rating": 3.8,
      "progress": 0,
    },
  ];

  final List<Map<String, String>> _filterOptions = [
    {"key": "platform", "label": "Plateforme", "icon": "computer"},
    {"key": "genre", "label": "Genre", "icon": "category"},
    {"key": "status", "label": "Statut", "icon": "download_done"},
    {"key": "recent", "label": "Récents", "icon": "access_time"},
  ];

  @override
  void initState() {
    super.initState();
    _filteredGames = List.from(_mockGames);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterGames();
  }

  void _filterGames() {
    setState(() {
      _filteredGames = _mockGames.where((game) {
        final title = (game['title'] as String? ?? '').toLowerCase();
        final searchQuery = _searchController.text.toLowerCase();

        bool matchesSearch = title.contains(searchQuery);

        // Apply active filters
        bool matchesFilters = true;
        for (String filter in _activeFilters) {
          switch (filter) {
            case 'installe':
              matchesFilters = matchesFilters && (game['status'] == 'installe');
              break;
            case 'pc':
              matchesFilters = matchesFilters &&
                  ((game['platforms'] as List<dynamic>?)?.contains('PC') ??
                      false);
              break;
            case 'cloud':
              matchesFilters = matchesFilters &&
                  ((game['platforms'] as List<dynamic>?)?.contains('Cloud') ??
                      false);
              break;
            case 'emule':
              matchesFilters = matchesFilters &&
                  ((game['platforms'] as List<dynamic>?)?.contains('Émulé') ??
                      false);
              break;
          }
        }

        return matchesSearch && matchesFilters;
      }).toList();

      _sortGames();
    });
  }

  void _sortGames() {
    switch (_currentSort) {
      case 'recent':
        _filteredGames.sort((a, b) {
          final aTime = a['lastPlayed'] as DateTime?;
          final bTime = b['lastPlayed'] as DateTime?;
          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return bTime.compareTo(aTime);
        });
        break;
      case 'alphabetical':
        _filteredGames.sort((a, b) => (a['title'] as String? ?? '')
            .compareTo(b['title'] as String? ?? ''));
        break;
      case 'install_date':
        _filteredGames.sort((a, b) {
          final aDate = a['installDate'] as DateTime?;
          final bDate = b['installDate'] as DateTime?;
          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return 1;
          if (bDate == null) return -1;
          return bDate.compareTo(aDate);
        });
        break;
      case 'file_size':
        _filteredGames.sort((a, b) {
          final aSize = _parseSizeToBytes(a['size'] as String? ?? '');
          final bSize = _parseSizeToBytes(b['size'] as String? ?? '');
          return bSize.compareTo(aSize);
        });
        break;
      case 'rating':
        _filteredGames.sort((a, b) => (b['rating'] as double? ?? 0.0)
            .compareTo(a['rating'] as double? ?? 0.0));
        break;
    }
  }

  int _parseSizeToBytes(String size) {
    final parts = size.split(' ');
    if (parts.length != 2) return 0;
    final value = double.tryParse(parts[0]) ?? 0.0;
    final unit = parts[1].toUpperCase();

    switch (unit) {
      case 'GB':
        return (value * 1024 * 1024 * 1024).round();
      case 'MB':
        return (value * 1024 * 1024).round();
      case 'KB':
        return (value * 1024).round();
      default:
        return value.round();
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    _filterGames();
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (_activeFilters.contains(filter)) {
        _activeFilters.remove(filter);
      } else {
        _activeFilters.add(filter);
      }
    });
    _filterGames();
  }

  void _showAddGamesBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const AddGamesBottomSheet(),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SortBottomSheet(
        currentSort: _currentSort,
        onSortChanged: (sort) {
          setState(() {
            _currentSort = sort;
          });
          _filterGames();
        },
      ),
    );
  }

  void _showGameContextMenu(Map<String, dynamic> game, Offset position) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          Positioned(
            left: position.dx - 50.w,
            top: position.dy - 10.h,
            child: Material(
              color: Colors.transparent,
              child: GameContextMenu(
                game: game,
                onPlay: () {
                  Navigator.pop(context);
                  // Handle play action
                },
                onInstall: () {
                  Navigator.pop(context);
                  // Handle install action
                },
                onUninstall: () {
                  Navigator.pop(context);
                  // Handle uninstall action
                },
                onGameInfo: () {
                  Navigator.pop(context);
                  // Navigate to game info screen
                },
                onControllerSettings: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/controller-settings');
                },
                onRemove: () {
                  Navigator.pop(context);
                  // Handle remove from library
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            SearchHeaderWidget(
              searchController: _searchController,
              onFilterTap: () {
                // Show filter options
              },
              onViewToggle: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
              onSortTap: _showSortBottomSheet,
              isGridView: _isGridView,
            ),
            if (_activeFilters.isNotEmpty || _filterOptions.isNotEmpty)
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filterOptions.length,
                  separatorBuilder: (context, index) => SizedBox(width: 2.w),
                  itemBuilder: (context, index) {
                    final filter = _filterOptions[index];
                    final isSelected = _activeFilters.contains(filter['key']);

                    return FilterChipWidget(
                      label: filter['label']!,
                      iconName: filter['icon'],
                      isSelected: isSelected,
                      onTap: () => _toggleFilter(filter['key']!),
                    );
                  },
                ),
              ),
            Expanded(
              child: _filteredGames.isEmpty
                  ? EmptyStateWidget(
                      onAddGamesTap: _showAddGamesBottomSheet,
                    )
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: AppTheme.accentColor,
                      backgroundColor: AppTheme.surfaceColor,
                      child: _isGridView ? _buildGridView() : _buildListView(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGamesBottomSheet,
        backgroundColor: AppTheme.accentColor,
        foregroundColor: AppTheme.primaryDark,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.primaryDark,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 3.w,
          childAspectRatio: 0.75,
        ),
        itemCount: _filteredGames.length,
        itemBuilder: (context, index) {
          final game = _filteredGames[index];
          return GameCardWidget(
            game: game,
            isGridView: true,
            onTap: () {
              // Navigate to game detail with hero animation
            },
            onLongPress: () {
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              final position = renderBox.localToGlobal(Offset.zero);
              _showGameContextMenu(game, position);
            },
          );
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      padding: EdgeInsets.all(4.w),
      itemCount: _filteredGames.length,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        final game = _filteredGames[index];
        return GameCardWidget(
          game: game,
          isGridView: false,
          onTap: () {
            // Navigate to game detail
          },
          onLongPress: () {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);
            _showGameContextMenu(game, position);
          },
        );
      },
    );
  }
}
