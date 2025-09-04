import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/button_mapping_widget.dart';
import './widgets/connected_device_card.dart';
import './widgets/controller_profile_widget.dart';
import './widgets/sensitivity_settings_widget.dart';

class ControllerSettings extends StatefulWidget {
  const ControllerSettings({Key? key}) : super(key: key);

  @override
  State<ControllerSettings> createState() => _ControllerSettingsState();
}

class _ControllerSettingsState extends State<ControllerSettings>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for connected controllers
  final List<Map<String, dynamic>> _connectedDevices = [
    {
      'id': '1',
      'name': 'Xbox Wireless Controller',
      'model': 'Model 1914',
      'batteryLevel': 85,
      'connectionType': 'Bluetooth',
      'signalStrength': 92,
      'isConnected': true,
    },
    {
      'id': '2',
      'name': 'DualSense Controller',
      'model': 'CFI-ZCT1W',
      'batteryLevel': 45,
      'connectionType': 'USB',
      'signalStrength': 100,
      'isConnected': true,
    },
    {
      'id': '3',
      'name': 'Pro Controller',
      'model': 'HAC-013',
      'batteryLevel': 12,
      'connectionType': 'Bluetooth',
      'signalStrength': 67,
      'isConnected': false,
    },
  ];

  // Mock button mapping data
  Map<String, dynamic> _buttonMapping = {
    'a': 'Saut',
    'b': 'Accroupir',
    'x': 'Recharger',
    'y': 'Changer Arme',
    'lb': 'Viser',
    'rb': 'Tir',
    'lt': 'Grenade',
    'rt': 'Tir',
    'dpad_up': 'Menu',
    'dpad_down': 'Carte',
    'dpad_left': 'Inventaire',
    'dpad_right': 'Interaction',
    'left_stick': 'Courir',
    'right_stick': 'Corps à corps',
  };

  // Mock sensitivity settings
  Map<String, double> _sensitivitySettings = {
    'left_deadzone': 0.15,
    'right_deadzone': 0.12,
    'left_trigger': 0.6,
    'right_trigger': 0.7,
    'vibration': 0.8,
    'gyroscope': 1.2,
  };

  // Mock controller profiles
  List<Map<String, dynamic>> _controllerProfiles = [
    {
      'id': '1',
      'name': 'Profil FPS Compétitif',
      'gameType': 'FPS',
      'createdAt': '2024-01-15T10:30:00Z',
    },
    {
      'id': '2',
      'name': 'Course Arcade',
      'gameType': 'Racing',
      'createdAt': '2024-01-20T14:45:00Z',
    },
    {
      'id': '3',
      'name': 'RPG Aventure',
      'gameType': 'RPG',
      'createdAt': '2024-02-01T09:15:00Z',
    },
  ];

  String? _activeProfileId = '1';
  bool _autoSwitchProfiles = true;
  bool _hapticFeedbackEnabled = true;
  bool _gyroscopeEnabled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildConnectionStatus(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildConnectedDevicesTab(),
                _buildButtonMappingTab(),
                _buildSensitivityTab(),
                _buildAdvancedOptionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryDark,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.textPrimary,
          size: 6.w,
        ),
      ),
      title: Text(
        'Paramètres Contrôleur',
        style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showTroubleshootingDialog,
          icon: CustomIconWidget(
            iconName: 'help_outline',
            color: AppTheme.accentColor,
            size: 6.w,
          ),
        ),
        IconButton(
          onPressed: _showControllerPairingWizard,
          icon: CustomIconWidget(
            iconName: 'add',
            color: AppTheme.accentColor,
            size: 6.w,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    final connectedCount = _connectedDevices
        .where((device) => device['isConnected'] == true)
        .length;
    final primaryController = _connectedDevices.firstWhere(
      (device) => device['isConnected'] == true,
      orElse: () => <String, dynamic>{},
    );

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              connectedCount > 0 ? AppTheme.successColor : AppTheme.errorColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: (connectedCount > 0
                      ? AppTheme.successColor
                      : AppTheme.errorColor)
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: connectedCount > 0 ? 'gamepad' : 'gamepad_off',
              color: connectedCount > 0
                  ? AppTheme.successColor
                  : AppTheme.errorColor,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  connectedCount > 0
                      ? '$connectedCount Contrôleur(s) Connecté(s)'
                      : 'Aucun Contrôleur Connecté',
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (primaryController.isNotEmpty) ...[
                  Text(
                    '${primaryController['name']} - ${primaryController['batteryLevel']}%',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ] else ...[
                  Text(
                    'Appuyez sur + pour ajouter un contrôleur',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (connectedCount > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'signal_cellular_alt',
                    color: AppTheme.successColor,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${primaryController['signalStrength'] ?? 0}%',
                    style: AppTheme.dataTextTheme().labelMedium?.copyWith(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicator: BoxDecoration(
          color: AppTheme.accentColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: AppTheme.accentColor,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'devices',
                  color: _tabController.index == 0
                      ? AppTheme.accentColor
                      : AppTheme.textSecondary,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text('Appareils'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'gamepad',
                  color: _tabController.index == 1
                      ? AppTheme.accentColor
                      : AppTheme.textSecondary,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text('Boutons'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'tune',
                  color: _tabController.index == 2
                      ? AppTheme.accentColor
                      : AppTheme.textSecondary,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text('Sensibilité'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'settings',
                  color: _tabController.index == 3
                      ? AppTheme.accentColor
                      : AppTheme.textSecondary,
                  size: 4.w,
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

  Widget _buildConnectedDevicesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contrôleurs Connectés',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ..._connectedDevices.map((device) => ConnectedDeviceCard(
                device: device,
                onDisconnect: () => _disconnectDevice(device['id']),
              )),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showControllerPairingWizard,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.primaryDark,
                size: 5.w,
              ),
              label: Text('Ajouter un Contrôleur'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonMappingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: ButtonMappingWidget(
        mappingData: _buttonMapping,
        onMappingChanged: (newMapping) {
          setState(() {
            _buttonMapping = newMapping;
          });
        },
      ),
    );
  }

  Widget _buildSensitivityTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: SensitivitySettingsWidget(
        sensitivityValues: _sensitivitySettings,
        onSensitivityChanged: (newSettings) {
          setState(() {
            _sensitivitySettings = newSettings;
          });
        },
      ),
    );
  }

  Widget _buildAdvancedOptionsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ControllerProfileWidget(
            profiles: _controllerProfiles,
            activeProfileId: _activeProfileId,
            onProfileSelected: (profileId) {
              setState(() {
                _activeProfileId = profileId;
              });
            },
            onProfileCreated: (profile) {
              setState(() {
                _controllerProfiles.add(profile);
              });
            },
            onProfileDeleted: (profileId) {
              setState(() {
                _controllerProfiles.removeWhere((p) => p['id'] == profileId);
                if (_activeProfileId == profileId) {
                  _activeProfileId = _controllerProfiles.isNotEmpty
                      ? _controllerProfiles.first['id']
                      : null;
                }
              });
            },
          ),
          SizedBox(height: 2.h),
          _buildAdvancedSettings(),
          SizedBox(height: 2.h),
          _buildCalibrationSection(),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'settings_applications',
                color: AppTheme.accentColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Options Avancées',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildSettingTile(
            'Changement Automatique de Profil',
            'Active automatiquement le profil selon le jeu',
            _autoSwitchProfiles,
            (value) => setState(() => _autoSwitchProfiles = value),
            'auto_mode',
          ),
          _buildSettingTile(
            'Retour Haptique',
            'Vibrations et retour tactile du contrôleur',
            _hapticFeedbackEnabled,
            (value) => setState(() => _hapticFeedbackEnabled = value),
            'vibration',
          ),
          _buildSettingTile(
            'Contrôle Gyroscopique',
            'Utilise les mouvements du téléphone comme contrôle',
            _gyroscopeEnabled,
            (value) => setState(() => _gyroscopeEnabled = value),
            'screen_rotation',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    String iconName,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: value ? AppTheme.accentColor : AppTheme.textSecondary,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildCalibrationSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'precision_manufacturing',
                color: AppTheme.warningColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Calibration',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Calibrez vos contrôleurs pour une précision optimale dans vos jeux.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _startStickCalibration,
                  icon: CustomIconWidget(
                    iconName: 'gamepad',
                    color: AppTheme.accentColor,
                    size: 4.w,
                  ),
                  label: Text('Calibrer Sticks'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _startTriggerCalibration,
                  icon: CustomIconWidget(
                    iconName: 'speed',
                    color: AppTheme.warningColor,
                    size: 4.w,
                  ),
                  label: Text('Calibrer Gâchettes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _disconnectDevice(String deviceId) {
    setState(() {
      final deviceIndex =
          _connectedDevices.indexWhere((device) => device['id'] == deviceId);
      if (deviceIndex != -1) {
        _connectedDevices[deviceIndex]['isConnected'] = false;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contrôleur déconnecté'),
        backgroundColor: AppTheme.warningColor,
      ),
    );
  }

  void _showControllerPairingWizard() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        title: Text(
          'Ajouter un Contrôleur',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instructions de couplage:',
              style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              '• Xbox: Maintenez le bouton Xbox + bouton de couplage\n• PlayStation: Maintenez PS + Share pendant 3 secondes\n• Switch Pro: Maintenez le bouton de synchronisation',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startControllerScan();
            },
            child: Text('Rechercher'),
          ),
        ],
      ),
    );
  }

  void _showTroubleshootingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        title: Text(
          'Dépannage',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Problèmes courants:',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                '• Contrôleur non détecté: Vérifiez le Bluetooth\n• Latence élevée: Rapprochez-vous de l\'appareil\n• Boutons non réactifs: Recalibrez le contrôleur\n• Batterie faible: Rechargez ou changez les piles',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _startControllerScan() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Recherche de contrôleurs en cours...'),
        backgroundColor: AppTheme.accentColor,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _startStickCalibration() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        title: Text(
          'Calibration des Sticks',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Suivez les instructions à l\'écran pour calibrer vos sticks analogiques.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calibration des sticks terminée'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: Text('Commencer'),
          ),
        ],
      ),
    );
  }

  void _startTriggerCalibration() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        title: Text(
          'Calibration des Gâchettes',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Appuyez complètement sur chaque gâchette puis relâchez pour calibrer.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calibration des gâchettes terminée'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: Text('Commencer'),
          ),
        ],
      ),
    );
  }
}
