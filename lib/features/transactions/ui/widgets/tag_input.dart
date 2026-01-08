import 'package:flutter/material.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class TagInput extends StatelessWidget {
  final ValueChanged<String> onAddTag;
  final _controller = TextEditingController();

  TagInput({required this.onAddTag, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: l10n.transactionTagsLabel,
              hintText: l10n.transactionTagsHint,
            ),
            onFieldSubmitted: _onAdd,
          ),
        ),
        AppSpacing.gapHorizontalSm,
        FilledButton.icon(
          onPressed: _onAdd,
          icon: AppIcons.add,
          label: Text(l10n.add),
        ),
      ],
    );
  }

  void _onAdd([String? _]) {
    final tag = _controller.text.trim();
    if (tag.isNotEmpty) {
      onAddTag(tag);
      _controller.clear();
    }
  }
}
