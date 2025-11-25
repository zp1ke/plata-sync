import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';

import '../resources/app_sizing.dart';

class AppTopBar extends StatefulWidget {
  final String title;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;
  final bool isLoading;
  final VoidCallback? onRefresh;
  final Widget? bottom;

  const AppTopBar({
    super.key,
    required this.title,
    required this.searchHint,
    required this.onSearchChanged,
    this.isLoading = false,
    this.onRefresh,
    this.bottom,
  });

  @override
  State<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar> {
  final searchController = TextEditingController();
  bool isSearching = false;

  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  void onSearchChanged(String query) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearchChanged(query);
    });
  }

  void doSearch(String query) {
    debounce?.cancel();
    widget.onSearchChanged(query);
  }

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        clearSearch();
      }
    });
  }

  void clearSearch() {
    searchController.clear();
    doSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        appBar(),
        if (widget.bottom != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: widget.bottom,
            ),
          ),
      ],
    );
  }

  Widget appBar() {
    return SliverAppBar(
      title: isSearching ? searchField() : Text(widget.title),
      pinned: true,
      actions: [
        if (widget.isLoading)
          IconButton(
            onPressed: null,
            icon: SizedBox(
              height: AppSizing.iconSm,
              width: AppSizing.iconSm,
              child: const CircularProgressIndicator.adaptive(),
            ),
          ),
        if (isSearching)
          IconButton(icon: AppIcons.searchOff, onPressed: toggleSearch),
        if (!isSearching) ...[
          IconButton(icon: AppIcons.search, onPressed: toggleSearch),
          if (widget.onRefresh != null)
            IconButton(
              onPressed: widget.isLoading ? null : widget.onRefresh,
              icon: AppIcons.refresh,
            ),
        ],
      ],
    );
  }

  Widget searchField() {
    return TextField(
      controller: searchController,
      autofocus: true,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        isDense: true,
        prefix: Padding(
          padding: EdgeInsets.only(right: AppSpacing.xs),
          child: AppIcons.searchXs,
        ),
        hintText: widget.searchHint,
        suffixIcon: (!widget.isLoading && searchController.text.isNotEmpty)
            ? IconButton(icon: AppIcons.clear, onPressed: clearSearch)
            : null,
      ),
      onChanged: onSearchChanged,
      onSubmitted: doSearch,
    );
  }
}
