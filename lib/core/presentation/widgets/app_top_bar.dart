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
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearchChanged(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(widget.title),
      floating: true,
      snap: true,
      pinned: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: SearchBar(
            hintText: widget.searchHint,
            leading: const Icon(AppIcons.search),
            onChanged: _onSearchChanged,
            trailing: [
              if (widget.isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.onRefresh != null)
          IconButton(
            onPressed: widget.isLoading ? null : widget.onRefresh,
            icon: const Icon(AppIcons.refresh),
          ),
      ],
    );
  }
}
