import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../../../core/ui/widgets/input_decoration.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/tags_manager.dart';
import '../../domain/entities/tag.dart';
import '../../../transactions/application/transactions_manager.dart';

class TagsManagementDialog extends WatchingStatefulWidget {
  const TagsManagementDialog({super.key});

  @override
  State<TagsManagementDialog> createState() => _TagsManagementDialogState();
}

class _TagsManagementDialogState extends State<TagsManagementDialog> {
  @override
  void initState() {
    super.initState();
    getService<TagsManager>().loadTags();
  }

  void _showEditSheet(BuildContext context, {Tag? tag}) {
    final l10n = AppL10n.of(context);
    final manager = getService<TagsManager>();
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: tag?.name ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: AppSpacing.paddingMd,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    tag == null ? l10n.addTag : l10n.editTag,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: controller,
                    decoration: inputDecorationWithPrefixIcon(
                      labelText: l10n.tagName,
                      hintText: l10n.tagNameHint,
                      prefixIcon: AppIcons.tags,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.fieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final name = controller.text.trim();
                        if (tag != null) {
                          await manager.updateTag(tag.copyWith(name: name));
                        } else {
                          await manager.getOrCreateTag(name);
                        }
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    child: Text(l10n.save),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteTag(BuildContext context, Tag tag) async {
    final l10n = AppL10n.of(context);
    bool removeUsage = false;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.deleteTagConfirmTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.deleteTagConfirmBody),
                  const SizedBox(height: AppSpacing.md),
                  CheckboxListTile(
                    value: removeUsage,
                    onChanged: (value) {
                      setState(() {
                        removeUsage = value ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.removeTagFromTransactions),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text(l10n.deleteTag),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed == true) {
      if (removeUsage) {
        await getService<TransactionsManager>().removeTagFromTransactions(
          tag.id,
        );
      }
      await getService<TagsManager>().deleteTag(tag.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final tags = watchValue((TagsManager x) => x.tags);
    final isLoading = watchValue((TagsManager x) => x.isLoading);

    return AppDialog(
      title: l10n.manageTags,
      content: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tags.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                final tag = tags[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(tag.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: AppIcons.edit,
                        onPressed: () => _showEditSheet(context, tag: tag),
                      ),
                      IconButton(
                        icon: AppIcons.delete,
                        color: Theme.of(context).colorScheme.error,
                        onPressed: () => _deleteTag(context, tag),
                      ),
                    ],
                  ),
                );
              },
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.done),
        ),
        FilledButton.icon(
          onPressed: () => _showEditSheet(context),
          icon: AppIcons.add,
          label: Text(l10n.addTag),
        ),
      ],
    );
  }
}
