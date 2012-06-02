// Generated by CoffeeScript 1.3.3
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['environ', 'mediator', 'underscore', 'serrano'], function(environ, mediator, _, Serrano) {
  var DataContextHistory, DataContexts;
  DataContexts = (function(_super) {

    __extends(DataContexts, _super);

    function DataContexts() {
      return DataContexts.__super__.constructor.apply(this, arguments);
    }

    DataContexts.prototype.url = environ.absolutePath('/api/contexts/');

    DataContexts.prototype.initialize = function() {
      return this.deferred = this.fetch();
    };

    DataContexts.prototype.getNamed = function() {
      return this.filter(function(model) {
        return model.get('name');
      });
    };

    return DataContexts;

  })(Serrano.DataContexts);
  DataContextHistory = (function(_super) {

    __extends(DataContextHistory, _super);

    function DataContextHistory() {
      return DataContextHistory.__super__.constructor.apply(this, arguments);
    }

    DataContextHistory.prototype.url = environ.absolutePath('/api/contexts/history/', {
      initialize: function() {
        return this.deferred = this.fetch();
      }
    });

    return DataContextHistory;

  })(Serrano.DataContexts);
  App.DataContext = new DataContexts;
  App.DataContextHistory = new DataContextHistory;
  return App.DataContext.deferred.done(function() {
    var session;
    session = App.DataContext.getSession();
    if (!session) {
      session = App.DataContext.create({
        session: true
      });
    }
    return session.on('sync', function() {
      return mediator.publish('datacontext/change');
    });
  });
});
