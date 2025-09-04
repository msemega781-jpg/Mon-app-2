import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/current_session_metrics_widget.dart';
import './widgets/device_performance_widget.dart';
import './widgets/network_status_widget.dart';
import './widgets/optimization_recommendations_widget.dart';
import './widgets/system_health_header_widget.dart';

class PerformanceDashboard extends StatefulWidget {
  const PerformanceDashboard({super.key});

  @override
  State<PerformanceDashboard> createState() => _PerformanceDashboardState();
}

class _PerformanceDashboardState extends State<PerformanceDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isAdvancedMode = false;

  final List<Map<String, dynamic>> navigationRoutes = [
    {
      "title": "Connexion",
      "route": "/login-screen",
      "icon": "login",
    },
    {
      "title": "Bibliothèque",
      "route": "/game-library",
      "icon": "library_books",
    },
    {
      "title": "Contrôles Tactiles",
      "route": "/touch-controls-editor",
      "icon": "touch_app",
    },
    {
      "title": "Streaming PC",
      "route": "/pc-streaming-setup",
      "icon": "cast",
    },
    {
      "title": "Paramètres Manette",
      "route": "/controller-settings",
      "icon": "gamepad",
    },
  ];

  final List<Map<String, dynamic>> advancedMetrics = [
    {
      "label": "Processeur ARM",
      "value": "Snapdragon 8 Gen 2",
      "details": "8 cœurs @ 3.2 GHz",
      "usage": "52%",
      "color": AppTheme.accentColor,
    },
    {
      "label": "Moteur Émulation",
      "value": "Wine/Proton",
      "details": "Version 8.0.1",
      "usage": "Actif",
      "color": AppTheme.successColor,
    },
    {
      "label": "Consommation",
      "value": "12.4W",
      "details": "Batterie: 3h 15m",
      "usage": "Modérée",
      "color": AppTheme.warningColor,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.backgroundPrimary,
      appBar: _buildAppBar(),
      drawer: _buildNavigationDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMainDashboard(),
                  _buildAdvancedMetrics(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryDark,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: CustomIconWidget(
          iconName: 'menu',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'dashboard',
            color: AppTheme.accentColor,
            size: 24,
          ),
          SizedBox(width: 2.w),
          Text(
            'Performance',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            _showPerformanceReport();
          },
          icon: CustomIconWidget(
            iconName: 'file_download',
            color: AppTheme.textPrimary,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _isAdvancedMode = !_isAdvancedMode;
            });
          },
          icon: CustomIconWidget(
            iconName: _isAdvancedMode ? 'visibility_off' : 'visibility',
            color: AppTheme.accentColor,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: AppTheme.primaryDark,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'dashboard',
                  color: _tabController.index == 0
                      ? AppTheme.primaryDark
                      : AppTheme.textSecondary,
                  size: 18,
                ),
                SizedBox(width: 1.w),
                Text('Vue Générale'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'settings',
                  color: _tabController.index == 1
                      ? AppTheme.primaryDark
                      : AppTheme.textSecondary,
                  size: 18,
                ),
                SizedBox(width: 1.w),
                Text('Avancé'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainDashboard() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SystemHealthHeaderWidget(),
          const CurrentSessionMetricsWidget(),
          const DevicePerformanceWidget(),
          const NetworkStatusWidget(),
          const OptimizationRecommendationsWidget(),
          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildAdvancedMetrics() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.borderColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.accentColor,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Métriques Avancées',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: advancedMetrics.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final metric = advancedMetrics[index];
                    return _buildAdvancedMetricCard(
                      metric['label'] as String,
                      metric['value'] as String,
                      metric['details'] as String,
                      metric['usage'] as String,
                      metric['color'] as Color,
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.borderColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'analytics',
                      color: AppTheme.warningColor,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Profils de Performance',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                _buildPerformanceProfile(
                    'Gaming Intensif',
                    'CPU: Max, GPU: Max, RAM: Optimisé',
                    AppTheme.errorColor,
                    true),
                SizedBox(height: 2.h),
                _buildPerformanceProfile(
                    'Équilibré',
                    'Performance et autonomie optimisées',
                    AppTheme.accentColor,
                    false),
                SizedBox(height: 2.h),
                _buildPerformanceProfile('Économie Batterie',
                    'Autonomie maximale', AppTheme.successColor, false),
              ],
            ),
          ),
          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildAdvancedMetricCard(
      String label, String value, String details, String usage, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'memory',
              color: color,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  details,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              usage,
              style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceProfile(
      String name, String description, Color color, bool isActive) {
    return GestureDetector(
      onTap: () {
        _activatePerformanceProfile(name);
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color:
              isActive ? color.withValues(alpha: 0.1) : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isActive ? color : AppTheme.borderColor.withValues(alpha: 0.3),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: isActive ? 'check_circle' : 'radio_button_unchecked',
                color: color,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: isActive ? color : AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isActive)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ACTIF',
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationDrawer() {
    return Drawer(
      backgroundColor: AppTheme.surfaceColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentColor.withValues(alpha: 0.2),
                    AppTheme.successColor.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconWidget(
                    iconName: 'sports_esports',
                    color: AppTheme.accentColor,
                    size: 32,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'GameStream Mobile',
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Plateforme de Gaming Avancée',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                itemCount: navigationRoutes.length,
                itemBuilder: (context, index) {
                  final route = navigationRoutes[index];
                  final isCurrentRoute =
                      ModalRoute.of(context)?.settings.name == route['route'];

                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    child: ListTile(
                      leading: CustomIconWidget(
                        iconName: route['icon'] as String,
                        color: isCurrentRoute
                            ? AppTheme.accentColor
                            : AppTheme.textSecondary,
                        size: 24,
                      ),
                      title: Text(
                        route['title'] as String,
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: isCurrentRoute
                              ? AppTheme.accentColor
                              : AppTheme.textPrimary,
                          fontWeight: isCurrentRoute
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      selected: isCurrentRoute,
                      selectedTileColor:
                          AppTheme.accentColor.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        if (!isCurrentRoute) {
                          Navigator.pushNamed(
                              context, route['route'] as String);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Divider(color: AppTheme.borderColor.withValues(alpha: 0.3)),
                  SizedBox(height: 2.h),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                    title: Text(
                      'Paramètres',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to settings
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showQuickActionsBottomSheet();
      },
      backgroundColor: AppTheme.accentColor,
      foregroundColor: AppTheme.primaryDark,
      icon: CustomIconWidget(
        iconName: 'tune',
        color: AppTheme.primaryDark,
        size: 20,
      ),
      label: Text(
        'Actions Rapides',
        style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
          color: AppTheme.primaryDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showQuickActionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Actions Rapides',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionButton(
                      'Mode Gaming',
                      'sports_esports',
                      AppTheme.accentColor,
                      () => _activateGamingMode(),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildQuickActionButton(
                      'Nettoyage',
                      'cleaning_services',
                      AppTheme.warningColor,
                      () => _performCleanup(),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildQuickActionButton(
                      'Refroidir',
                      'ac_unit',
                      AppTheme.successColor,
                      () => _activateCooling(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton(
      String title, String iconName, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 28,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showPerformanceReport() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'file_download',
                color: AppTheme.accentColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Rapport de Performance',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Générer un rapport détaillé des performances pour le dépannage et le partage communautaire avec des données anonymisées.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Annuler',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _generatePerformanceReport();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.primaryDark,
              ),
              child: Text('Générer'),
            ),
          ],
        );
      },
    );
  }

  void _activateGamingMode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mode Gaming activé - Performance maximale'),
        backgroundColor: AppTheme.accentColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _performCleanup() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nettoyage terminé - 1.2 GB de RAM libérée'),
        backgroundColor: AppTheme.warningColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _activateCooling() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mode refroidissement activé'),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _activatePerformanceProfile(String profileName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profil "$profileName" activé'),
        backgroundColor: AppTheme.accentColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _generatePerformanceReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rapport de performance généré et sauvegardé'),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
