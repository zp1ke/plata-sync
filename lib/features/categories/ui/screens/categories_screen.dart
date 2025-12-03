import 'package:flutter/material.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/model/enums/view_mode.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/app_top_bar.dart';
import 'package:plata_sync/core/ui/widgets/responsive_layout.dart';
import 'package:plata_sync/core/ui/widgets/sort_selector.dart';
import 'package:plata_sync/core/ui/widgets/view_toggle.dart';
import 'package:plata_sync/core/utils/random.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/features/categories/ui/widgets/category_details_dialog.dart';
import 'package:plata_sync/features/categories/ui/widgets/category_details_view.dart';
import 'package:plata_sync/features/categories/ui/widgets/category_edit_dialog.dart';
import 'package:plata_sync/features/categories/ui/widgets/category_edit_form.dart';
import 'package:plata_sync/features/categories/ui/widgets/category_grid_view.dart';
import 'package:plata_sync/features/categories/ui/widgets/category_list_view.dart';
import 'package:plata_sync/l10n/app_localizations.dart';
import 'package:watch_it/watch_it.dart';

class CategoriesScreen extends WatchingWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: (context) => const _MobileCategoriesScreen(),
      tabletOrLarger: (context) => const _TabletCategoriesScreen(),
    );
  }
}

// Mobile implementation - uses dialogs
class _MobileCategoriesScreen extends WatchingStatefulWidget {
  const _MobileCategoriesScreen();

  @override
  State<_MobileCategoriesScreen> createState() =>
      _MobileCategoriesScreenState();
}

class _MobileCategoriesScreenState extends State<_MobileCategoriesScreen> {
  bool _hasShownSampleDialog = false;

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((CategoriesManager x) => x.isLoading);
    final categories = watchValue((CategoriesManager x) => x.categories);
    final currentQuery = watchValue((CategoriesManager x) => x.currentQuery);
    final sortOrder = watchValue((CategoriesManager x) => x.sortOrder);
    final viewMode = watchValue((CategoriesManager x) => x.viewMode);
    final l10n = AppL10n.of(context);

