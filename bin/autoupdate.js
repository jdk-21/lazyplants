//** Created by Dominik Klein */
'use strict';

const app = require('../server/server');
const ds = app.datasources.db;

ds.autoupdate(['Plants'], (err) => {
    if (err) {
        throw err;
    }
    console.log('----- !!! models synced !!! -----');
    ds.disconnect();
    process.exit();
});