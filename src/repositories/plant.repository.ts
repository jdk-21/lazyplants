import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {MongoDbDataSource} from '../datasources';
import {Plant, PlantRelations} from '../models';

export class PlantRepository extends DefaultCrudRepository<
  Plant,
  typeof Plant.prototype.id,
  PlantRelations
> {
  constructor(
    @inject('datasources.MongoDB') dataSource: MongoDbDataSource,
  ) {
    super(Plant, dataSource);
  }
}
