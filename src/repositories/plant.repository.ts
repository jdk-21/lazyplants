import {inject, Getter} from '@loopback/core';
import {DefaultCrudRepository, repository, HasManyRepositoryFactory} from '@loopback/repository';
import {MongoDbDataSource} from '../datasources';
import {Plant, PlantRelations, PlantData} from '../models';
import {PlantDataRepository} from './plant-data.repository';

export class PlantRepository extends DefaultCrudRepository<
  Plant,
  typeof Plant.prototype.id,
  PlantRelations
> {

  public readonly plantData: HasManyRepositoryFactory<PlantData, typeof Plant.prototype.id>;

  constructor(
    @inject('datasources.MongoDB') dataSource: MongoDbDataSource, @repository.getter('PlantDataRepository') protected plantDataRepositoryGetter: Getter<PlantDataRepository>,
  ) {
    super(Plant, dataSource);
    this.plantData = this.createHasManyRepositoryFactoryFor('plantData', plantDataRepositoryGetter,);
    this.registerInclusionResolver('plantData', this.plantData.inclusionResolver);
  }
}
