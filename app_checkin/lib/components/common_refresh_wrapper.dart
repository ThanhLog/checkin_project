import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class CommonRefreshWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final bool isLoadingMore;
  final EdgeInsetsGeometry padding;
  final ScrollController? scrollController;
  final Widget? loadingMoreWidget;

  const CommonRefreshWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
    this.isLoadingMore = false,
    this.scrollController,
    this.padding = EdgeInsets.zero,
    this.loadingMoreWidget,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scrollable = ListView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: child,
            ),
          ],
        );

        return Stack(
          children: [
            CustomRefreshIndicator(
              onRefresh: onRefresh,
              trigger: IndicatorTrigger.leadingEdge,
              triggerMode: IndicatorTriggerMode.onEdge,
              child: scrollable,
              builder: (context, scrollChild, refreshController) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    scrollChild,
                    if (refreshController.isLoading ||
                        refreshController.isDragging)
                      Positioned(
                        top: 20,
                        child: Transform.scale(
                          scale: refreshController.value.clamp(0.6, 1.0),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: refreshController.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.refresh,
                                    size: 28,
                                    color: Colors.blue,
                                  ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            if (isLoadingMore)
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child:
                    loadingMoreWidget ??
                    const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
              ),
          ],
        );
      },
    );
  }
}
