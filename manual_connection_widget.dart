import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ManualConnectionWidget extends StatefulWidget {
  final Function(String) onConnect;
  final VoidCallback onBack;

  const ManualConnectionWidget({
    Key? key,
    required this.onConnect,
    required this.onBack,
  }) : super(key: key);

  @override
  State<ManualConnectionWidget> createState() => _ManualConnectionWidgetState();
}

class _ManualConnectionWidgetState extends State<ManualConnectionWidget> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController =
      TextEditingController(text: '7000');
  final FocusNode _ipFocusNode = FocusNode();
  final FocusNode _portFocusNode = FocusNode();
  bool _isConnecting = false;
  String? _errorMessage;

  final List<String> _recentIps = [
    '192.168.1.105',
    '192.168.1.112',
    '192.168.0.100',
    '10.0.0.50',
  ];

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    _ipFocusNode.dispose();
    _portFocusNode.dispose();
    super.dispose();
  }

  void _validateAndConnect() {
    setState(() {
      _errorMessage = null;
    });

    final ip = _ipController.text.trim();
    final port = _portController.text.trim();

    if (ip.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez saisir une adresse IP';
      });
      return;
    }

    if (!_isValidIpAddress(ip)) {
      setState(() {
        _errorMessage = 'Format d\'adresse IP invalide';
      });
      return;
    }

    if (port.isEmpty || int.tryParse(port) == null) {
      setState(() {
        _errorMessage = 'Port invalide';
      });
      return;
    }

    setState(() {
      _isConnecting = true;
    });

    // Simulate connection attempt
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
        widget.onConnect('$ip:$port');
      }
    });
  }

  bool _isValidIpAddress(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) return false;
    }
    return true;
  }

  void _selectRecentIp(String ip) {
    _ipController.text = ip;
    setState(() {
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: 4.h),
        _buildConnectionForm(),
        SizedBox(height: 3.h),
        _buildRecentConnections(),
        SizedBox(height: 4.h),
        _buildTroubleshootingTips(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.onBack,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connexion Manuelle',
                style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Saisissez l\'adresse IP de votre PC',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionForm() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations de Connexion',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildIpAddressField(),
          SizedBox(height: 2.h),
          _buildPortField(),
          if (_errorMessage != null) ...[
            SizedBox(height: 2.h),
            _buildErrorMessage(),
          ],
          SizedBox(height: 3.h),
          _buildConnectButton(),
        ],
      ),
    );
  }

  Widget _buildIpAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adresse IP',
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _ipController,
          focusNode: _ipFocusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          decoration: InputDecoration(
            hintText: '192.168.1.100',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'computer',
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ),
            suffixIcon: _ipController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _ipController.clear();
                      setState(() {
                        _errorMessage = null;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _errorMessage = null;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPortField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Port (optionnel)',
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _portController,
          focusNode: _portFocusNode,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(5),
          ],
          decoration: InputDecoration(
            hintText: '7000',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'settings_ethernet',
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: AppTheme.errorColor,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isConnecting ? null : _validateAndConnect,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: AppTheme.primaryDark,
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isConnecting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.primaryDark),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Connexion...',
                    style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                'Se Connecter',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildRecentConnections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connexions Récentes',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _recentIps.map((ip) {
            return GestureDetector(
              onTap: () => _selectRecentIp(ip),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'history',
                      color: AppTheme.textSecondary,
                      size: 14,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      ip,
                      style: AppTheme.dataTextTheme().bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTroubleshootingTips() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.warningColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'lightbulb_outline',
                color: AppTheme.warningColor,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Conseils de Dépannage',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.warningColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildTip(
              'Assurez-vous que votre PC et téléphone sont sur le même réseau Wi-Fi'),
          _buildTip(
              'Vérifiez que le logiciel GameStream est installé et actif sur votre PC'),
          _buildTip(
              'Désactivez temporairement le pare-feu Windows si nécessaire'),
          _buildTip(
              'L\'adresse IP de votre PC se trouve dans Paramètres > Réseau'),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1.w,
            height: 1.w,
            margin: EdgeInsets.only(top: 1.h, right: 3.w),
            decoration: BoxDecoration(
              color: AppTheme.warningColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
