// Generated by CoffeeScript 1.3.3
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['environ', 'mediator', 'jquery', 'underscore', 'backbone'], function(environ, mediator, $, _, Backbone) {
  var Table;
  Table = (function(_super) {

    __extends(Table, _super);

    function Table() {
      return Table.__super__.constructor.apply(this, arguments);
    }

    Table.prototype.template = _.template('\
            <div id="report-container">\
                <div id="report-alert" class="alert alert-block">\
                    <h4 class="alert-heading" data-alert-heading></h4>\
                    <span data-alert-message></span>\
                </div>\
                <table id="report-table" class="table table-striped">\
                    <div class="pinned-thead"></div>\
                    <thead></thead>\
                    <tbody></tbody>\
                </table>\
            </div>\
        ');

    Table.prototype.events = {
      'scroll': 'togglePinnedThead',
      'click tbody tr': 'highlightRow'
    };

    Table.prototype.initialize = function() {
      var _this = this;
      this.setElement(this.template());
      this.$table = this.$('table');
      this.$thead = this.$('thead');
      this.$tbody = this.$('tbody');
      this.$pinnedThead = this.$('.pinned-thead');
      return $(window).on('resize', function() {
        return _this.resizePinnedThead();
      });
    };

    Table.prototype.setBody = function(rows, append) {
      var data, html, i, row, _i, _j, _len, _len1;
      if (append == null) {
        append = false;
      }
      html = [];
      for (_i = 0, _len = rows.length; _i < _len; _i++) {
        row = rows[_i];
        html.push('<tr>');
        for (i = _j = 0, _len1 = row.length; _j < _len1; i = ++_j) {
          data = row[i];
          if (i === 0) {
            continue;
          }
          if (!data) {
            data = '<span class=no-data>(no data)</span>';
          }
          html.push("<td>" + data + "</td>");
        }
        html.push('</tr>');
      }
      if (append) {
        this.$tbody.append(html.join(''));
      } else {
        this.$tbody.html(html.join(''));
      }
      return this.resizePinnedThead();
    };

    Table.prototype.setHeader = function(header) {
      var data, html, pinned, _i, _len;
      html = ['<tr>'];
      pinned = [];
      for (_i = 0, _len = header.length; _i < _len; _i++) {
        data = header[_i];
        html.push("<th>" + data + "</th>");
        pinned.push("<div>" + data + "</div>");
      }
      html.push('</tr>');
      this.$thead.html(html.join(''));
      return this.$pinnedThead.html(pinned.join(''));
    };

    Table.prototype.resizePinnedThead = function() {
      var theadWidth,
        _this = this;
      theadWidth = this.$thead.width();
      return this.$thead.find('th').each(function(i, elem) {
        var $copy, $elem;
        $elem = $(elem);
        $copy = $(_this.$pinnedThead.children()[i]);
        return $copy.css('width', ($elem.width() / theadWidth * 100) + '%');
      });
    };

    Table.prototype.togglePinnedThead = function(event) {
      var scrollTop, visible;
      scrollTop = this.$el.scrollTop();
      visible = this.$pinnedThead.is(':visible');
      if (scrollTop <= 0 && visible) {
        return this.$pinnedThead.hide();
      } else if (!visible) {
        return this.$pinnedThead.show();
      }
    };

    Table.prototype.highlightRow = function(event) {
      var target;
      target = $(event.target).parent();
      return target.toggleClass('highlight');
    };

    return Table;

  })(Backbone.View);
  return Table;
});
