'use strict';

module.exports = function(PlantData) {

    PlantData.allMyData = function (req, callback) {
        var userId = req.accessToken.userId;
        var filter = {"where":{"memberId": userId}};
        PlantData.find(filter, function (err, PlantData) {
          if (err !== null) {
            callback(err);
          }
          callback(null, PlantData);
        });
    }

    PlantData.remoteMethod('allMyData', {
        "accepts": { arg: 'req', type: 'object', http: {source: 'req'}},
        "returns": { arg: 'allMyData', type: 'plant-data' },
        "http": {"verb": "get", "path": "/allMyData"},
    });

};
