import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ControllerProfileWidget extends StatefulWidget {
  final List<Map<String, dynamic>> profiles;
  final String? activeProfileId;
  final Function(String) onProfileSelected;
  final Function(Map<String, dynamic>) onProfileCreated;
  final Function(String) onProfileDeleted;

  const ControllerProfileWidget({
    Key? key,
    required this.profiles,
    this.activeProfileId,
    required this.onProfileSelected,
    required this.onProfileCreated,
    required this.onProfileDeleted,
  }) : super(key: key);

  @override
  State<ControllerProfileWidget> createState() =>
      _ControllerProfileWidgetState();
}

class _ControllerProfileWidgetState extends State<ControllerProfileWidget> {
  bool _isCreatingProfile = false;
  final TextEditingController _profileNameController = TextEditingController();
  String _selectedGameType = 'FPS';

  final List<Map<String, dynamic>> _gameTypes = [
    {'id': 'FPS', 'name': 'Jeux de Tir (FPS)', 'icon': 'gps_fixed'},
    {'id': 'Racing', 'name': 'Course', 'icon': 'directions_car'},
    {'id': 'RPG', 'name': 'Jeu de Rôle (RPG)', 'icon': 'person'},
    {'id': 'Sports', 'name': 'Sports', 'icon': 'sports_soccer'},
    {'id': 'Fighting', 'name': 'Combat', 'icon': 'sports_martial_arts'},
    {'id': 'Strategy', 'name': 'Stratégie', 'icon': 'psychology'},
    {'id': 'Custom', 'name': 'Personnalisé', 'icon': 'settings'},
  ];

  @override
  void dispose() {
    _profileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                iconName: 'account_circle',
                color: AppTheme.accentColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Profils de Contrôleur',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isCreatingProfile = !_isCreatingProfile;
                  });
                },
                icon: CustomIconWidget(
                  iconName: _isCreatingProfile ? 'close' : 'add',
                  color: AppTheme.accentColor,
                  size: 6.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (_isCreatingProfile) _buildCreateProfileForm(),
          if (!_isCreatingProfile) ...[
            _buildActiveProfile(),
            SizedBox(height: 2.h),
            _buildProfilesList(),
          ],
        ],
      ),
    );
  }

  Widget _buildCreateProfileForm() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Créer un Nouveau Profil',
            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _profileNameController,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'Nom du Profil',
              hintText: 'Ex: Mon Profil FPS',
              prefixIcon: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Type de Jeu',
            style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _gameTypes.map((gameType) {
              final isSelected = _selectedGameType == gameType['id'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGameType = gameType['id'];
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accentColor.withValues(alpha: 0.2)
                        : AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.accentColor
                          : AppTheme.borderColor,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: gameType['icon'],
                        color: isSelected
                            ? AppTheme.accentColor
                            : AppTheme.textSecondary,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        gameType['name'],
                        style:
                            AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.accentColor
                              : AppTheme.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isCreatingProfile = false;
                      _profileNameController.clear();
                      _selectedGameType = 'FPS';
                    });
                  },
                  child: Text('Annuler'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _createProfile,
                  child: Text('Créer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveProfile() {
    final activeProfile = widget.profiles.firstWhere(
      (profile) => profile['id'] == widget.activeProfileId,
      orElse: () => {'name': 'Aucun profil actif', 'gameType': 'Custom'},
    );

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.accentColor,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil Actif',
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  activeProfile['name'] as String? ?? 'Profil par défaut',
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _getGameTypeName(
                      activeProfile['gameType'] as String? ?? 'Custom'),
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profils Disponibles',
          style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...widget.profiles.map((profile) => _buildProfileCard(profile)),
      ],
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile) {
    final isActive = profile['id'] == widget.activeProfileId;
    final gameTypeData = _gameTypes.firstWhere(
      (type) => type['id'] == profile['gameType'],
      orElse: () => _gameTypes.last,
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.accentColor.withValues(alpha: 0.1)
            : AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppTheme.accentColor : AppTheme.borderColor,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: gameTypeData['icon'],
            color: isActive ? AppTheme.accentColor : AppTheme.textSecondary,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile['name'] as String? ?? 'Profil sans nom',
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  gameTypeData['name'],
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (!isActive) ...[
            IconButton(
              onPressed: () => widget.onProfileSelected(profile['id']),
              icon: CustomIconWidget(
                iconName: 'play_arrow',
                color: AppTheme.successColor,
                size: 5.w,
              ),
            ),
            IconButton(
              onPressed: () => _confirmDeleteProfile(profile['id']),
              icon: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.errorColor,
                size: 5.w,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getGameTypeName(String gameTypeId) {
    final gameType = _gameTypes.firstWhere(
      (type) => type['id'] == gameTypeId,
      orElse: () => _gameTypes.last,
    );
    return gameType['name'];
  }

  void _createProfile() {
    if (_profileNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer un nom pour le profil'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final newProfile = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _profileNameController.text.trim(),
      'gameType': _selectedGameType,
      'createdAt': DateTime.now().toIso8601String(),
    };

    widget.onProfileCreated(newProfile);

    setState(() {
      _isCreatingProfile = false;
      _profileNameController.clear();
      _selectedGameType = 'FPS';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profil "${newProfile['name']}" créé avec succès'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _confirmDeleteProfile(String profileId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        title: Text(
          'Supprimer le Profil',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer ce profil ? Cette action est irréversible.',
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
              widget.onProfileDeleted(profileId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profil supprimé'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
