import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_mvvm_template/theme/app_colors.dart';
import 'package:flutter_mvvm_template/view_models/login_form_view_model.dart';
import 'package:flutter_mvvm_template/widgets/form_fields/app_text_field.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginFormViewModelProvider);
    final vm = ref.read(loginFormViewModelProvider.notifier);

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Phone number',
            hint: '0801 234 5678',
            errorText: state.phoneError,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.telephoneNumber],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            enabled: !state.isSubmitting,
            onChanged: vm.phoneChanged,
          ),
          const SizedBox(height: 4),
          AppTextField(
            label: 'Password',
            hint: 'Enter your password',
            errorText: state.passwordError,
            obscureText: state.obscurePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            enabled: !state.isSubmitting,
            onChanged: vm.passwordChanged,
            onSubmitted: (_) => vm.submit(),
            suffix: IconButton(
              tooltip: state.obscurePassword
                  ? 'Show password'
                  : 'Hide password',
              icon: Icon(
                state.obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textMuted,
              ),
              onPressed: vm.togglePasswordVisibility,
            ),
          ),
          SizedBox(
            height: 44,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                state.submitError ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: AppColors.danger),
              ),
            ),
          ),
          FilledButton(
            onPressed: state.isSubmitting ? null : vm.submit,
            child: state.isSubmitting
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.brand,
                    ),
                  )
                : const Text('Sign in'),
          ),
        ],
      ),
    );
  }
}
