import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 07/11/23
/// @Message : [TaskExecutor]
///
class TaskExecutor{
  static final TaskExecutor _singleton = TaskExecutor._();
  TaskExecutor._();
  static TaskExecutor get instance => _singleton;

  /// Execute Task Post Build
  void runTaskPostBuild(VoidCallback voidCallback){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      voidCallback.call();
    });
  }

  /// Future Micro Task Runner
  Future<void> runFutureMicroTask(VoidCallback voidCallback) async{
    await Future.microtask(() => voidCallback.call());
  }

  /// TODO: make dynamic call to compute func if possible
  /// Future<R> compute<M, R>(ComputeCallback<M, R> callback, M message, {String? debugLabel})
  runComputeTask(ComputeCallback computeCallback, dynamic params) async{
    await compute(computeCallback, params);
  }
}