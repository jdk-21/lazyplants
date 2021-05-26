import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {MySqlDataSource} from '../datasources';
import {Plant, PlantRelations} from '../models';

export class PlantRepository extends DefaultCrudRepository<
  Plant,
  typeof Plant.prototype.plantId,
  PlantRelations
> {
  constructor(
    @inject('datasources.MySQL') dataSource: MySqlDataSource,
  ) {
    super(Plant, dataSource);
  }
}
