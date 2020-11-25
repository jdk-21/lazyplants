'use strict';

module.exports = function(Plants) {

    Plants.allMyPlants = function async (req, callback) {
        var userId = req.accessToken.userId;
        var filter = {"where": {"memberId": userId}};
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


    Plants.MyPlants = function async (id, callback) {
        
        //var userId = req.accessToken.userId;
        var filter = {"where": {"id": id}};
        Plants.find(Plants.allMyPlants() & filter, function (err, Plants) {
          if (err !== null) {
            callback(err);
          }
          callback(null, Plants);
        });
    }

    Plants.remoteMethod('MyPlants', {
        "accepts": { arg: 'id',arg: 'req', type: 'string', arg: 'req', type: 'object', http: {source: 'req'}},
        "returns": { arg: 'MyPlants', type: 'Plants' },
        "http": {"verb": "get", "path": "/MyPlants"},
    });

};
