Ext.define('WardenWeb.store.test_run_jobs', {
  extend: 'Ext.data.Store',
  model: 'WardenWeb.model.test_run_job',
  proxy: {
    type: 'ajax',
    url: '/test_run_job/index.json',
    reader: {
      type: 'json'
    }
  }
});
