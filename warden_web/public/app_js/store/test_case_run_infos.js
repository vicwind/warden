Ext.define('WardenWeb.store.test_case_run_infos', {
  extend: 'Ext.data.Store',
  model: 'WardenWeb.model.test_case_run_info',
  pageSize: 999999999,
  params:{
    start: 0,
    limit: 10,
    job_id: 10
  },
  proxy: {
    type: 'ajax',
    url: '/test_case_run_info/get_data_by_job_id.json',
    reader: {
      type: 'json'
    }
  }
  // data: [
  //   {feature_file: 'k.feature', scenario:'t1_test_input', line_number: 10 },
  //   {feature_file: 'k123.feature', scenario:'t2_test_input2', line_number: 10 },
  //   {feature_file: 'lol.feature', scenario:'t1_test_input', line_number: 5 },
  //   {feature_file: 'lol.feature', scenario:'t2_test_input2', line_number: 6 }
  // ]

})

