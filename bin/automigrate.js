//** Created by Dominik Klein */
'use strict';

const app = require('../server/server');
const ds = app.datasources.db;

ds.automigrate(['PlantData'], (err) => {
    if (err) {
        throw err;
    }
    console.log('----- !!! models created !!! -----');
    ds.disconnect();
    process.exit();
});