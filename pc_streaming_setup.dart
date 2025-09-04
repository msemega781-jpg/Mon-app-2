import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/authentication_pairing_widget.dart';
import './widgets/client_installation_widget.dart';
import './widgets/manual_connection_widget.dart';
import './widgets/pc_discovery_widget.dart';
import './widgets/setup_success_widget.dart';
import './widgets/streaming_test_widget.dart';

class PcStreamingSetup extends StatefulWidget {
  const PcStreamingSetup({Key? key}) : super(key: key);

  @override
  State<PcStreamingSetup> createState() => _PcStreamingSetupState();
}

class _PcStreamingSetupState extends State<PcStreamingSetup>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  int _currentStep = 0;
  bool _showManualConnection = false;
  String _selectedPcName = '';
  bool _canSkip = true;

  final List<Map<String, dynamic>> _setupSteps = [
    {
      'title': 'Découverte PC',
      'subtitle': 'Recherche de votre PC gaming',
      'icon': 'search',
    },
    {
      'title': 'Installation Client',
      'subtitle': 'Configuration du logiciel PC',
      'icon': 'download',
    },
    {
      'title': 'Appairage',
      'subtitle': 'Connexion sécurisée',
      'icon': 'security',
    },
    {
      'title': 'Test Streaming',
      'subtitle': 'Vérification de la qualité',
      'icon': 'speed',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _progressAnimationController, curve: Curves.easeInOut),
    );
    _progressAnimationController.forward();
  }

  void _nextStep() {
    if (_currentStep < _setupSteps.length - 1) {
      setState(() {
        _currentStep++;
        _showManualConnection = false;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _progressAnimationController.reset();
      _progressAnimationController.forward();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _showManualConnection = false;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipSetup() {
    Navigator.pushReplacementNamed(context, '/game-library');
  }

  void _onPcSelected(Map<String, dynamic> pc) {
    setState(() {
      _selectedPcName = pc['name'] as String;
    });
    _nextStep();
  }

  void _onManualConnect() {
    setState(() {
      _showManualConnection = true;
    });
  }

  void _onManualConnectionBack() {
    setState(() {
      _showManualConnection = false;
    });
  }

  void _onManualConnectionSuccess(String connectionString) {
    setState(() {
      _selectedPcName = connectionString.split(':')[0];
      _showManualConnection = false;
    });
    _nextStep();
  }

  void _onInstallationComplete() {
    _nextStep();
  }

  void _onPairingComplete(String pcName) {
    setState(() {
      _selectedPcName = pcName;
    });
    _nextStep();
  }

  void _onTestComplete() {
    // Navigate to success screen
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _buildSuccessScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _onStartStreaming() {
    Navigator.pushReplacementNamed(context, '/game-library');
  }

  void _onBackToLibrary() {
    Navigator.pushReplacementNamed(context, '/game-library');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressIndicator(),
            Expanded(
              child: _buildStepContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap:
                _currentStep > 0 ? _previousStep : () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryDark,
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
                  'Configuration PC Streaming',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Étape ${_currentStep + 1} sur ${_setupSteps.length}',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (_canSkip && _currentStep < _setupSteps.length - 1)
            GestureDetector(
              onTap: _skipSetup,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Text(
                  'Ignorer',
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Row(
            children: List.generate(_setupSteps.length, (index) {
              final isCompleted = index < _currentStep;
              final isCurrent = index == _currentStep;
              final step = _setupSteps[index];

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppTheme.successColor
                                  : isCurrent
                                      ? AppTheme.accentColor
                                      : AppTheme.surfaceColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isCompleted
                                    ? AppTheme.successColor
                                    : isCurrent
                                        ? AppTheme.accentColor
                                        : AppTheme.borderColor,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: isCompleted
                                  ? CustomIconWidget(
                                      iconName: 'check',
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : CustomIconWidget(
                                      iconName: step['icon'],
                                      color: isCurrent
                                          ? Colors.white
                                          : AppTheme.textSecondary,
                                      size: 16,
                                    ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            step['title'],
                            style: AppTheme.darkTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: isCurrent
                                  ? AppTheme.textPrimary
                                  : AppTheme.textSecondary,
                              fontWeight:
                                  isCurrent ? FontWeight.w600 : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    if (index < _setupSteps.length - 1)
                      Container(
                        width: 8.w,
                        height: 2,
                        margin: EdgeInsets.only(bottom: 6.h),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppTheme.successColor
                              : AppTheme.borderColor,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 2.h),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: (_currentStep + _progressAnimation.value) /
                    _setupSteps.length,
                backgroundColor: AppTheme.borderColor,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                minHeight: 1.h,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildDiscoveryStep(),
        _buildInstallationStep(),
        _buildPairingStep(),
        _buildTestingStep(),
      ],
    );
  }

  Widget _buildDiscoveryStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: _showManualConnection
          ? ManualConnectionWidget(
              onConnect: _onManualConnectionSuccess,
              onBack: _onManualConnectionBack,
            )
          : PcDiscoveryWidget(
              onPcSelected: _onPcSelected,
              onManualConnect: _onManualConnect,
            ),
    );
  }

  Widget _buildInstallationStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: ClientInstallationWidget(
        onInstallationComplete: _onInstallationComplete,
        onSkip: _onInstallationComplete,
      ),
    );
  }

  Widget _buildPairingStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: AuthenticationPairingWidget(
        onPairingComplete: _onPairingComplete,
        onRetry: () {
          // Retry pairing logic
        },
      ),
    );
  }

  Widget _buildTestingStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: StreamingTestWidget(
        onTestComplete: _onTestComplete,
        onRetry: () {
          // Retry testing logic
        },
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: SetupSuccessWidget(
            connectedPcName: _selectedPcName.isNotEmpty
                ? _selectedPcName
                : 'PC-Gaming-Bureau',
            onStartStreaming: _onStartStreaming,
            onBackToLibrary: _onBackToLibrary,
          ),
        ),
      ),
    );
  }
}
