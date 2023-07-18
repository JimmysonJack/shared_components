import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:google_ui/google_ui.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_component/src/components/toast.dart';
import 'package:shared_component/src/service/graphql_service.dart';
import 'package:shared_component/src/utils/dataTable.dart';
import 'package:shared_component/src/utils/loadingndicator.dart';
import 'package:shared_component/src/utils/new-widgets-component/client_config.dart';
import 'package:shared_component/src/service/notification_service.dart';
import 'package:shared_component/src/utils/new-widgets-component/other_parameters.dart';
import 'package:shared_component/src/utils/new-widgets-component/update_table.dart';
import 'package:shared_component/src/utils/table.dart';

import '../utils/new-widgets-component/base_fields.dart';
import 'paginated_data_table.dart';

class ListDataTable extends StatefulWidget {
  const ListDataTable({
    super.key,
    this.deleteUidFieldName,
    required this.endPointName,
    required this.queryFields,
    this.optionalResponseFields,
    this.inputs,
    this.tableAddButton,
    this.mapFunction,
    required this.headColumns,
    this.topActivityButtons,
    this.deleteEndPointName,
    this.actionButtons,
    this.fetchPolicy,
    this.progressOnMoreButton = false,
  });

  final String endPointName;
  final String queryFields;
  final String? optionalResponseFields;
  final TableAddButton? tableAddButton;

  final List<OtherParameters>? inputs;
  final Map<String, dynamic> Function(Map<String, dynamic> item)? mapFunction;

  ///[ headColumns ] is used to provide heading and key to accessing data for the named column
  final List<HeadTitleItem> headColumns;
  final List<TopActivityButton>? topActivityButtons;
  final String? deleteEndPointName;
  final List<ActionButtonItem>? actionButtons;
  final bool progressOnMoreButton;
  final String? deleteUidFieldName;
  final FetchPolicy? fetchPolicy;

  @override
  State<ListDataTable> createState() => _ListDataTableState();
}

class _ListDataTableState extends State<ListDataTable> {
  String? _searchKeyValue;
  int _initialSize = 20;
  List<Map<String, dynamic>> networkData = [];
  bool noSearchResults = false;
  DataTableController dataTableController = Get.put(DataTableController());
  Map<String, dynamic>? otherParams = {};
  String? _endpoint;

