Ext.require('Ext.chart.*');
Ext.require(['Ext.Window', 'Ext.fx.target.Sprite', 'Ext.layout.container.Fit']);      

Ext.onReady(function () {
  var panel = Ext.create('widget.panel', {
    width: 790,
    height: 380,
    renderTo: Ext.Element.get('status-chart'),
    layout: 'fit',
    border:false,
    items: {
        xtype: 'chart',
        style: 'background:#fff',
        animate: true,
        store: store,
        shadow: true,
        legend: {
            position: 'right'
        },
        axes: [{
            type: 'Numeric',
            minimum: 0,
            position: 'left',
            fields: ['failed','passed'],
            title: 'Number of Scenarios',
            minorTickSteps: 1,
            majorTickSteps: 5,
            grid: {
              odd: {
                  opacity: 1,
                  fill: '#eee',
                  stroke: '#eee',
                  'stroke-width': 0.5
              }
            }                    
        }, {
            type: 'Category',
            position: 'bottom',
            fields: ['date'],
            title: 'Date',
            maximum: false,
            label: {
                rotate: {
                    degrees: 270
                }
            }
        }],
        series:
              [{
                  type: 'line',
                  highlight: {
                      size: 7,
                      radius: 7
                  },
                  axis: 'left',
                  xField: 'date',
                  yField: 'failed',
                  style: {
                    fill: '#B94A48',
                    stroke: '#B94A48',
                    'stroke-width': 2
                  },
                  markerConfig: {
                      type: 'circle',
                      size: 4,
                      radius: 4,
                      'stroke-width': 0,
                      fill: '#B94A48',
                      stroke: '#B94A48'
                  },
                  tips: {
                      trackMouse: true,
                      width: 70,
                      height: 32,
                      renderer: function(storeItem, item) {
                          this.setTitle(storeItem.get('failed')+" Failed");
                      }
                  }
              }, 
              {
                  type: 'line',
                  highlight: {
                      size: 7,
                      radius: 7
                  },
                  axis: 'left',
                  xField: 'date',
                  yField: 'passed',
                  style: {
                    fill: '#468847',
                    stroke: '#468847',
                    'stroke-width': 2                              
                  },
                  markerConfig: {
                      type: 'circle',
                      size: 4,
                      radius: 4,
                      'stroke-width': 0,
                      fill: '#468847',
                      stroke: '#468847'
                  },
                  tips: {
                      trackMouse: true,
                      width: 70,
                      height: 32,
                      renderer: function(storeItem, item) {
                          this.setTitle(storeItem.get('passed')+" Passed");
                      }
                  }
              }]
      }
  });
 
});

