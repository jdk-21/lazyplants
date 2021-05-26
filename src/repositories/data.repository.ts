import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {MySqlDataSource} from '../datasources';
import {Data, DataRelations} from '../models';

export class DataRepository extends DefaultCrudRepository<
  Data,
  typeof Data.prototype.dataId,
  DataRelations
> {
  constructor(
    @inject('datasources.MySQL') dataSource: MySqlDataSource,
  ) {
    super(Data, dataSource);
  }
}
