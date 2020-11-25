'use strict';

module.exports = function(Plants) {

    Plants.allMyPlants = function (req, callback) {
        var userId = req.accessToken.userId;
        var filter = {"where":{"memberId": userId}};
        Plants.find(filter, function (err, Plants) {
          if (err !== null) {
            callback(err);
          }
          callback(null, Plants);
        });
    }

    Plants.remoteMethod('allMyPlants', {
        "accepts": { arg: 'req', type: 'object', http: {source: 'req'}},
        "returns": { arg: 'allMyPlants', type: 'Plants' },
        "http": {"verb": "get", "path": "/allMyPlants"},
    });

    Plants.doublefilter = function (req, callback, room) {
      var userId = req.accessToken.userId;
      var filter = {"where":{"and":[{"memberId": userId}, {"room": room}]}};
      Plants.find(filter, function (err, Plants) {
        if (err !== null) {
          callback(err);
        }
        callback(null, Plants);
      });
      };

  Plants.remoteMethod('doublefilter', {
      "accepts": { arg: 'req', type: 'object', http: {source: 'req'}},
      "returns": { arg: 'result', type: 'string' },
      "http": {"verb": "get", "path": "/doublefilter"},
  });

  Plants.test = function (req) {
    var test = req;
    retrun (test);
    };

Plants.remoteMethod('test', {
    "accepts": { arg: 'req', type: 'object', http: {source: 'req'}},
    "returns": { arg: 'rest', type: 'string' },
    "http": {"verb": "get", "path": "/test"},
});



};
