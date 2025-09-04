import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PcDiscoveryWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onPcSelected;
  final VoidCallback onManualConnect;

  const PcDiscoveryWidget({
    Key? key,
    required this.onPcSelected,
    required this.onManualConnect,
  }) : super(key: key);

  @override
  State<PcDiscoveryWidget> createState() => _PcDiscoveryWidgetState();
}

class _PcDiscoveryWidgetState extends State<PcDiscoveryWidget>
    with TickerProviderStateMixin {
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;
  bool _isScanning = true;

  final List<Map<String, dynamic>> _discoveredPcs = [
    {
      "id": "pc_001",
      "name": "PC-Gaming-Bureau",
      "ip": "192.168.1.105",
      "signal": 95,
      "status": "available",
      "specs": "RTX 4080 • 32GB RAM",
      "lastSeen": "Maintenant"
    },
    {
      "id": "pc_002",
      "name": "DESKTOP-SALON",
      "ip": "192.168.1.112",
      "signal": 78,
      "status": "available",
      "specs": "GTX 1080 Ti • 16GB RAM",
      "lastSeen": "Il y a 2 min"
    },
    {
      "id": "pc_003",
      "name": "PC-PORTABLE-ASUS",
      "ip": "192.168.1.089",
      "signal": 45,
      "status": "busy",
      "specs": "RTX 3060 • 16GB RAM",
      "lastSeen": "Il y a 5 min"
    }
  ];

  @override
  void initState() {
    super.initState();
    _scanAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _scanAnimationController, curve: Curves.easeInOut),
    );
    _startScanning();
  }

  void _startScanning() {
    _scanAnimationController.repeat();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        _scanAnimationController.stop();
      }
    });
  }

  void _refreshScan() {
    setState(() {
      _isScanning = true;
    });
    _startScanning();
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildScanHeader(),
        SizedBox(height: 3.h),
        _buildScanRadar(),
        SizedBox(height: 4.h),
        _buildDiscoveredPcs(),
        SizedBox(height: 3.h),
        _buildManualConnection(),
      ],
    );
  }

  Widget _buildScanHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recherche de PC',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              _isScanning
                  ? 'Scan du réseau local...'
                  : '${_discoveredPcs.length} PC trouvés',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _refreshScan,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: CustomIconWidget(
              iconName: 'refresh',
              color:
                  _isScanning ? AppTheme.accentColor : AppTheme.textSecondary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanRadar() {
    return Container(
      height: 25.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radar circles
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                final scale =
                    0.3 + (index * 0.3) + (_scanAnimation.value * 0.4);
                final opacity =
                    _isScanning ? (1.0 - _scanAnimation.value) * 0.3 : 0.1;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.accentColor.withValues(alpha: opacity),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          // Center device
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: AppTheme.accentColor,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'smartphone',
              color: AppTheme.primaryDark,
              size: 16,
            ),
          ),
          // Scanning line
          if (_isScanning)
            AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _scanAnimation.value * 6.28,
                  child: Container(
                    width: 25.w,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.accentColor.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDiscoveredPcs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PC Disponibles',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _discoveredPcs.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
          itemBuilder: (context, index) {
            final pc = _discoveredPcs[index];
            return _buildPcCard(pc);
          },
        ),
      ],
    );
  }

  Widget _buildPcCard(Map<String, dynamic> pc) {
    final bool isAvailable = pc['status'] == 'available';
    final int signal = pc['signal'] as int;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAvailable
              ? AppTheme.borderColor
              : AppTheme.borderColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isAvailable
                      ? AppTheme.accentColor.withValues(alpha: 0.2)
                      : AppTheme.borderColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'computer',
                  color: isAvailable
                      ? AppTheme.accentColor
                      : AppTheme.textSecondary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pc['name'] as String,
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        color: isAvailable
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      pc['ip'] as String,
                      style: AppTheme.dataTextTheme().bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              _buildSignalIndicator(signal),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pc['specs'] as String,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Vu ${pc['lastSeen']}',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary.withValues(alpha: 0.7),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: isAvailable ? () => widget.onPcSelected(pc) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isAvailable ? AppTheme.accentColor : AppTheme.borderColor,
                  foregroundColor: AppTheme.primaryDark,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isAvailable ? 'Connecter' : 'Occupé',
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignalIndicator(int signal) {
    Color signalColor;
    if (signal >= 80) {
      signalColor = AppTheme.successColor;
    } else if (signal >= 50) {
      signalColor = AppTheme.warningColor;
    } else {
      signalColor = AppTheme.errorColor;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(4, (index) {
          final isActive = signal > (index * 25);
          return Container(
            width: 1.w,
            height: (index + 1) * 1.h,
            margin: EdgeInsets.only(right: 0.5.w),
            decoration: BoxDecoration(
              color: isActive ? signalColor : AppTheme.borderColor,
              borderRadius: BorderRadius.circular(1),
            ),
          );
        }),
        SizedBox(width: 2.w),
        Text(
          '${signal}%',
          style: AppTheme.dataTextTheme().bodySmall?.copyWith(
                color: signalColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildManualConnection() {
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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'settings_input_antenna',
                color: AppTheme.textSecondary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Connexion Manuelle',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Votre PC n\'apparaît pas ? Connectez-vous manuellement avec son adresse IP.',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onManualConnect,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                side: BorderSide(color: AppTheme.accentColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Saisir Adresse IP',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
