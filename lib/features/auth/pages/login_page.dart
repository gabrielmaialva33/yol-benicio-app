import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:yolapp/features/auth/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.login(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (!success) {
        setState(() {
          _errorMessage = 'E-mail ou senha inválidos';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2A37),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800;
          return Stack(
            children: [
              // Decorative circles for desktop
              if (isDesktop) ...[
                Positioned(
                  top: -150,
                  left: -150,
                  child: _buildDecorativeCircle(),
                ),
                Positioned(
                  bottom: -200,
                  left: -100,
                  child: _buildDecorativeCircle(),
                ),
              ],
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child:
                      isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDecorativeCircle() {
    return Container(
      width: 550,
      height: 550,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFF6680E).withOpacity(0.5),
          width: 15,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.8),
            blurRadius: 95,
            spreadRadius: 13,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Center(
              // This space can be used for a larger branding image on desktop
              // For now, we keep it empty as the logo is inside the form card.
              ),
        ),
        const SizedBox(width: 60),
        Expanded(
          child: _buildLoginForm(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return _buildLoginForm();
  }

  Widget _buildLoginForm() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 490),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/logo.svg',
              height: 90,
            ),
            const SizedBox(height: 35),
            Text(
              'Fazer login',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF161C24),
                height: 0.6,
              ),
            ),
            const SizedBox(height: 35),
            TextFormField(
              controller: _emailController,
              decoration: _buildInputDecoration('E-mail'),
              style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B)),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'E-mail é obrigatório';
                }
                if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
                  return 'E-mail inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: _buildInputDecoration('Senha'),
              style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B)),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Senha é obrigatória';
                }
                return null;
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Esqueci minha senha',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Color(0xFF64748B),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111827),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Entrar',
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 35),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  color: Color(0xFFA1A5B7),
                ),
                children: [
                  TextSpan(text: 'Não tem uma conta? '),
                  TextSpan(
                    text: 'Solicite',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(
        fontFamily: 'Montserrat',
        color: Color(0xFF64748B),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFE1E3EA)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFE1E3EA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF1F2A37), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