    // Show sample data dialog once after initial load completes with no data
    if (!_hasShownSampleDialog &&
        !isLoading &&
        categories.isEmpty &&
        currentQuery.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasShownSampleDialog) {
          setState(() {
            _hasShownSampleDialog = true;
          });
          _showSampleDataDialog(context);
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (_, _) {
            final manager = getService<CategoriesManager>();
            return [
              AppTopBar(
                title: l10n.categoriesScreenTitle,
                searchHint: l10n.categoriesSearchHint,
                onSearchChanged: (value) =>
                    manager.loadCategories(query: value),
                isLoading: isLoading,
                onRefresh: () => manager.loadCategories(),
                bottom: _buildBottomBar(
                  context,
                  sortOrder,
                  viewMode,
                  manager,
                  l10n,
                  isLoading,
                ),
              ),
            ];
          },
          body: _buildContent(
            context,
            isLoading,
            categories,
            currentQuery,
            viewMode,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading ? null : () => _handleCreate(context),
        child: AppIcons.add,
      ),
    );
  }

  void _handleCreate(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CategoryEditDialog(
        onSave: (newCategory) => _handleSaveCreate(context, newCategory),
      ),
    );
  }

  void _showCategoryDetails(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (_) => CategoryDetailsDialog(
        category: category,
        onEdit: () => _handleEdit(context, category),
        onDuplicate: () => _handleDuplicate(context, category),
        onDelete: () => _handleDelete(context, category),
      ),
    );
  }

  void _handleEdit(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (_) => CategoryEditDialog(
        category: category,
        onSave: (updatedCategory) => _handleSaveEdit(context, updatedCategory),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isLoading,
    List<Category> categories,
    String currentQuery,
    ViewMode viewMode,
  ) {
    final l10n = AppL10n.of(context);
    if (isLoading && categories.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (categories.isEmpty) {
      if (currentQuery.isNotEmpty) {
        return Center(
          child: Text(l10n.categoriesNoSearchResults(currentQuery)),
        );
      }
      return Center(child: Text(l10n.categoriesEmptyState));
    }

    return viewMode == ViewMode.list
        ? CategoryListView(
            categories: categories,
            onTap: isLoading
                ? null
                : (category) => _showCategoryDetails(context, category),
          )
        : CategoryGridView(
            categories: categories,
            onTap: isLoading
                ? null
                : (category) => _showCategoryDetails(context, category),
          );
  }
}

// Tablet implementation - uses master-detail layout
class _TabletCategoriesScreen extends WatchingStatefulWidget {
  const _TabletCategoriesScreen();

  @override
  State<_TabletCategoriesScreen> createState() =>
      _TabletCategoriesScreenState();
}

class _TabletCategoriesScreenState extends State<_TabletCategoriesScreen> {
  Category? selectedCategory;
  bool isEditing = false;
  final _editFormKey = GlobalKey<CategoryEditFormState>();
  bool _canSave = false;
  bool _hasShownSampleDialog = false;

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((CategoriesManager x) => x.isLoading);
    final categories = watchValue((CategoriesManager x) => x.categories);
    final currentQuery = watchValue((CategoriesManager x) => x.currentQuery);
    final sortOrder = watchValue((CategoriesManager x) => x.sortOrder);
    final viewMode = watchValue((CategoriesManager x) => x.viewMode);
    final l10n = AppL10n.of(context);

    // Show sample data dialog once after initial load completes with no data
    if (!_hasShownSampleDialog &&
        !isLoading &&
        categories.isEmpty &&
        currentQuery.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasShownSampleDialog) {
          setState(() {
            _hasShownSampleDialog = true;
          });
          _showSampleDataDialog(context);
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: MasterDetailLayout(
          master: NestedScrollView(
            headerSliverBuilder: (_, _) {
              final manager = getService<CategoriesManager>();
              return [
                AppTopBar(
                  title: l10n.categoriesScreenTitle,
                  searchHint: l10n.categoriesSearchHint,
                  onSearchChanged: (value) =>
                      manager.loadCategories(query: value),
                  isLoading: isLoading,
                  onRefresh: () => manager.loadCategories(),
                  bottom: _buildBottomBar(
                    context,
                    sortOrder,
                    viewMode,
                    manager,
                    l10n,
                    isLoading,
                    showViewToggle: true,
                  ),
                ),
              ];
            },
            body: _buildContent(
              context,
              isLoading,
              categories,
              currentQuery,
              viewMode,
              selectedCategoryId: selectedCategory?.id,
            ),
          ),
          detail: _buildDetailPane(),
          detailPlaceholder: Center(
            child: Text(
              l10n.categoriesSelectPrompt,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
      floatingActionButton: isEditing
          ? null
          : FloatingActionButton.extended(
              onPressed: isLoading
                  ? null
                  : () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            selectedCategory = null;
                            isEditing = true;
                          });
                        }
                      });
                    },
              icon: AppIcons.add,
              label: Text(l10n.categoriesAddButton),
            ),
    );
  }

  Widget? _buildDetailPane() {
    if (selectedCategory == null && !isEditing) return null;

    if (isEditing) {
      return _buildEditView();
    }

    return _buildDetailsView();
  }

  Widget _buildDetailsView() {
    final category = selectedCategory!;
    final l10n = AppL10n.of(context);

    return Column(
      children: [
        // Header with actions
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () => _handleDelete(context, category),
                icon: AppIcons.delete,
                tooltip: l10n.delete,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
              IconButton(
                onPressed: () => _handleDuplicate(context, category),
                icon: AppIcons.copy,
                tooltip: l10n.duplicate,
              ),
              IconButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        isEditing = true;
                      });
                    }
                  });
                },
                icon: AppIcons.edit,
                tooltip: l10n.edit,
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: CategoryDetailsView(category: category, showLargeIcon: true),
          ),
        ),
      ],
    );
  }

  Widget _buildEditView() {
    final l10n = AppL10n.of(context);

    void triggerSave() {
      _editFormKey.currentState?.handleSave();
    }

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedCategory == null
                      ? l10n.categoriesCreateTitle
                      : l10n.categoriesEditTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        isEditing = false;
                      });
                    }
                  });
                },
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton(
                onPressed: _canSave ? triggerSave : null,
                child: Text(l10n.save),
              ),
            ],
          ),
        ),
        // Form
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizing.dialogMaxWidth,
                ),
                child: CategoryEditForm(
                  key: _editFormKey,
                  category: selectedCategory,
                  showActions: false,
                  onFormValidChanged: (isValid) {
                    setState(() {
                      _canSave = isValid;
                    });
                  },
                  onSave: (updatedCategory) async {
                    if (selectedCategory == null) {
                      await _handleSaveCreate(context, updatedCategory);
                    } else {
                      await _handleSaveEdit(context, updatedCategory);
                    }
                    setState(() {
                      selectedCategory = updatedCategory;
                      isEditing = false;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isLoading,
    List<Category> categories,
    String currentQuery,
    ViewMode viewMode, {
    String? selectedCategoryId,
  }) {
    final l10n = AppL10n.of(context);
    if (isLoading && categories.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (categories.isEmpty) {
      if (currentQuery.isNotEmpty) {
        return Center(
          child: Text(l10n.categoriesNoSearchResults(currentQuery)),
        );
      }
      return Center(child: Text(l10n.categoriesEmptyState));
    }

    return viewMode == ViewMode.list
        ? CategoryListView(
            categories: categories,
            selectedCategoryId: selectedCategoryId,
            onTap: isLoading
                ? null
                : (category) {
                    setState(() {
                      selectedCategory = category;
                      isEditing = false;
                    });
                  },
          )
        : CategoryGridView(
            categories: categories,
            selectedCategoryId: selectedCategoryId,
            onTap: isLoading
                ? null
                : (category) {
                    setState(() {
                      selectedCategory = category;
                      isEditing = false;
                    });
                  },
          );
  }
}

// Shared helper methods
Future<void> _showSampleDataDialog(BuildContext context) async {
  final l10n = AppL10n.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      insetPadding: AppSpacing.paddingMd,
      title: Text(l10n.categoriesEmptyState),
      content: Text(l10n.categoriesAddSampleDataPrompt),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.no),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.yes),
        ),
      ],
    ),
  );

  if (result == true && context.mounted) {
    final manager = getService<CategoriesManager>();
    await manager.createSampleData();
  }
}

