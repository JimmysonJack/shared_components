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

String pageableFields = '\$size: Int, \$page: Int, \$searchKey: String,';

String pageableValue = 'size: \$size, page:\$page, searchKey:\$searchKey,';

