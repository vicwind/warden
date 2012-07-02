Ext.define('WardenWeb.controller.test_cases', {
  extend: 'Ext.app.Controller',
  models: [
    'test_case', 'test_case_folder', 'app_env'
  ],
  stores: [
    'test_cases', 'test_case_folders', 'app_envs', 'test_case_searches'
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
    },
    {
      selector: 'test_case_folder_viewer',
      ref: 'testCaseFolder'
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
      },
      'test_case_viewer combo[name=search]': {
        'keyup': function(combo, e, opt) {
          console.log(e.keyCode);
          if(e.keyCode === 13){
            var filter_text = combo.getValue();
            var store = this.getTest_casesStore();
            store.filter([
              { property: 'feature_name', value: filter_text},
              { property: 'test_cases.name', value: filter_text},
              { property: 'warden_projects.name', value: filter_text}
            ]);
            store.filters.clear();
          }
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
    var test_case_folder = this.getTestCaseFolder();
    var suite_file_path = null;
    var selected_suite = null;
    var suite_files_selections = test_case_folder.getSelectionModel().getSelection();

    if(suite_files_selections.length > 0){
      selected_suite = test_case_folder.getSelectionModel().getSelection()[0];
      if (selected_suite.raw.suite_path != '')
        suite_file_path = selected_suite.raw.suite_path;
    }

    var selected_test_cases =
      this.getTestCaseGrid().getSelectionModel().getSelection();
    var str = "";
    var tc_ids = []
    for(var i = 0; i < selected_test_cases.length; i++){
      str += selected_test_cases[i].get("name") + "\n";
      tc_ids.push(selected_test_cases[i].get("tc_id"));
    }

    test_case_folder.getSelectionModel().deselectAll();

    if(suite_file_path)
      this.request_run_test_cases(suite_file_path);
    else if(selected_test_cases.length > 0)
      this.request_run_test_cases(tc_ids);
    else
      Ext.Msg.alert("Status:", 'Please select a test case or a suite file.');
  },
  request_run_test_cases: function(tc_ids_or_suite_file_path) {
    var app_env = this.getTestCaseGrid().
      query("combo[name='app_env']")[0].getValue();
    var job_name = this.getTestCaseGrid().
      query("textfield[name='job_name']")[0].getValue();

    if(this.is_array(tc_ids_or_suite_file_path)){
      var tc_ids = tc_ids_or_suite_file_path
      var msg =  'Total of ' + tc_ids.length + " test cases have been scheduled.";
    }else{
      var tc_ids = [];
      var suite_file_path = tc_ids_or_suite_file_path;
      var msg = 'Suite file "' + suite_file_path + '" has been scheduled.';
    }

    Ext.Ajax.request({
      url: '/test_case/run_test_job',
      params: {
        "tc_ids[]": tc_ids,
        suite_file_path: suite_file_path,
        app_environment: app_env,
        job_name: job_name,
      },
      success: function(response){
        var text = response.responseText;
        Ext.Msg.alert("Status:", msg)
        // process server response here
      },
      failure: function(response){
        Ext.Msg.show({
          title: "Status:",
          icon: Ext.Msg.ERROR,
          msg: "Server errors.",
          buttons: Ext.Msg.OK
        })
      }
    });
  },
  is_array: function (obj) {
    return Object.prototype.toString.apply(obj) === '[object Array]';
  }


});
