import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plata_sync/core/presentation/resources/app_icons.dart';

class AppTopBar extends StatefulWidget {
  final String title;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const AppTopBar({
    super.key,
    required this.title,
    required this.searchHint,
    required this.onSearchChanged,
    this.isLoading = false,
    this.onRefresh,
  });

  @override
  State<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar> {
  final searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverAppBar(
          title: Text(widget.title),
          pinned: true,
          actions: [
            if (widget.onRefresh != null)
              IconButton(
                onPressed: widget.isLoading ? null : widget.onRefresh,
                icon: const Icon(AppIcons.refresh),
              ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: SearchBar(
              controller: searchController,
              hintText: widget.searchHint,
              leading: const Icon(AppIcons.search),
              onChanged: onSearchChanged,
              onSubmitted: doSearch,
              trailing: [
                if (widget.isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                if (!widget.isLoading && searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      doSearch('');
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
