import {inject, Getter} from '@loopback/core';
import {DefaultCrudRepository, repository, HasManyRepositoryFactory} from '@loopback/repository';
import {MongoDbDataSource} from '../datasources';
import {User, UserRelations, Plant, PlantData} from '../models';
import {PlantRepository} from './plant.repository';
import {PlantDataRepository} from './plant-data.repository';

export type Credentials = {
  email: string;
  password: string;
}

export class UserRepository extends DefaultCrudRepository<
  User,
  typeof User.prototype.id,
  UserRelations
> {

  public readonly plants: HasManyRepositoryFactory<Plant, typeof User.prototype.id>;

  public readonly plantData: HasManyRepositoryFactory<PlantData, typeof User.prototype.id>;

  constructor(
    @inject('datasources.MongoDB') dataSource: MongoDbDataSource, @repository.getter('PlantRepository') protected plantRepositoryGetter: Getter<PlantRepository>, @repository.getter('PlantDataRepository') protected plantDataRepositoryGetter: Getter<PlantDataRepository>,
  ) {
    super(User, dataSource);
    this.plantData = this.createHasManyRepositoryFactoryFor('plantData', plantDataRepositoryGetter,);
    this.registerInclusionResolver('plantData', this.plantData.inclusionResolver);
    this.plants = this.createHasManyRepositoryFactoryFor('plants', plantRepositoryGetter,);
    this.registerInclusionResolver('plants', this.plants.inclusionResolver);
  }
}
