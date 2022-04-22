const createLibraryEntry = '''
mutation(\$input: LibraryEntryCreateInput!){
  libraryEntry{
    create(input: \$input){
      libraryEntry{
        id
      }
      errors{
        message
      }
    }
  }
}
''';

const updateLibraryEntry = '''
mutation(\$input: LibraryEntryUpdateInput!){
  libraryEntry{
    update(input: \$input){
      libraryEntry{
        id
      }
      errors{
        message
      }
    }
  }
}
''';

const deleteLibraryEntry = '''
mutation(\$input: GenericDeleteInput!){
  libraryEntry{
    delete(input: \$input){
      libraryEntry{
        id
      }
      errors{
        message
      }
    }
  }
}
''';