Ext.define('WardenWeb.store.test_case_searches', {
  extend: 'Ext.data.Store',
  //model: 'WardenWeb.model.test_case',
  fields: ['name'],
  autoLoad:true,
  proxy: {
    type: 'ajax',
    url: '/test_case/test_case_search_suguession.json',
    reader: {
      type: 'json'
    }
  }

})

