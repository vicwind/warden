Ext.define('WardenWeb.controller.test_run_job', {
  extend: 'Ext.app.Controller',
  models: ['test_run_job'],
  stores: ['test_run_jobs'],
  views: ['test_run_job.viewer'],
  refs: [
    {
      selector: 'test_run_job_viewer',
      ref: 'testRunJobGrid'
    }
  ],
  init: function() {
    this.control({
      'test_run_job_viewer': {
        'render': this.load_test_run_jobs
        //'select': function() {alert("iam selected")}
      }
    });
    console.log("test_run_job controller is initialized!")
  },

  //instance methods of the object
  load_test_run_jobs: function(grid) {
    grid.store.load();
  }
});
