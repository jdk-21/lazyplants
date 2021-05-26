import {inject, Getter} from '@loopback/core';
import {DefaultCrudRepository, repository, HasManyRepositoryFactory} from '@loopback/repository';
import {MySqlDataSource} from '../datasources';
import {User, UserRelations, Plant, Data} from '../models';
import {PlantRepository} from './plant.repository';
import {DataRepository} from './data.repository';

export class UserRepository extends DefaultCrudRepository<
  User,
  typeof User.prototype.userId,
  UserRelations
> {

  public readonly plant: HasManyRepositoryFactory<Plant, typeof User.prototype.userId>;

  public readonly data: HasManyRepositoryFactory<Data, typeof User.prototype.userId>;

  constructor(
    @inject('datasources.MySQL') dataSource: MySqlDataSource, @repository.getter('PlantRepository') protected plantRepositoryGetter: Getter<PlantRepository>, @repository.getter('DataRepository') protected dataRepositoryGetter: Getter<DataRepository>,
  ) {
    super(User, dataSource);
    this.data = this.createHasManyRepositoryFactoryFor('data', dataRepositoryGetter,);
    this.registerInclusionResolver('data', this.data.inclusionResolver);
    this.plant = this.createHasManyRepositoryFactoryFor('plant', plantRepositoryGetter,);
    this.registerInclusionResolver('plant', this.plant.inclusionResolver);
  }
}
