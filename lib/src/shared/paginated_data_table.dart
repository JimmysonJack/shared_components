import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_component/shared_component.dart';
import 'package:shared_component/src/utils/g_ui/g_error_message.dart';

import '../utils/new-widgets-component/base_fields.dart';

class PageableDataTable extends StatefulWidget {
  const PageableDataTable(
      {Key? key,
      this.deleteUidFieldName,
      required this.endPointName,
      required this.queryFields,
      this.otherParameters,
      this.tableAddButton,
      this.mapFunction,
      required this.headColumns,
      this.topActivityButtons,
      this.deleteEndPointName,
      this.actionButtons,
      this.primaryAction,
      this.filter})
      : super(key: key);

  final String endPointName;
  final String queryFields;
  final TableAddButton? tableAddButton;
  final DataFilter? filter;
  final List<OtherParameters>? otherParameters;
  final Map<String, dynamic> Function(Map<String, dynamic> item)? mapFunction;

  ///[ headColumns ] is used to provide heading and key to accessing data for the named column
  final List<HeadTitleItem> headColumns;
  final List<TopActivityButton>? topActivityButtons;
  final String? deleteEndPointName;
  final List<ActionButtonItem>? actionButtons;
  final String? deleteUidFieldName;
  final PrimaryAction? primaryAction;

  @override
  State<PageableDataTable> createState() => _PageableDataTableState();
}

class _PageableDataTableState extends State<PageableDataTable> {
  String? _searchKeyValue;
  int _initialSize = 20;
  String? _endpoint;
  Map<String, dynamic>? otherParams = {};
  final dataTableController = Get.put(DataTableController());
  //  final GlobalKey<QueryState> _queryKey = GlobalKey();

