Ext.define('WardenWeb.store.test_run_jobs', {
  extend: 'Ext.data.Store',
  model: 'WardenWeb.model.test_run_job',
  pageSize: 100,
  remoteSort: true,
  proxy: {
    type: 'ajax',
    url: '/test_run_job/get_test_run_job_with_tc_info.json',
    reader: {
      type: 'json',
      root: 'collection',
      totalProperty: 'total'
    }
  }
});
