import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_ui/google_ui.dart';
import 'package:graphql/client.dart';
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
  ListDataTable({
    Key? key,
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
    this.progressOnMoreButton = false,
  }) : super(key: key) {
    Map mapVariables = {};
    Map inputVariables = {};
    String? inputVariable = '';
    String? mapVariable = '';

    if (inputs != null) {
      for (var element in inputs!) {
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
  query $endPointName$mapVariable{
    $endPointName$inputVariable{
        $baseResponseFields
        data{
           ${optionalResponseFields ?? queryFields}
        }
    }
}
  ''';
    GraphQLService.getService.endPoint = _endpoint;
    GraphQLService.getService.endPointName = endPointName;
  }

  final String endPointName;
  final String queryFields;
  final String? optionalResponseFields;
  final TableAddButton? tableAddButton;
  String? _endpoint;
  final List<OtherParameters>? inputs;
  final Map<String, dynamic> Function(Map<String, dynamic> item)? mapFunction;

  ///[ headColumns ] is used to provide heading and key to accessing data for the named column
  final List<HeardTitleItem> headColumns;
  final List<TopActivityButton>? topActivityButtons;
  final String? deleteEndPointName;
  final List<ActionButtonItem>? actionButtons;
  final bool progressOnMoreButton;
  final String? deleteUidFieldName;
  Map<String, dynamic>? otherParams = {};
  @override
  State<ListDataTable> createState() => _ListDataTableState();
}

class _ListDataTableState extends State<ListDataTable> {
  String? _searchKeyValue;
  bool _onDeleteLoading = false;
  int _initialSize = 20;
  List<Map<String, dynamic>> networkData = [];
  bool noSearchResults = false;

  @override
  void initState() {
    Toast.init(context);
    super.initState();
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
            if (snapshot.hasData) {
              return GraphQLProvider(
                client: snapshot.data,
                child: Query(
                  options: QueryOptions(
                    document: gql(widget._endpoint!),
                    variables: {
                      'searchKey': _searchKeyValue ?? '',
                      ...widget.otherParams ?? {}
                    },
                    fetchPolicy: FetchPolicy.cacheAndNetwork,
                    cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
                    errorPolicy: ErrorPolicy.all,
                  ),
                  builder: (QueryResult result,
                      {Refetch? refetch, FetchMore? fetchMore}) {
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
                            subtitle: 'Check your Internet connection first.',
                            buttonLabel:
                                widget.tableAddButton?.buttonName ?? '',
                            onPressed: widget.tableAddButton?.onPressed,
                          );
                        } else if (exception.runtimeType ==
                            HttpLinkServerException) {
                          HttpLinkServerException serverException =
                              exception as HttpLinkServerException;
                          var errorResponse = serverException
                              .parsedResponse!.response['message']
                              .split(':');
                          if (errorResponse[0] == "Invalid access token") {
                            return GErrorMessage(
                              icon: const Icon(Icons.vpn_key_off_outlined),
                              title: errorResponse[0],
                              buttonLabel:
                                  widget.tableAddButton?.buttonName ?? '',
                              onPressed: widget.tableAddButton?.onPressed,
                            );
                          }
                          return GErrorMessage(
                            icon: const Icon(Icons.block),
                            title: 'Something Is Wrong',
                            buttonLabel:
                                widget.tableAddButton?.buttonName ?? '',
                            onPressed: widget.tableAddButton?.onPressed,
                          );
                        }
                      } else {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (result.data?[widget.endPointName] == null) {
                            List errorsList = result.exception!.graphqlErrors;
                            NotificationService.errors(
                                title: 'GraphQL Errors!',
                                context: context,
                                contents: errorsList);
                          }
                        });

                        return GErrorMessage(
                          icon: const Icon(Icons.block),
                          title: 'Errors Occurred',
                          buttonLabel: widget.tableAddButton?.buttonName ?? '',
                          onPressed: widget.tableAddButton?.onPressed,
                        );
                      }
                    } else if (!result.isOptimistic) {
                      repositories = result.data?['getAgents']?['data'];
                      if (_searchKeyValue != null &&
                          result.data?[widget.endPointName]?['data'].isEmpty) {
                        noSearchResults = true;
                      } else {
                        noSearchResults = false;
                      }

                      if (repositories!.isEmpty) {
                        return GErrorMessage(
                          icon: const Icon(Icons.error),
                          title: 'No Data Yet',
                          buttonLabel: widget.tableAddButton?.buttonName ?? '',
                          onPressed: widget.tableAddButton?.onPressed,
                        );
                      }
                    }

                    FetchMoreOptions options({int? nextPage, int? size}) =>
                        FetchMoreOptions(
                            variables: {
                              "page": nextPage,
                              "size": size ?? _initialSize,
                              ...widget.otherParams ?? {}
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
                              "searchKey": searchKey,
                              "size": size ?? _initialSize,
                              ...widget.otherParams ?? {}
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
                    networkData =
                        repositories?.map((e) => toMapFunction(e)).toList() ??
                            [];
                    _initialSize = networkData.length;
                    searchLocalData();
                    return Observer(builder: (context) {
                      return DataSourceTable(
                          title: '',
                          serialNumberTitle: 'SN',
                          loadingOnUpdateData: result.isLoading,
                          heardTileItems: widget.headColumns,
                          deleteData:
                              widget.deleteEndPointName?.isNotEmpty ?? false,
                          onDelete: (rowData) {
                            setState(() {
                              _onDeleteLoading = true;
                            });
                            GraphQLService.mutate(
                                successMessage: 'Record Deleted Successfully',
                                context: context,
                                response: (results, isLoading) {
                                  setState(() {
                                    _onDeleteLoading = isLoading;
                                  });
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
                          onDeleteLoader: _onDeleteLoading,
                          noSearchResults: noSearchResults,
                          loadOnMoreButton: widget.progressOnMoreButton,
                          onEmptySearch: () {
                            if (noSearchResults) {
                              _searchKeyValue = null;
                              searchLocalData();
                              noSearchResults = false;
                            } else {
                              searchLocalData();
                            }
                          },
                          onSearch: (searchKey) {
                            _searchKeyValue = searchKey;
                            searchLocalData(searchKey: searchKey);
                            // fetchMore!(refetchOptions(searchKey: searchKey));
                          },
                          buttonActivities: List.generate(
                              widget.topActivityButtons?.length ?? 0, (index) {
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
                                          color: Theme.of(context).primaryColor,
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
                            currentPageColors: Theme.of(context).primaryColor,
                            pageSize:
                                result.data?[widget.endPointName]?['size'] ?? 0,
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
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return const Center(
                child: Text('Contact Administrator'),
              );
            }
            return const Center(
              child: Text('Something Is Wrong'),
            );
          });
    });
  }

  searchLocalData({String? searchKey}) {
    if (_searchKeyValue != null || _searchKeyValue != '') {
      UpdateTable.change.tableListData = networkData.where((e) {
        List<Map<String, dynamic>> list = [];
        for (var element in e.keys) {
          if (e[element]
              .toString()
              .toLowerCase()
              .contains(searchKey?.toLowerCase() ?? '')) {
            list.add(e);
          }
        }
        return list.isNotEmpty;
      }).toList();
      if (UpdateTable.change.tableListData.isEmpty) {
        noSearchResults = true;
      }
    } else {
      UpdateTable.change.tableListData = networkData;
    }
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
