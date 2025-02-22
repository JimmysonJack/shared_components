// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

typedef LibraryLoader = Future<void> Function();
typedef DeferredWidgetBuilder = Widget Function();

/// Wraps the child inside a deferred module loader.
///
/// The child is created and a single instance of the Widget is maintained in
/// state as long as closure to create widget stays the same.
///
class DeferredWidget extends StatefulWidget {
  const DeferredWidget(this.libraryLoader, this.createWidget,
      {Key? key, Widget? placeholder})
      : placeholder = placeholder ?? const DeferredLoadingPlaceholder(),
        super(key: key);

  final LibraryLoader libraryLoader;
  final DeferredWidgetBuilder createWidget;
  final Widget placeholder;
  static final Map<LibraryLoader, Future<void>> _moduleLoaders = {};
  static final Set<LibraryLoader> _loadedModules = {};

  static Future<void> preload(LibraryLoader loader) {
    if (!_moduleLoaders.containsKey(loader)) {
      _moduleLoaders[loader] = loader().then((dynamic _) {
        _loadedModules.add(loader);
      });
    }
    return _moduleLoaders[loader]!;
  }

  @override
  DeferredWidgetState createState() => DeferredWidgetState();
}

class DeferredWidgetState extends State<DeferredWidget> {
  DeferredWidgetState();
  Widget? _loadedChild;
  DeferredWidgetBuilder? _loadedCreator;

  @override
  void initState() {
    /// If module was already loaded immediately create widget instead of
    /// waiting for future or zone turn.
    if (DeferredWidget._loadedModules.contains(widget.libraryLoader)) {
      _onLibraryLoaded();
    } else {
      DeferredWidget.preload(widget.libraryLoader)
          .then((dynamic _) => _onLibraryLoaded());
    }
    super.initState();
  }

  void _onLibraryLoaded() {
    setState(() {
      _loadedCreator = widget.createWidget;
      _loadedChild = _loadedCreator!();
    });
  }

  @override
  Widget build(BuildContext context) {
    /// If closure to create widget changed, create new instance, otherwise
    /// treat as const Widget.
    if (_loadedCreator != widget.createWidget && _loadedCreator != null) {
      _loadedCreator = widget.createWidget;
      _loadedChild = _loadedCreator!();
    }
    return _loadedChild ?? widget.placeholder;
  }
}

/// Displays a progress indicator and text description explaining that
/// the widget is a deferred component and is currently being installed.
class DeferredLoadingPlaceholder extends StatelessWidget {
  const DeferredLoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(child: Center(child: IndicateProgress.circular())));
  }
}
