import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AuthenticationPairingWidget extends StatefulWidget {
  final Function(String) onPairingComplete;
  final VoidCallback onRetry;

  const AuthenticationPairingWidget({
    Key? key,
    required this.onPairingComplete,
    required this.onRetry,
  }) : super(key: key);

  @override
  State<AuthenticationPairingWidget> createState() =>
      _AuthenticationPairingWidgetState();
}

class _AuthenticationPairingWidgetState
    extends State<AuthenticationPairingWidget> with TickerProviderStateMixin {
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;

  final List<TextEditingController> _pinControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _pinFocusNodes =
      List.generate(6, (index) => FocusNode());

  bool _isPairing = false;
  bool _showPinInput = false;
  String _generatedPin = '';
  String _connectionStatus = 'waiting';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pulseAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
          parent: _pulseAnimationController, curve: Curves.easeInOut),
    );
    _startPairingProcess();
  }

  void _startPairingProcess() {
    _pulseAnimationController.repeat(reverse: true);

    // Simulate pairing initiation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _generatedPin = '847293';
          _showPinInput = true;
          _connectionStatus = 'pin_generated';
        });
      }
    });
  }

  void _onPinChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _pinFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _pinFocusNodes[index - 1].requestFocus();
    }

    // Check if all pins are filled
    final enteredPin =
        _pinControllers.map((controller) => controller.text).join();
    if (enteredPin.length == 6) {
      _validatePin(enteredPin);
    }
  }

  void _validatePin(String enteredPin) {
    setState(() {
      _isPairing = true;
      _errorMessage = null;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (enteredPin == _generatedPin) {
          setState(() {
            _connectionStatus = 'success';
            _isPairing = false;
          });
          _pulseAnimationController.stop();
          widget.onPairingComplete('PC-Gaming-Bureau');
        } else {
          setState(() {
            _connectionStatus = 'error';
            _isPairing = false;
            _errorMessage = 'Code PIN incorrect. Vérifiez sur votre PC.';
          });
          _clearPinInputs();
        }
      }
    });
  }

  void _clearPinInputs() {
    for (final controller in _pinControllers) {
      controller.clear();
    }
    _pinFocusNodes[0].requestFocus();
  }

  void _copyPin() {
    Clipboard.setData(ClipboardData(text: _generatedPin));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code PIN copié'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _pulseAnimationController.dispose();
    for (final controller in _pinControllers) {
      controller.dispose();
    }
    for (final focusNode in _pinFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: 4.h),
        _buildPairingStatus(),
        SizedBox(height: 4.h),
        if (_showPinInput) ...[
          _buildPinSection(),
          SizedBox(height: 3.h),
        ],
        _buildTroubleshootingSection(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appairage Sécurisé',
          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Établissement d\'une connexion sécurisée avec votre PC',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPairingStatus() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          _buildStatusIcon(),
          SizedBox(height: 3.h),
          _buildStatusText(),
          if (_connectionStatus == 'pin_generated') ...[
            SizedBox(height: 3.h),
            _buildGeneratedPin(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    Widget icon;
    Color color;

    switch (_connectionStatus) {
      case 'waiting':
        icon = AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: CustomIconWidget(
                iconName: 'wifi_find',
                color: AppTheme.accentColor,
                size: 48,
              ),
            );
          },
        );
        color = AppTheme.accentColor;
        break;
      case 'pin_generated':
        icon = CustomIconWidget(
          iconName: 'security',
          color: AppTheme.warningColor,
          size: 48,
        );
        color = AppTheme.warningColor;
        break;
      case 'success':
        icon = CustomIconWidget(
          iconName: 'check_circle',
          color: AppTheme.successColor,
          size: 48,
        );
        color = AppTheme.successColor;
        break;
      case 'error':
        icon = CustomIconWidget(
          iconName: 'error',
          color: AppTheme.errorColor,
          size: 48,
        );
        color = AppTheme.errorColor;
        break;
      default:
        icon = CustomIconWidget(
          iconName: 'help',
          color: AppTheme.textSecondary,
          size: 48,
        );
        color = AppTheme.textSecondary;
    }

    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(child: icon),
    );
  }

  Widget _buildStatusText() {
    String title;
    String description;

    switch (_connectionStatus) {
      case 'waiting':
        title = 'Recherche en cours...';
        description = 'Connexion au PC en cours d\'établissement';
        break;
      case 'pin_generated':
        title = 'Code PIN généré';
        description = 'Saisissez le code affiché sur votre PC';
        break;
      case 'success':
        title = 'Appairage réussi !';
        description = 'Connexion sécurisée établie avec succès';
        break;
      case 'error':
        title = 'Échec de l\'appairage';
        description = _errorMessage ?? 'Une erreur est survenue';
        break;
      default:
        title = 'État inconnu';
        description = 'Veuillez réessayer';
    }

    return Column(
      children: [
        Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Text(
          description,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGeneratedPin() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'PIN sur votre PC: ',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            _generatedPin,
            style: AppTheme.dataTextTheme().headlineMedium?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: _copyPin,
            child: CustomIconWidget(
              iconName: 'content_copy',
              color: AppTheme.accentColor,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinSection() {
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
            'Saisissez le Code PIN',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildPinInputFields(),
          if (_errorMessage != null) ...[
            SizedBox(height: 2.h),
            _buildErrorMessage(),
          ],
          if (_isPairing) ...[
            SizedBox(height: 2.h),
            _buildPairingProgress(),
          ],
        ],
      ),
    );
  }

  Widget _buildPinInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: AppTheme.primaryDark,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _pinFocusNodes[index].hasFocus
                  ? AppTheme.accentColor
                  : AppTheme.borderColor,
              width: _pinFocusNodes[index].hasFocus ? 2 : 1,
            ),
          ),
          child: TextFormField(
            controller: _pinControllers[index],
            focusNode: _pinFocusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            style: AppTheme.dataTextTheme().headlineSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => _onPinChanged(index, value),
          ),
        );
      }),
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

  Widget _buildPairingProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 4.w,
          height: 4.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          'Vérification en cours...',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTroubleshootingSection() {
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
                iconName: 'help_outline',
                color: AppTheme.warningColor,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Problèmes de Connexion ?',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.warningColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildTroubleshootingTip(
              'Vérifiez que GameStream est ouvert sur votre PC'),
          _buildTroubleshootingTip(
              'Le code PIN s\'affiche dans la fenêtre GameStream'),
          _buildTroubleshootingTip(
              'Assurez-vous d\'être sur le même réseau Wi-Fi'),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _connectionStatus = 'waiting';
                  _showPinInput = false;
                  _errorMessage = null;
                });
                _clearPinInputs();
                _startPairingProcess();
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                side: BorderSide(color: AppTheme.warningColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Réessayer l\'Appairage',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.warningColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingTip(String tip) {
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
