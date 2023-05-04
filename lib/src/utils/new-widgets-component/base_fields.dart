String pageableBaseFields = '''
        currentPage
        pages
        numberOfElements
        message
        status
        size
  ''';

String baseResponseFields = '''
    message
    status
''';

// String pageableFields = '\$size: Int, \$page: Int, \$searchKey: String,';
String pageableFields = '\$pageableParam: PageableParamInput,';

// String pageableValue = 'size: \$size, page:\$page, searchKey:\$searchKey,';
String pageableValue = 'pageableParam: \$pageableParam';
