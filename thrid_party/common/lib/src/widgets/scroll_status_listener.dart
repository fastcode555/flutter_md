import 'dart:async';

import 'package:flutter/material.dart';

/// @date 30/8/22
/// describe: 监听滚动状态的变化
Timer? _timer;

class ScrollStatusListener extends StatelessWidget {
  final Widget child;
  final ValueChanged<ScrollEndNotification>? scrollEndListener;
  final ValueChanged<ScrollMetrics>? metricsChangedListener;

  const ScrollStatusListener({
    required this.child,
    this.scrollEndListener,
    this.metricsChangedListener,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _onNotification,
      child: child,
    );
  }

  bool _onNotification(Notification notification) {
    debugPrint("滚动监听：${notification.runtimeType.toString()}");
    if (notification is ScrollStartNotification) {
      debugPrint("开始滚动");
      metricsChangedListener?.call(notification.metrics);
    } else if (notification is ScrollUpdateNotification) {
      debugPrint("正在滚动:${notification.metrics.pixels},总滚动距离：${notification.metrics.maxScrollExtent}");
      metricsChangedListener?.call(notification.metrics);
    } else if (notification is ScrollEndNotification) {
      debugPrint("结束滚动");
      metricsChangedListener?.call(notification.metrics);
      _timer?.cancel();
      _timer = Timer.periodic(
        const Duration(milliseconds: 600),
        (timer) {
          _timer?.cancel();
          _timer = null;
          scrollEndListener?.call(notification);
        },
      );
    }
    return true;
  }
}
