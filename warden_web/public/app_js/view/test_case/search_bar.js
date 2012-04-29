Ext.define('WardenWeb.view.test_case.search_bar', {
  extend: 'Ext.form.ComboBox',
  alias: 'widget.test_case_search_bar',
  initComponent: function() {
    this.fieldLabel = 'Search';
    this.store = 'test_cases';
    this.queryMode = 'local';
    this.displayField = 'name';
    this.valueField = 'name';
    this.callParent(arguments);
  }
});

