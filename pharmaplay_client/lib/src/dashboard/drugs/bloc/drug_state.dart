part of 'drug_bloc.dart';

enum DrugStatus { initializing, loading, success, failed, empty, scrolloading }

class DrugState extends Equatable {
  const DrugState(
      {this.status = DrugStatus.empty,
      this.drugs = const [],
      this.stateMsg = '',
      this.localeUI = 'en',
      this.hasReachedMax = false,
      this.startFrompage = 1,
      this.pageLength = 16,
      this.currentPage = 1,
      this.whereCond = '',
      this.searchType = SearchType.none,
      this.serachValue = '',
      this.orderByFields = ''});

  final DrugStatus status;
  final String localeUI;
  final String whereCond;
  final bool hasReachedMax;
  final List<DrugRecord> drugs;
  final String stateMsg;
  final int startFrompage;
  final int currentPage;
  final int pageLength;
  final String orderByFields;
  final SearchType searchType;
  final String serachValue;

  @override
  List<Object> get props => [
        status,
        drugs,
        localeUI,
        whereCond,
        hasReachedMax,
        startFrompage,
        currentPage,
        pageLength,
        stateMsg,
        searchType,
        serachValue,
        orderByFields
      ];

  DrugState copyWith(
      {DrugStatus? status,
      String? localeUI,
      String? whereCond,
      bool? hasReachedMax,
      List<DrugRecord>? drugs,
      String? stateMsg,
      int? startFrompage,
      int? currentPage,
      int? pageLength,
      SearchType? searchType,
      String? serachValue,
      String? orderByFields}) {
    return DrugState(
        status: status ?? this.status,
        localeUI: localeUI ?? this.localeUI,
        whereCond: whereCond ?? this.whereCond,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        drugs: drugs ?? this.drugs,
        stateMsg: stateMsg ?? this.stateMsg,
        startFrompage: startFrompage ?? this.startFrompage,
        currentPage: currentPage ?? this.currentPage,
        pageLength: pageLength ?? this.pageLength,
        searchType: searchType ?? this.searchType,
        serachValue: serachValue ?? this.serachValue,
        orderByFields: orderByFields ?? this.orderByFields);
  }
}
