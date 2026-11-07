import 'dart:math' as math;

import 'package:azimut_web/Components/UpBar.dart';
import 'package:azimut_web/Configurations/Configuration.dart';
import 'package:azimut_web/Constants/ColorsApp.dart';
import 'package:azimut_web/Helpers/CookieHelpers.dart';
import 'package:azimut_web/Routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.register = false, this.initialEmail = ''});

  final bool register;
  final String initialEmail;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _password = TextEditingController();
  late final _email = TextEditingController(text: widget.initialEmail);
  final _client = ApiClient();
  bool _showPassword = false;
  bool _remember = false;
  bool _submitting = false;
  String? _error;

  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+$');
  static final _letter = RegExp(r'\p{L}', unicode: true);
  static final _digit = RegExp(r'[0-9]');

  bool get _register => widget.register;

  @override
  void dispose() {
    _client.dio.close(force: true);
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _goHome() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.popUntil((route) => route.isFirst);
    } else {
      navigator.pushReplacementNamed('/');
    }
  }

  void _showInfo(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_submitting || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });

    final email = _email.text.trim();
    try {
      final endpoint = Configuration.localSource
          .getController(_register ? 'register' : 'login')
          .path;
      final response = await _client.dio.post<Object?>(
        endpoint,
        data: {
          'email': email,
          'password': _password.text,
          if (_register) 'firstName': _name.text.trim(),
        },
        options: Options(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );
      if (!mounted) return;

      if (_register) {
        TextInput.finishAutofillContext(shouldSave: true);
        Navigator.of(
          context,
        ).pushReplacementNamed(Routes.login, arguments: email);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Аккаунт создан. Теперь войдите.')),
        );
        return;
      }

      final payload = response.data;
      if (payload case {'token': final String token} when token.isNotEmpty) {
        CookieHelpers.SetToken(token, persistent: _remember);
        TextInput.finishAutofillContext(shouldSave: true);
        _goHome();
      } else {
        setState(() => _error = 'Сервер не вернул данные для входа.');
      }
    } on DioException catch (error) {
      if (mounted) setState(() => _error = _requestError(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _requestError(DioException error) {
    final status = error.response?.statusCode;
    if (!_register && (status == 403 || status == 404)) {
      return 'Проверьте электронную почту и пароль.';
    }
    if (_register && status == 400) {
      return switch (error.response?.data) {
        {'errors': _} => 'Проверьте данные регистрации.',
        _ => 'Аккаунт с этой электронной почтой уже есть.',
      };
    }
    if (status == null)
      return 'Не удалось связаться с сервером. Попробуйте ещё раз.';
    return _register
        ? 'Не удалось создать аккаунт. Попробуйте ещё раз.'
        : 'Не удалось войти. Попробуйте ещё раз.';
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.trim().isEmpty) return 'Введите пароль.';
    if (_register &&
        (password.runes.length < 8 ||
            !_letter.hasMatch(password) ||
            !_digit.hasMatch(password))) {
      return 'Нужно не менее 8 символов, буквы и цифры.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final footerHeight = compact ? 72.0 : 84.0;
    return Scaffold(
      body: Column(
        children: [
          UpBar(onHome: _goHome, brandAsset: 'assets/auth/navigation.svg'),
          Expanded(
            child: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, viewport) => SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: math.max(
                            0,
                            viewport.maxHeight - footerHeight,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: compact ? 16 : 32,
                              vertical: compact ? 24 : 48,
                            ),
                            child: _buildCard(compact),
                          ),
                        ),
                      ),
                      _buildFooter(compact, footerHeight),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(bool compact) => Container(
    constraints: const BoxConstraints(maxWidth: 480),
    padding: EdgeInsets.all(compact ? 24 : 40),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: ColorsApp.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: AutofillGroup(
      onDisposeAction: AutofillContextAction.cancel,
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                _register ? 'Создайте аккаунт' : 'Вход в Azimut',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  letterSpacing: -0.8,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _register
                  ? 'Сохраняйте интересные программы\nи стройте свой план поступления.'
                  : 'Продолжите выбирать программы\nи планировать поступление.',
              style: const TextStyle(
                color: ColorsApp.muted,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            if (_register) ...[
              _field(
                label: 'Имя',
                hint: 'Как к вам обращаться?',
                controller: _name,
                autofill: AutofillHints.givenName,
                maxLength: 100,
                validator: (value) =>
                    value!.trim().isEmpty ? 'Введите имя.' : null,
              ),
              const SizedBox(height: 20),
            ],
            _field(
              label: 'Электронная почта',
              hint: 'Введите электронную почту',
              controller: _email,
              autofill: _register
                  ? AutofillHints.email
                  : AutofillHints.username,
              keyboardType: TextInputType.emailAddress,
              maxLength: 254,
              validator: (value) => _emailPattern.hasMatch(value!.trim())
                  ? null
                  : 'Введите корректную почту.',
            ),
            const SizedBox(height: 20),
            _field(
              label: 'Пароль',
              hint: _register ? 'Придумайте пароль' : 'Введите пароль',
              controller: _password,
              autofill: _register
                  ? AutofillHints.newPassword
                  : AutofillHints.password,
              password: true,
              validator: _validatePassword,
            ),
            if (_register) ...[
              const SizedBox(height: 8),
              const Text(
                'Не менее 8 символов, буквы и цифры',
                style: TextStyle(
                  color: ColorsApp.muted,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              _buildLoginOptions(),
            ],
            if (_error case final error?) ...[
              const SizedBox(height: 12),
              Semantics(
                liveRegion: true,
                child: Text(
                  error,
                  style: const TextStyle(color: ColorsApp.ruby, fontSize: 13),
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(
                _submitting
                    ? (_register ? 'Создаём аккаунт…' : 'Входим…')
                    : (_register ? 'Зарегистрироваться' : 'Войти'),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(height: 1, color: ColorsApp.border),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              children: [
                Text(
                  _register ? 'Уже есть аккаунт?' : 'Нет аккаунта?',
                  style: const TextStyle(color: ColorsApp.muted, fontSize: 13),
                ),
                TextButton(
                  onPressed: _submitting
                      ? null
                      : () => Navigator.of(context).pushReplacementNamed(
                          _register ? Routes.login : Routes.register,
                          arguments: _register ? _email.text.trim() : null,
                        ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 44),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(_register ? 'Войти' : 'Зарегистрироваться'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String autofill,
    required FormFieldValidator<String> validator,
    TextInputType? keyboardType,
    int? maxLength,
    bool password = false,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
      Semantics(
        label: label,
        child: TextFormField(
          enabled: !_submitting,
          controller: controller,
          autofillHints: [autofill],
          keyboardType: keyboardType,
          maxLength: maxLength,
          obscureText: password && !_showPassword,
          autocorrect: false,
          enableSuggestions: !password,
          textInputAction: password
              ? TextInputAction.done
              : TextInputAction.next,
          onFieldSubmitted: password ? (_) => _submit() : null,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: ColorsApp.graphite),
          decoration: InputDecoration(
            constraints: const BoxConstraints(minHeight: 48),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            hintText: hint,
            hintStyle: const TextStyle(color: ColorsApp.muted, fontSize: 14),
            counterText: '',
            errorMaxLines: 2,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: ColorsApp.border),
            ),
            suffixIcon: password
                ? IconButton(
                    tooltip: _showPassword
                        ? 'Скрыть пароль'
                        : 'Показать пароль',
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                    icon: _showPassword
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            size: 18,
                            color: ColorsApp.muted,
                          )
                        : SvgPicture.asset(
                            'assets/auth/eye.svg',
                            excludeFromSemantics: true,
                            colorFilter: const ColorFilter.mode(
                              ColorsApp.muted,
                              BlendMode.srcIn,
                            ),
                          ),
                  )
                : null,
          ),
        ),
      ),
    ],
  );

  Widget _buildLoginOptions() => Wrap(
    alignment: WrapAlignment.spaceBetween,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      InkWell(
        onTap: _submitting
            ? null
            : () => setState(() => _remember = !_remember),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _remember,
              onChanged: _submitting
                  ? null
                  : (value) => setState(() => _remember = value!),
              visualDensity: VisualDensity.compact,
            ),
            const Text(
              'Запомнить меня',
              style: TextStyle(color: ColorsApp.muted, fontSize: 13),
            ),
          ],
        ),
      ),
      TextButton(
        onPressed: () => _showInfo(
          'Забыли пароль?',
          'Восстановление пароля пока недоступно.',
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(fontSize: 13),
        ),
        child: const Text('Забыли пароль?'),
      ),
    ],
  );

  Widget _buildFooter(bool compact, double height) => Container(
    constraints: BoxConstraints(minHeight: height),
    padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 32),
    alignment: Alignment.center,
    child: SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            '© Azimut, ${DateTime.now().year}',
            style: const TextStyle(color: ColorsApp.muted, fontSize: 12),
          ),
          Wrap(
            spacing: compact ? 12 : 24,
            children: [
              TextButton(
                onPressed: _goHome,
                style: _footerLinkStyle,
                child: const Text('На главную'),
              ),
              TextButton(
                onPressed: () => _showInfo(
                  'Помощь',
                  'Используйте ту же электронную почту, которую указали при регистрации.',
                ),
                style: _footerLinkStyle,
                child: const Text('Помощь'),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  static final _footerLinkStyle = TextButton.styleFrom(
    foregroundColor: ColorsApp.muted,
    padding: EdgeInsets.zero,
    minimumSize: const Size(0, 44),
    textStyle: const TextStyle(fontSize: 12),
  );
}
