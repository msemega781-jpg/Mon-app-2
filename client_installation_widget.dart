import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ClientInstallationWidget extends StatefulWidget {
  final VoidCallback onInstallationComplete;
  final VoidCallback onSkip;

  const ClientInstallationWidget({
    Key? key,
    required this.onInstallationComplete,
    required this.onSkip,
  }) : super(key: key);

  @override
  State<ClientInstallationWidget> createState() =>
      _ClientInstallationWidgetState();
}

class _ClientInstallationWidgetState extends State<ClientInstallationWidget>
    with TickerProviderStateMixin {
  late AnimationController _qrAnimationController;
  late Animation<double> _qrAnimation;
  bool _isGeneratingQr = true;
  bool _showInstructions = false;

  final String _downloadUrl = 'https://gamestream.app/download/pc-client';
  final String _qrData =
      'https://gamestream.app/download/pc-client?mobile=true&version=2.1.4';

  @override
  void initState() {
    super.initState();
    _qrAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _qrAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _qrAnimationController, curve: Curves.easeInOut),
    );
    _generateQrCode();
  }

  void _generateQrCode() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isGeneratingQr = false;
        });
        _qrAnimationController.forward();
      }
    });
  }

  void _copyDownloadLink() {
    Clipboard.setData(ClipboardData(text: _downloadUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lien copié dans le presse-papiers'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _qrAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: 4.h),
        _buildQrCodeSection(),
        SizedBox(height: 3.h),
        _buildAlternativeDownload(),
        SizedBox(height: 3.h),
        _buildInstructionsSection(),
        SizedBox(height: 4.h),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Installation du Client PC',
          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Installez le client GameStream sur votre PC pour activer le streaming',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQrCodeSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Text(
            'Scannez avec votre PC',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildQrCode(),
          SizedBox(height: 3.h),
          Text(
            'Ouvrez l\'appareil photo de votre PC ou utilisez un lecteur QR',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQrCode() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: _isGeneratingQr
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 8.w,
                    height: 8.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Génération...',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ],
              ),
            )
          : AnimatedBuilder(
              animation: _qrAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _qrAnimation.value,
                  child: _buildQrPattern(),
                );
              },
            ),
    );
  }

  Widget _buildQrPattern() {
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: Column(
        children: [
          // QR Code pattern simulation
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 0.5.w,
                mainAxisSpacing: 0.5.w,
              ),
              itemCount: 64,
              itemBuilder: (context, index) {
                // Simple pattern to simulate QR code
                final bool isBlack = (index + (index ~/ 8)) % 3 == 0 ||
                    index < 8 ||
                    index >= 56 ||
                    index % 8 == 0 ||
                    index % 8 == 7;
                return Container(
                  decoration: BoxDecoration(
                    color: isBlack ? AppTheme.primaryDark : Colors.transparent,
                    borderRadius: BorderRadius.circular(1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeDownload() {
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
                iconName: 'download',
                color: AppTheme.accentColor,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Téléchargement Direct',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _downloadUrl,
                    style: AppTheme.dataTextTheme().bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ),
                GestureDetector(
                  onTap: _copyDownloadLink,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustomIconWidget(
                      iconName: 'content_copy',
                      color: AppTheme.accentColor,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showInstructions = !_showInstructions;
            });
          },
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'help_outline',
                  color: AppTheme.accentColor,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Instructions d\'Installation',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: _showInstructions ? 'expand_less' : 'expand_more',
                  color: AppTheme.textSecondary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (_showInstructions) ...[
          SizedBox(height: 2.h),
          _buildInstructionsList(),
        ],
      ],
    );
  }

  Widget _buildInstructionsList() {
    final instructions = [
      {
        'step': '1',
        'title': 'Téléchargement',
        'description':
            'Téléchargez et exécutez le fichier d\'installation GameStream-Setup.exe',
      },
      {
        'step': '2',
        'title': 'Installation',
        'description':
            'Suivez l\'assistant d\'installation et acceptez les permissions administrateur',
      },
      {
        'step': '3',
        'title': 'Configuration',
        'description':
            'Lancez GameStream et autorisez l\'accès réseau dans le pare-feu Windows',
      },
      {
        'step': '4',
        'title': 'Activation',
        'description':
            'Le service démarrera automatiquement et sera prêt pour la connexion mobile',
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: instructions.map((instruction) {
          return Padding(
            padding: EdgeInsets.only(bottom: 3.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      instruction['step']!,
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        instruction['title']!,
                        style:
                            AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        instruction['description']!,
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
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onSkip,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              side: BorderSide(color: AppTheme.textSecondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Ignorer',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: widget.onInstallationComplete,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: AppTheme.primaryDark,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Client Installé',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
