Ext.define('WardenWeb.controller.test_case_run_info', {
  extend: 'Ext.app.Controller',
  models: [
    'test_case', 'test_case_folder', 'test_case_run_info'
  ],
  stores: [
    'test_cases', 'test_case_folders', 'test_case_run_infos'
  ],
  views: [
    'test_case_run_info.grid_viewer'
  ],
  refs: [
    {
      selector: 'test_case_run_info_grid_viewer',
      ref: 'testCaseRunInfoGrid'
    }
  ],
  init: function() {
    this.control({
      'test_case_run_info_grid_viewer': {
        'render': this.load_test_case_run_infos
      }
    });

    console.log('Initialized test casr run info viewer');
  },
  //custom define event handler
  test_event: function(view, record){
    alert("in test selected: " + record.data.name);
  },
  load_test_case_run_infos: function(grid) {
    url_params = Ext.Object.fromQueryString(window.location.search);
    grid.store.load({ params : url_params });
  }

});