  @override
  void initState() {
    Toast.init(context);
    super.initState();
    Map mapVariables = {};
    Map inputVariables = {};
    String? inputVariable = '';
    String? mapVariable = '';

    if (widget.otherParameters != null) {
      for (var element in widget.otherParameters!) {
        mapVariables.addAll({'\$${element.keyName}': element.keyType});
        inputVariables.addAll({element.keyName: '\$${element.keyName}'});
        otherParams?.addAll({element.keyName: element.keyValue});
      }
      mapVariable =
          mapVariables.toString().replaceAll('{', '').replaceAll('}', '');
      inputVariable =
          inputVariables.toString().replaceAll('{', '').replaceAll('}', '');
    }
    _endpoint = '''
  query ${widget.endPointName}($pageableFields $mapVariable){
    ${widget.endPointName}($pageableValue  $inputVariable){
        $pageableBaseFields
        data{
           ${widget.queryFields}
        }
    }
}
  ''';
    GraphQLService.getService.endPoint = _endpoint;
    GraphQLService.getService.endPointName = widget.endPointName;
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
              return Center(
                child: IndicateProgress.circular(),
              );
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
                          'pageableParam': {
                            'size': _initialSize,
                            'page': 0,
                            'searchParam': _searchKeyValue ?? '',
                          },
                          ...otherParams ?? {}
                        },
                        fetchPolicy: FetchPolicy.networkOnly,
                        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
                        errorPolicy: ErrorPolicy.all,
                      ),
                      builder: (QueryResult result,
                          {Refetch? refetch, FetchMore? fetchMore}) {
                        if (RebuildToRefetch.instance().getRefetchState()) {
                          RebuildToRefetch.instance().changeRefetchState(false);
                          refetch!();
                        }
                        bool noSearchResults = false;
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
                                    // buttonLabel:
                                    //     widget.tableAddButton?.buttonName ?? '',
                                    // onPressed: widget.tableAddButton?.onPressed,
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
                                    // buttonLabel:
                                    //     widget.tableAddButton?.buttonName ?? '',
                                    // onPressed: widget.tableAddButton?.onPressed,
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
                            List<GraphQLError>? errorsList =
                                result.exception?.graphqlErrors;
                            bool accessDenied = errorsList!
                                .where((element) => element.message
                                    .toString()
                                    .contains('Access is denied'))
                                .isNotEmpty;
                            if (!accessDenied &&
                                SettingsService.use.isEmptyOrNull(
                                    result.data?[widget.endPointName])) {
                              Future.delayed(const Duration(microseconds: 100),
                                  () {
                                NotificationService.errors(
                                    title: 'GraphQL Errors!',
                                    context: context,
                                    contents: errorsList);
                              });
                              return const GErrorMessage(
                                icon: Icon(Icons.block),
                                title: 'Errors Occurred',
                              );
                            } else {
                              return const GErrorMessage(
                                icon: Icon(Icons.lock),
                                title: 'You Are Not Authorized!',
                                subtitle: 'Access Denied',
                              );
                            }
                          }
                        } else if (!result.isOptimistic) {
                          repositories = DataFilter.filter(
                              List<Map<String, dynamic>>.from(
                                  result.data?[widget.endPointName]?['data']),
                              widget.filter?.filterField,
                              widget.filter?.filterString,
                              widget.filter?.equal);
                          if (_searchKeyValue != null &&
                              result.data?[widget.endPointName]?['data']
                                  .isEmpty) {
                            noSearchResults = true;
                          } else {
                            noSearchResults = false;
                          }

                          if (SettingsService.use.isEmptyOrNull(repositories) &&
                              !noSearchResults) {
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
                                variables: {
                                  'pageableParam': {
                                    "page": (nextPage! - 1),
                                    "size": size ?? _initialSize,
                                  },
                                  ...otherParams ?? {}
                                },
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
                                  'pageableParam': {
                                    "searchParam": searchKey,
                                    "size": size ?? _initialSize,
                                  },
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

                        return DataSourceTable(
                            title: '',
                            primaryAction: widget.primaryAction,
                            serialNumberTitle: 'SN',
                            loadingOnUpdateData: result.isLoading,
                            headTileItems: widget.headColumns,
                            deleteData:
                                widget.deleteEndPointName?.isNotEmpty ?? false,
                            filter: widget.filter,
                            onDelete: (rowData) {
                              dataTableController.onDeleteLoad.value = true;

                              GraphQLService.mutate(
                                  successMessage: 'Record Deleted Successfully',
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
                                            widget.deleteUidFieldName ?? 'uid',
                                        inputType: 'String',
                                        fieldValue: rowData['uid'])
                                  ]);
                            },
                            tableColor: Theme.of(context).cardColor,
                            actionButton: widget.actionButtons ?? [],
                            noSearchResults: noSearchResults,
                            onEmptySearch: () {
                              if (noSearchResults) {
                                _searchKeyValue = null;
                                refetch!();
                                noSearchResults = false;
                              }
                            },
                            onSearch: (searchKey) {
                              _searchKeyValue = searchKey;
                              fetchMore!(refetchOptions(searchKey: searchKey));
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
                                          color: Theme.of(context).primaryColor,
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
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ));
                            }),
                            currentPageSize: _initialSize,
                            onPageSize: (value) {
                              _initialSize = value;
                              fetchMore!(refetchOptions(
                                  size: value, searchKey: _searchKeyValue));
                            },
                            actionTitle: 'Action',
                            paginatePage: PaginatePage(
                              currentPage: result.data?[widget.endPointName]
                                      ?['currentPage'] ??
                                  1,
                              currentPageColors: Theme.of(context).primaryColor,
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
                            dataList: repositories
                                    ?.map((e) => toMapFunction(e))
                                    .toList() ??
                                []);
                      },
                    );
                  }));
            }
            return const Center(
              child: Text('Nothing'),
            );
          });
    });
  }

  Map<String, dynamic> toMapFunction(Map<String, dynamic> item) {
    if (widget.mapFunction != null) {
      return {...item, ...widget.mapFunction!(item)};
    }

    return item;
  }
}

class TopActivityButton {
  final Function() onTap;
  final String? buttonName;
  final IconData? iconData;
  final String? toolTip;
  final List<String> permissions;

  TopActivityButton(
      {required this.onTap,
      this.buttonName,
      this.iconData,
      this.toolTip,
      required this.permissions})
      : assert((iconData == null || buttonName == null),
            'One of Fields must be provided');
}
