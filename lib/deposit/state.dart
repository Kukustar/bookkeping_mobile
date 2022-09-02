import 'package:bookkeping_mobile/deposit/entity.dart';
import 'package:bookkeping_mobile/extensions.dart';
import 'package:bookkeping_mobile/service/core/network_service.dart';
import 'package:flutter/material.dart';

class DepositState {
  DepositState({
    this.page = 1,
    this.count = 0,
    this.depositList = const [],
    this.formStateAmount = '',
    this.formStateTitle = '',
    this.formStateDate,
    this.formStateTitleError = '',
    this.formStateAmountError = '',
    this.formStateDateTimeController,
    this.isLoading = false,
    this.depositId = 0,
    this.saveResponseStatus = NetworkResponseStatus.waiting
  });

  final bool isLoading;

  final int depositId;
  final int page;
  final int count;
  final List<Deposit> depositList;

  final String formStateAmount;
  final String formStateTitleError;
  final String formStateAmountError;
  final String formStateTitle;
  DateTime? formStateDate;

  TextEditingController? formStateDateTimeController;

  final NetworkResponseStatus saveResponseStatus;

  List<String> get firstTenDates {
    return getFirstTenDeposits
        .map((e) => e.date.toHashMapKeyFormat())
        .toSet()
        .toList();
  }

  List<String> get depositListDates {
    return depositList
        .map((e) => e.date.toHashMapKeyFormat())
        .toSet()
        .toList();
  }

  List<Deposit> get getFirstTenDeposits {
    if(depositList.length <=  10) {
      return depositList;
    }

    return depositList;
  }

  bool get canTapPrevButton {
    if (count <= 25) {
      return false;
    }
    int totalPage = (count ~/ 25) + 1;
    if (page <= totalPage) {
      return true;
    }

    return false;
  }

  DepositState copyWith({
   int? page,
   int? count,
   List<Deposit>? depositList,
   String? formStateAmount,
   String? formStateTitleError,
   String? formStateAmountError,
   String? formStateTitle,
   DateTime? formStateDate,
   TextEditingController? formStateDateTimeController,
   bool? isLoading,
   int? depositId,
   NetworkResponseStatus? saveResponseStatus
  }) {
    return DepositState(
      page: page ?? this.page,
      count: count ?? this.count,
      depositList: depositList ?? this.depositList,
      formStateAmount: formStateAmount ?? this.formStateAmount,
      formStateTitleError: formStateTitleError ?? this.formStateTitleError,
      formStateAmountError: formStateAmountError ?? this.formStateAmountError,
      formStateTitle: formStateTitle ?? this.formStateTitle,
      formStateDate: formStateDate ?? this.formStateDate,
      formStateDateTimeController: formStateDateTimeController ?? this.formStateDateTimeController,
      isLoading: isLoading ?? this.isLoading,
      depositId: depositId ?? this.depositId,
      saveResponseStatus: saveResponseStatus ?? this.saveResponseStatus,
    );
  }

}