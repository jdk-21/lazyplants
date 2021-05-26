import {
  repository,
} from '@loopback/repository';
import {
  param,
  get,
  getModelSchemaRef,
} from '@loopback/rest';
import {
  Data,
  Plant,
} from '../models';
import {DataRepository} from '../repositories';

export class DataPlantController {
  constructor(
    @repository(DataRepository)
    public dataRepository: DataRepository,
  ) { }

  @get('/data/{id}/plant', {
    responses: {
      '200': {
        description: 'Plant belonging to Data',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(Plant)},
          },
        },
      },
    },
  })
  async getPlant(
    @param.path.string('id') id: typeof Data.prototype.dataId,
  ): Promise<Plant> {
    return this.dataRepository.plant(id);
  }
}
