import {inject, Getter} from '@loopback/core';
import {DefaultCrudRepository, repository, BelongsToAccessor} from '@loopback/repository';
import {MySqlDataSource} from '../datasources';
import {Data, DataRelations, Plant} from '../models';
import {PlantRepository} from './plant.repository';

export class DataRepository extends DefaultCrudRepository<
  Data,
  typeof Data.prototype.dataId,
  DataRelations
> {

  public readonly plant: BelongsToAccessor<Plant, typeof Data.prototype.dataId>;

  constructor(
    @inject('datasources.MySQL') dataSource: MySqlDataSource, @repository.getter('PlantRepository') protected plantRepositoryGetter: Getter<PlantRepository>,
  ) {
    super(Data, dataSource);
    this.plant = this.createBelongsToAccessorFor('plant', plantRepositoryGetter,);
    this.registerInclusionResolver('plant', this.plant.inclusionResolver);
  }
}
