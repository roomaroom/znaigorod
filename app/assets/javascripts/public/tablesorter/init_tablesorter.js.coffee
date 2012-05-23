@init_tablesorter = () ->
  tables = $('.sortable')

  tables.each ->
    $this = $(this)

    $this.tablesorter
      cssHeader: 'theader'
      cssAsc:    'sort_asc'
      cssDesc:   'sort_desc'
      sortList:  [[0,0]]
