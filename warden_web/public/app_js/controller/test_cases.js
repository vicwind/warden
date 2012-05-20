Ext.define('WardenWeb.controller.test_cases', {
  extend: 'Ext.app.Controller',
  models: [
    'test_case', 'test_case_folder', 'app_env'
  ],
  stores: [
    'test_cases', 'test_case_folders', 'app_envs'
  ],
  views: [
    'test_case.viewer',
    'test_case.folder_viewer',
    'test_case.search_bar'
  ],
  refs: [
    {
      selector: 'test_case_viewer',
      ref: 'testCaseGrid'
    }
  ],
  init: function() {
    this.control({
      'test_case_viewer': {
        'itemdblclick': this.test_event,
        'render': this.load_test_case
      },
      'test_case_viewer button[action=run_test_cases]': {
        'click' : this.run_test_cases
      },
      'test_case_viewer combo[name=app_env]': {
        'afterrender': function(combo) { combo.setValue('prd') }
      },
      'test_case_folder_viewer': {
        'select': function(smodel, node, index) {
          //alert("selected");
        }
      }
    });

    console.log('Initialized Utest_case_run_info_grid_viewersers! This happens before the Application launch function is called');
  },
  //custom define event handler
  test_event: function(view, record){
    alert("in test selected: " + record.data.name);
  },
  load_test_case: function(grid) {
    grid.store.load();
  },
  run_test_cases: function() {
    var selected_test_cases =
      this.getTestCaseGrid().getSelectionModel().getSelection();
    var str = "";
    var tc_ids = []
    for(var i = 0; i < selected_test_cases.length; i++){
      str += selected_test_cases[i].get("name") + "\n";
      tc_ids.push(selected_test_cases[i].get("tc_id"));
    }
    //Ext.Msg.alert('Status:', str);
    if(selected_test_cases.length > 0)
      this.request_run_test_cases(tc_ids);
    else
      Ext.Msg.alert("Status:", 'Please select a test case.');
  },
  request_run_test_cases: function(tc_ids) {
    var app_env = this.getTestCaseGrid().
      query("combo[name='app_env']")[0].getValue();
    var job_name = this.getTestCaseGrid().
      query("textfield[name='job_name']")[0].getValue();

    Ext.Ajax.request({
      url: '/test_case/run_test_job',
      params: {
        "tc_ids[]": tc_ids,
        app_environment: app_env,
        job_name: job_name,
      },
      success: function(response){
        var text = response.responseText;
        Ext.Msg.alert("Status:", tc_ids.length + " test cases have been scheduled.")
        // process server response here
      }
    });
  }

});
