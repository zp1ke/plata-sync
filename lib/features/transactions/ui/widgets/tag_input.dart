import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../tags/application/tags_manager.dart';
import '../../../tags/domain/entities/tag.dart';

class TagInput extends StatefulWidget {
  final ValueChanged<String> onAddTag;
  final List<String> excludedIds;

  const TagInput({
    required this.onAddTag,
    this.excludedIds = const [],
    super.key,
  });

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  TextEditingController? _controller;

  Future<Iterable<Tag>> _searchTags(TextEditingValue textEditingValue) async {
    final query = textEditingValue.text.trim();
    if (query.length < 2) {
      return const [];
    }

    final tagsManager = getService<TagsManager>();
    try {
      return await tagsManager.searchTags(
        query,
        excludeIds: widget.excludedIds,
      );
    } catch (e) {
      return const [];
    }
  }

  void _onAdd([String? value]) {
    final text = value ?? _controller?.text;
    if (text == null) return;

    final tag = text.trim();
    if (tag.isNotEmpty) {
      widget.onAddTag(tag);
      _controller?.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return Row(
      children: [
        Expanded(
          child: Autocomplete<Tag>(
            optionsBuilder: _searchTags,
            displayStringForOption: (Tag option) => option.name,
            onSelected: (Tag selection) {
              _onAdd(selection.name);
            },
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  _controller = controller;
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: l10n.transactionTagsLabel,
                      hintText: l10n.transactionTagsHint,
                    ),
                    onFieldSubmitted: (value) {
                      onFieldSubmitted();
                      _onAdd(value);
                    },
                  );
                },
          ),
        ),
        AppSpacing.gapHorizontalSm,
        FilledButton.icon(
          onPressed: () => _onAdd(),
          icon: AppIcons.add,
          label: Text(l10n.add),
        ),
      ],
    );
  }
}
