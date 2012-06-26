Ext.define('WardenWeb.view.test_case.search_bar', {
  extend: 'Ext.form.ComboBox',
  alias: 'widget.test_case_search_bar',
  initComponent: function() {
    this.name = 'search';
    this.width = 300,
    this.enableKeyEvents = true;
    this.fieldLabel = 'Search';
    this.store = 'test_case_searches';
    this.queryMode = 'local';
    this.displayField = 'name';
    this.valueField = 'name';
    this.hideTrigger = true;
    this.callParent(arguments);
  }
});

