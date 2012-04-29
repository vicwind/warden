Ext.require('Ext.chart.*');
Ext.require('Ext.layout.container.Fit');
Ext.require('Ext.tip.QuickTip');
      
var colors = ['#880000',
              '#008800'];

Ext.define('Ext.chart.theme.Fancy', {
    extend: 'Ext.chart.theme.Base',
    constructor: function(config) {
        this.callParent([Ext.apply({
            colors: colors
        }, config)]);
    }
});

Ext.onReady(function () {

  Ext.QuickTips.init();

  var production_chart = Ext.create('Ext.chart.Chart', {
      width: 790,
      height: 480,
      xtype: 'chart',
      animate: true,
      theme: 'Fancy',
      shadow: true,
      store: production_store,
      legend: {
                   position: 'right'
               },
      axes: [{
          type: 'Numeric',
          position: 'left',
          fields: ['failed','passed'],
          title: 'Instance Status',
          grid: true,
          minorTickSteps: 1,
          majorTickSteps: 10,
          minimum: 0
      }, {
          type: 'Category',
          position: 'bottom',
          fields: ['instance'],
          title: 'Instance Name',
          label: { rotate: { degrees: 270 } }
      }],
      series: [{
          type: 'column',
          axis: 'bottom',
          gutter: 80,
          stacked: true,
          xField: 'instance',
          yField: ['failed','passed'],
          tips: {
              trackMouse: true,
              width: 150,
              height: 85,
              renderer: function(storeItem, item) {
                  this.setTitle(storeItem.get('instance')+ '<br />' +'Passed: '+storeItem.get('passed') + '<br />' + 'Failed: ' + storeItem.get('failed')+'<br />'+'(Click for Trend)');
              }
          },
          listeners:{
              itemmousedown : function(obj) {
                parent.location='/test_case/project/'+obj.storeItem.data['id'];
              }
          }
      }]
  });

  var staging_chart = Ext.create('Ext.chart.Chart', {
      width: 790,
      height: 480,
      xtype: 'chart',
      animate: true,
      theme: 'Fancy',
      shadow: true,
      store: staging_store,
      legend: {
                   position: 'right'
               },
      axes: [{
          type: 'Numeric',
          position: 'left',
          fields: ['failed','passed'],
          title: 'Instance Status',
          grid: true,
          minorTickSteps: 1,
          majorTickSteps: 10,
          minimum: 0
      }, {
          type: 'Category',
          position: 'bottom',
          fields: ['instance'],
          title: 'Instance Name',
          label: { rotate: { degrees: 270 } }
      }],
      series: [{
          type: 'column',
          axis: 'bottom',
          gutter: 80,
          stacked: true,
          xField: 'instance',
          yField: ['failed','passed'],
          tips: {
              trackMouse: true,
              width: 150,
              height: 85,
              renderer: function(storeItem, item) {
                  this.setTitle(storeItem.get('instance')+ '<br />' +'Passed: '+storeItem.get('passed') + '<br />' + 'Failed: ' + storeItem.get('failed')+'<br />'+'(Click for Trend)');
              }
          },
          listeners:{
              itemmousedown : function(obj) {
                parent.location='/test_case/project/'+obj.storeItem.data['id'];
              }
          }
      }]
  });

  var qa_chart = Ext.create('Ext.chart.Chart', {
      width: 790,
      height: 480,
      xtype: 'chart',
      animate: true,
      theme: 'Fancy',
      shadow: true,
      store: qa_store,
      legend: {
                   position: 'right'
               },
      axes: [{
          type: 'Numeric',
          position: 'left',
          fields: ['failed','passed'],
          title: 'Instance Status',
          grid: true,
          minorTickSteps: 1,
          majorTickSteps: 10,
          minimum: 0
      }, {
          type: 'Category',
          position: 'bottom',
          fields: ['instance'],
          title: 'Instance Name',
          label: { rotate: { degrees: 270 } }
          
      }],
      series: [{
          type: 'column',
          axis: 'bottom',
          gutter: 80,
          stacked: true,
          xField: 'instance',
          yField: ['failed','passed'],
          tips: {
              trackMouse: true,
              width: 150,
              height: 85,
              renderer: function(storeItem, item) {
                  this.setTitle(storeItem.get('instance')+ '<br />' +'Passed: '+storeItem.get('passed') + '<br />' + 'Failed: ' + storeItem.get('failed')+'<br />'+'(Click for Trend)');
              }
          },
          listeners:{
              itemmousedown : function(obj) {
                parent.location='/test_case/project/'+obj.storeItem.data['id'];
              }
          }
      }]
  });
  
  var tab_panel = Ext.create('Ext.tab.Panel', {
          renderTo: 'tabs',
          width: 790,
          height: 480,
          activeTab: 0,
          deferredRender: false,
          layoutOnTabChange: true,
          flex: 1,
          border: false,
          defaults:{hideMode: 'offsets', layout: 'fit'},
          items: [
              {
                  id: 'production-chart',
                  title: 'Production Overall Status',
                  items: production_chart
              },{
                  id: 'staging-chart',
                  title: 'Staging Overall Status',
                  items: staging_chart
              },{
                  id: 'qa-chart',
                  title: 'QA Overall Status',
                  items: qa_chart
              }
              ]
      });     
});


