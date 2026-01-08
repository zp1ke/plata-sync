import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../../../core/ui/widgets/input_decoration.dart';
import '../../../tags/application/tags_manager.dart';
import '../../../tags/domain/entities/tag.dart';
import '../../../../l10n/app_localizations.dart';

/// A widget that allows selecting multiple tags from available tags
class TagSelector extends StatefulWidget {
  final List<String>? tagIds;
  final ValueChanged<List<String>> onChanged;
  final String? Function(List<Tag>?)? validator;
  final bool enabled;
  final String? label;

  const TagSelector({
    required this.tagIds,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.label,
    super.key,
  });

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  @override
  void initState() {
    super.initState();
    // Load tags when the selector is first created
    final manager = getService<TagsManager>();
    if (manager.tags.value.isEmpty) {
      manager.loadTags();
    }
  }

  void _showTagDialog(BuildContext context, List<Tag> allTags) {
    final selectedIds = Set<String>.from(widget.tagIds ?? []);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final l10n = AppL10n.of(context);
            return AppDialog(
              title: widget.label ?? l10n.transactionTagsLabel,
              scrollable: false,
              content: ListView.builder(
                itemCount: allTags.length,
                itemBuilder: (context, index) {
                  final tag = allTags[index];
                  final isSelected = selectedIds.contains(tag.id);
                  return CheckboxListTile(
                    title: Text(tag.name),
                    value: isSelected,
                    onChanged: (checked) {
                      setDialogState(() {
                        if (checked == true) {
                          selectedIds.add(tag.id);
                        } else {
                          selectedIds.remove(tag.id);
                        }
                      });
                    },
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    widget.onChanged(selectedIds.toList());
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.apply),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final labelText = widget.label ?? l10n.transactionTagsLabel;
    final manager = getService<TagsManager>();

    return ValueListenableBuilder<List<Tag>>(
      valueListenable: manager.tags,
      builder: (context, tags, _) {
        if (tags.isEmpty) {
          return TextFormField(
            enabled: false,
            decoration: inputDecorationWithPrefixIcon(
              labelText: labelText,
              hintText: l10n.transactionTagsHint,
              prefixIcon: AppIcons.tagsXs,
            ),
          );
        }

        final selectedTags = tags
            .where((tag) => widget.tagIds?.contains(tag.id) ?? false)
            .toList();

        final displayText = selectedTags.isEmpty
            ? (l10n.selectTags)
            : selectedTags.map((t) => t.name).join(', ');

        return InkWell(
          onTap: widget.enabled ? () => _showTagDialog(context, tags) : null,
          child: InputDecorator(
            decoration:
                inputDecorationWithPrefixIcon(
                  labelText: labelText,
                  prefixIcon: AppIcons.accountsOutlinedXs,
                ).copyWith(
                  suffixIcon: selectedTags.isNotEmpty && widget.enabled
                      ? IconButton(
                          icon: SizedBox(
                            width: AppSizing.iconMd,
                            child: AppIcons.clear,
                          ),
                          onPressed: () => widget.onChanged([]),
                          tooltip: l10n.clear,
                        )
                      : null,
                ),
            child: Text(
              displayText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selectedTags.isEmpty
                    ? Theme.of(context).hintColor
                    : null,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        );
      },
    );
  }
}