Widget _buildBottomBar(
  BuildContext context,
  CategorySortOrder sortOrder,
  ViewMode viewMode,
  CategoriesManager manager,
  AppL10n l10n,
  bool isLoading, {
  bool showViewToggle = false,
}) {
  return Row(
    children: [
      Expanded(
        child: SortSelector<CategorySortOrder>(
          value: sortOrder,
          onChanged: isLoading ? null : manager.setSortOrder,
          labelBuilder: (order) => _sortLabel(order, l10n),
          sortIconBuilder: (order) => order.isDescending
              ? AppIcons.sortDescending
              : AppIcons.sortAscending,
          options: CategorySortOrder.values,
        ),
      ),
      if (showViewToggle) ...[
        AppSpacing.gapHorizontalSm,
        ViewToggle(
          value: viewMode,
          onChanged: isLoading ? null : manager.setViewMode,
        ),
      ],
    ],
  );
}

String _sortLabel(CategorySortOrder sortOrder, AppL10n l10n) {
  switch (sortOrder) {
    case CategorySortOrder.nameAsc:
      return l10n.categoriesSortNameAsc;
    case CategorySortOrder.nameDesc:
      return l10n.categoriesSortNameDesc;
    case CategorySortOrder.lastUsedAsc:
      return l10n.categoriesSortLastUsedAsc;
    case CategorySortOrder.lastUsedDesc:
      return l10n.categoriesSortLastUsedDesc;
  }
}

Future<void> _handleSaveCreate(
  BuildContext context,
  Category newCategory,
) async {
  final l10n = AppL10n.of(context);
  final manager = getService<CategoriesManager>();
  try {
    await manager.addCategory(newCategory);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.categoryCreated(newCategory.name))),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.categoryCreateFailed(e.toString()))),
      );
    }
  }
}

Future<void> _handleSaveEdit(
  BuildContext context,
  Category updatedCategory,
) async {
  final l10n = AppL10n.of(context);
  final manager = getService<CategoriesManager>();
  try {
    await manager.updateCategory(updatedCategory);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.categoryUpdated(updatedCategory.name))),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.categoryUpdateFailed(e.toString()))),
      );
    }
  }
}

Future<void> _handleDuplicate(BuildContext context, Category category) async {
  final l10n = AppL10n.of(context);
  final manager = getService<CategoriesManager>();
  try {
    final duplicated = category.copyWith(
      id: randomId(),
      createdAt: DateTime.now(),
      name: '${category.name} (${l10n.copy})',
      lastUsed: null,
    );
    await manager.addCategory(duplicated);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.categoryDuplicated(category.name))),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.categoryDuplicateFailed(category.name, e.toString()),
          ),
        ),
      );
    }
  }
}

Future<void> _handleDelete(BuildContext context, Category category) async {
  final l10n = AppL10n.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      insetPadding: AppSpacing.paddingMd,
      title: Text(l10n.delete),
      content: Text(l10n.categoriesDeleteConfirmation(category.name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.no),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(dialogContext).colorScheme.error,
          ),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    final manager = getService<CategoriesManager>();
    try {
      await manager.deleteCategory(category.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.categoryDeleted(category.name))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.categoryDeleteFailed(category.name, e.toString()),
            ),
          ),
        );
      }
    }
  }
}
