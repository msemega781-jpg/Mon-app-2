import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/app_logo_section.dart';
import './widgets/custom_text_field.dart';
import './widgets/gaming_background.dart';
import './widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _showEmailError = false;
  bool _showPasswordError = false;
  String? _emailErrorText;
  String? _passwordErrorText;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'gamer@gamestream.fr': 'GamePass123!',
    'pro.player@gamestream.fr': 'ProGamer456!',
    'admin@gamestream.fr': 'AdminStream789!',
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre email ou nom d\'utilisateur';
    }
    if (value.contains('@') &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Format d\'email invalide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre mot de passe';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  void _validateFields() {
    setState(() {
      _emailErrorText = _validateEmail(_emailController.text);
      _passwordErrorText = _validatePassword(_passwordController.text);
      _showEmailError = _emailErrorText != null;
      _showPasswordError = _passwordErrorText != null;
    });
  }

  Future<void> _handleLogin() async {
    _validateFields();

    if (_showEmailError || _showPasswordError) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_mockCredentials.containsKey(email) &&
        _mockCredentials[email] == password) {
      // Success - trigger gaming haptic feedback
      HapticFeedback.mediumImpact();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/game-library');
      }
    } else {
      // Authentication failed
      HapticFeedback.lightImpact();

      setState(() {
        _showEmailError = true;
        _showPasswordError = true;
        _emailErrorText = 'Identifiants incorrects';
        _passwordErrorText = 'Vérifiez vos informations de connexion';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _handleSocialLogin(String platform) async {
    HapticFeedback.lightImpact();

    // Simulate social login
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/game-library');
    }
  }

  void _handleForgotPassword() {
    HapticFeedback.selectionClick();
    // Navigate to password recovery (not implemented in this scope)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Fonctionnalité de récupération de mot de passe à venir',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSignUp() {
    HapticFeedback.selectionClick();
    // Navigate to registration (not implemented in this scope)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Inscription à venir - Utilisez les identifiants de test',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: GamingBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 8.h),

                    // App Logo Section
                    const AppLogoSection(),

                    SizedBox(height: 6.h),

                    // Login Form
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: AppTheme.borderColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.shadowColor,
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Text
                          Text(
                            'Connexion',
                            style: AppTheme.darkTheme.textTheme.headlineSmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Connectez-vous pour accéder à vos jeux',
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          // Email/Username Field
                          CustomTextField(
                            label: 'Email ou nom d\'utilisateur',
                            hintText: 'gamer@gamestream.fr',
                            iconName: 'person',
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            validator: _validateEmail,
                            showError: _showEmailError,
                            errorText: _emailErrorText,
                          ),

                          SizedBox(height: 3.h),

                          // Password Field
                          CustomTextField(
                            label: 'Mot de passe',
                            hintText: 'Votre mot de passe',
                            iconName: 'lock',
                            isPassword: true,
                            controller: _passwordController,
                            validator: _validatePassword,
                            showError: _showPasswordError,
                            errorText: _passwordErrorText,
                          ),

                          SizedBox(height: 2.h),

                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _handleForgotPassword,
                              child: Text(
                                'Mot de passe oublié ?',
                                style: AppTheme.darkTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 2.h),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 6.h,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                foregroundColor: AppTheme.primaryDark,
                                elevation: 2,
                                shadowColor:
                                    AppTheme.accentColor.withValues(alpha: 0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: _isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              AppTheme.primaryDark,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Text(
                                          'Connexion...',
                                          style: AppTheme
                                              .darkTheme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: AppTheme.primaryDark,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'Se connecter',
                                      style: AppTheme
                                          .darkTheme.textTheme.labelLarge
                                          ?.copyWith(
                                        color: AppTheme.primaryDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Social Login Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: AppTheme.borderColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Divider with text
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AppTheme.dividerColor,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Text(
                                  'Ou continuer avec',
                                  style: AppTheme.darkTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: AppTheme.dividerColor,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 3.h),

                          // Social Login Buttons
                          SocialLoginButton(
                            iconName: 'g_translate',
                            label: 'Continuer avec Google',
                            onPressed: () => _handleSocialLogin('google'),
                          ),

                          SocialLoginButton(
                            iconName: 'apple',
                            label: 'Continuer avec Apple',
                            onPressed: () => _handleSocialLogin('apple'),
                          ),

                          SocialLoginButton(
                            iconName: 'discord',
                            label: 'Continuer avec Discord',
                            onPressed: () => _handleSocialLogin('discord'),
                            backgroundColor: const Color(0xFF5865F2),
                            textColor: Colors.white,
                          ),

                          SocialLoginButton(
                            iconName: 'sports_esports',
                            label: 'Continuer avec Steam',
                            onPressed: () => _handleSocialLogin('steam'),
                            backgroundColor: const Color(0xFF1B2838),
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nouveau joueur ? ',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: _handleSignUp,
                          child: Text(
                            'S\'inscrire',
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