  @override
  void initState() {
    Map mapVariables = {};
    Map inputVariables = {};
    String? inputVariable = '';
    String? mapVariable = '';

    if (widget.inputs != null) {
      for (var element in widget.inputs!) {
        mapVariables.addAll({'\$${element.keyName}': element.keyType});
        inputVariables.addAll({element.keyName: '\$${element.keyName}'});
        otherParams?.addAll({element.keyName: element.keyValue});
      }
      mapVariable =
          '(${mapVariables.toString().replaceAll('{', '').replaceAll('}', '')})';
      inputVariable =
          '(${inputVariables.toString().replaceAll('{', '').replaceAll('}', '')})';
    }

    _endpoint = '''
  query ${widget.endPointName} $mapVariable{
    ${widget.endPointName} $inputVariable{
        $baseResponseFields
        data{
           ${widget.optionalResponseFields ?? widget.queryFields}
        }
    }
}
  ''';
    GraphQLService.getService.endPoint = _endpoint;
    GraphQLService.getService.endPointName = widget.endPointName;
    Toast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    dataTableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      ///this boolean is used to rebuild a page
      UpdateTable.change.updateTable;
      return FutureBuilder(
          future: graphClient(context),
          builder: (BuildContext context,
              AsyncSnapshot<ValueNotifier<GraphQLClient>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return IndicateProgress.circular();
            }
            if (snapshot.hasError) {
              return GErrorMessage(
                icon: const Icon(Icons.error_sharp),
                title: 'Client Error',
                subtitle: snapshot.error.toString(),
                buttonLabel: widget.tableAddButton?.buttonName ?? '',
                onPressed: widget.tableAddButton?.onPressed,
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return GraphQLProvider(
                  client: snapshot.data,
                  child: Obx(() {
                    if (dataTableController.rebuild.value) {}
                    return Query(
                      options: QueryOptions(
                        document: gql(_endpoint!),
                        variables: {
                          'searchKey': _searchKeyValue ?? '',
                          ...otherParams ?? {}
                        },
                        fetchPolicy:
                            widget.fetchPolicy ?? FetchPolicy.cacheAndNetwork,
                        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
                        errorPolicy: ErrorPolicy.all,
                      ),
                      builder: (QueryResult result,
                          {Refetch? refetch, FetchMore? fetchMore}) {
                        if (RebuildToRefetch.instance().getRefetchState()) {
                          RebuildToRefetch.instance().changeRefetchState(false);
                          refetch!();
                        }
                        List? repositories;

                        if (result.isLoading && result.data == null) {
                          return IndicateProgress.circular();
                        }

                        if (result.hasException) {
                          if (result.exception!.linkException != null) {
                            LinkException exception =
                                result.exception!.linkException!;
                            if (exception.runtimeType == ServerException) {
                              return GErrorMessage(
                                icon: const Icon(Icons.wifi_off),
                                title: 'Network Error',
                                subtitle:
                                    'Check your Internet connection first.',
                                buttonLabel: 'Retry',
                                onPressed: refetch,
                              );
                            } else if (exception.runtimeType ==
                                HttpLinkServerException) {
                              HttpLinkServerException serverException =
                                  exception as HttpLinkServerException;

                              if (serverException.parsedResponse!.response.keys
                                  .contains('message')) {
                                var errorResponse = serverException
                                    .parsedResponse!.response['message']
                                    .split(':');
                                if (errorResponse[0] ==
                                    "Invalid access token") {
                                  return GErrorMessage(
                                    icon:
                                        const Icon(Icons.vpn_key_off_outlined),
                                    title: errorResponse[0],
                                  );
                                }
                              } else if (serverException
                                  .parsedResponse!.response.keys
                                  .contains('error_description')) {
                                var errorResponse = serverException
                                    .parsedResponse!
                                    .response['error_description']
                                    .split(':');
                                if (errorResponse[0] ==
                                    "Invalid access token") {
                                  return GErrorMessage(
                                    icon:
                                        const Icon(Icons.vpn_key_off_outlined),
                                    title: errorResponse[0],
                                  );
                                }
                              }
                              return GErrorMessage(
                                icon: const Icon(Icons.block),
                                title: 'Something Is Wrong',
                                buttonLabel: 'Retry',
                                onPressed: refetch,
                              );
                            }
                          } else {
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              if (result.data?[widget.endPointName] == null) {
                                List errorsList =
                                    result.exception!.graphqlErrors;
                                NotificationService.errors(
                                    title: 'GraphQL Errors!',
                                    context: context,
                                    contents: errorsList);
                              }
                            });

                            return const GErrorMessage(
                              icon: Icon(Icons.block),
                              title: 'Errors Occurred',
                            );
                          }
                        } else if (!result.isOptimistic) {
                          repositories =
                              result.data?[widget.endPointName]?['data'];
                          if (_searchKeyValue != null &&
                              result.data?[widget.endPointName]?['data']
                                  .isEmpty) {
                            noSearchResults = true;
                          } else {
                            noSearchResults = false;
                          }

                          if (repositories!.isEmpty && !noSearchResults) {
                            return GErrorMessage(
                              icon: const Icon(Icons.error),
                              title: 'No Data Yet',
                              buttonLabel:
                                  widget.tableAddButton?.buttonName ?? '',
                              onPressed: widget.tableAddButton?.onPressed,
                            );
                          }
                        }

                        FetchMoreOptions options({int? nextPage, int? size}) =>
                            FetchMoreOptions(
                                variables: {...otherParams ?? {}},
                                updateQuery:
                                    (previousResultData, fetchMoreResultData) {
                                  final List<Map<String, dynamic>> repos = [
                                    ...previousResultData?[widget.endPointName]
                                            ['data']
                                        .map((e) => e)
                                        .cast<Map<String, dynamic>>()
                                        .toList(),
                                    ...fetchMoreResultData?[widget.endPointName]
                                            ['data']
                                        .map((e) => e)
                                        .cast<Map<String, dynamic>>()
                                        .toList()
                                  ];
                                  fetchMoreResultData?[widget.endPointName]
                                          ['data'] =
                                      repos
                                          .map((e) => e)
                                          .cast<Map<String, dynamic>>()
                                          .toList();
                                  return fetchMoreResultData;
                                });

                        FetchMoreOptions refetchOptions(
                                {String? searchKey, int? size}) =>
                            FetchMoreOptions(
                                variables: {
                                  "searchParam": searchKey,
                                  ...otherParams ?? {}
                                },
                                updateQuery:
                                    (previousResultData, fetchMoreResultData) {
                                  final List<Map<String, dynamic>> repos = [
                                    ...fetchMoreResultData?[widget.endPointName]
                                            ['data']
                                        .map((e) => e)
                                        .cast<Map<String, dynamic>>()
                                        .toList()
                                  ];
                                  fetchMoreResultData?[widget.endPointName]
                                          ['data'] =
                                      repos
                                          .map((e) => e)
                                          .cast<Map<String, dynamic>>()
                                          .toList();
                                  return fetchMoreResultData;
                                });

                        if (UpdateTable.change.updateTable) {
                          fetchMore!(refetchOptions());
                          UpdateTable.change.setUpdateTable(false);
                        }
                        networkData = repositories
                                ?.map((e) => toMapFunction(e))
                                .toList() ??
                            [];
                        _initialSize = networkData.length;
                        UpdateTable.change.tableListData =
                            searchLocalData(networkData: networkData);
                        return Observer(builder: (context) {
                          return DataSourceTable(
                              title: '',
                              serialNumberTitle: 'SN',
                              loadingOnUpdateData: result.isLoading,
                              headTileItems: widget.headColumns,
                              deleteData:
                                  widget.deleteEndPointName?.isNotEmpty ??
                                      false,
                              onDelete: (rowData) {
                                dataTableController.onDeleteLoad.value = true;

                                GraphQLService.mutate(
                                    successMessage:
                                        'Record Deleted Successfully',
                                    context: context,
                                    response: (results, isLoading) {
                                      dataTableController.onDeleteLoad.value =
                                          isLoading;
                                      if (results != null) {
                                        refetch!();
                                      }
                                    },
                                    endPointName: widget.deleteEndPointName!,
                                    queryFields: widget.queryFields,
                                    inputs: [
                                      InputParameter(
                                          fieldName:
                                              widget.deleteUidFieldName ??
                                                  'uid',
                                          inputType: 'String',
                                          fieldValue: rowData['uid'])
                                    ]);
                              },
                              tableColor: Theme.of(context).cardColor,
                              actionButton: widget.actionButtons ?? [],
                              // onDeleteLoader: _onDeleteLoading,
                              noSearchResults: noSearchResults,
                              onEmptySearch: () {
                                if (noSearchResults) {
                                  _searchKeyValue = null;
                                  UpdateTable.change.tableListData =
                                      searchLocalData(networkData: networkData);
                                  noSearchResults = false;
                                } else {
                                  UpdateTable.change.tableListData =
                                      searchLocalData(networkData: networkData);
                                }
                              },
                              onSearch: (searchKey) {
                                _searchKeyValue = searchKey;
                                UpdateTable.change.tableListData =
                                    searchLocalData(
                                        searchKey: searchKey,
                                        networkData: networkData);
                                // fetchMore!(refetchOptions(searchKey: searchKey));
                              },
                              buttonActivities: List.generate(
                                  widget.topActivityButtons?.length ?? 0,
                                  (index) {
                                return ButtonActivities(
                                    onTap: widget.topActivityButtons!
                                        .elementAt(index)
                                        .onTap,
                                    toolTip: widget.topActivityButtons!
                                        .elementAt(index)
                                        .toolTip,
                                    icon: widget.topActivityButtons!
                                                .elementAt(index)
                                                .iconData ==
                                            null
                                        ? null
                                        : Icon(
                                            widget.topActivityButtons!
                                                .elementAt(index)
                                                .iconData,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    textName: widget.topActivityButtons!
                                                .elementAt(index)
                                                .buttonName ==
                                            null
                                        ? null
                                        : Text(
                                            widget.topActivityButtons!
                                                    .elementAt(index)
                                                    .buttonName ??
                                                '',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ));
                              }),
                              currentPageSize: _initialSize,
                              // onPageSize: (value) {
                              //   _initialSize = value;
                              //   fetchMore!(
                              //       refetchOptions(size: value, searchKey: _searchKeyValue));
                              // },
                              actionTitle: 'Action',
                              paginatePage: PaginatePage(
                                currentPage: result.data?[widget.endPointName]
                                        ?['currentPage'] ??
                                    1,
                                currentPageColors:
                                    Theme.of(context).primaryColor,
                                pageSize: result.data?[widget.endPointName]
                                        ?['size'] ??
                                    0,
                                totalPages: result.data?[widget.endPointName]
                                        ?['pages'] ??
                                    0,
                                // totalPages: 2,
                                onNavigateToPage: (page) {
                                  fetchMore!(options(nextPage: page.nextPage));
                                },
                              ),
                              dataList: UpdateTable.change.tableListData);
                        });
                      },
                    );
                  }));
            }
            return const Center(
              child: Text('Something Is Wrong'),
            );
          });
    });
  }

  /// Filters the [networkData] by elements that contain the [searchKey] string (if provided)
  /// and returns a new list of filtered elements.
  ///
  /// If no [searchKey] is provided or it is an empty string, returns the original [networkData].
  List<Map<String, dynamic>> searchLocalData(
      {String? searchKey, required List<Map<String, dynamic>> networkData}) {
    if (searchKey?.isNotEmpty == true) {
      final filteredData = networkData.where((e) {
        for (final value in e.values) {
          if (value
              .toString()
              .toLowerCase()
              .contains(searchKey!.toLowerCase())) {
            return true;
          }
        }
        return false;
      }).toList();
      if (filteredData.isEmpty) {
        noSearchResults = true;
      }
      return filteredData;
    }
    return networkData.toList();
  }

  Map<String, dynamic> toMapFunction(Map<String, dynamic> item) {
    if (widget.mapFunction != null) {
      return {...item, ...widget.mapFunction!(item)};
    }
    return item;
  }
}

class TableAddButton {
  final String buttonName;
  final Function() onPressed;

  TableAddButton({required this.onPressed, required this.buttonName});
}
