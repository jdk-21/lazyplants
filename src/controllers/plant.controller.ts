import {
  Count,
  CountSchema,
  Filter,
  FilterExcludingWhere,
  repository,
  Where,
} from '@loopback/repository';
import {
  post,
  param,
  get,
  getModelSchemaRef,
  patch,
  put,
  del,
  requestBody,
  response,
} from '@loopback/rest';
import {Plant} from '../models';
import {PlantRepository} from '../repositories';

export class PlantController {
  constructor(
    @repository(PlantRepository)
    public plantRepository : PlantRepository,
  ) {}

  @post('/plants')
  @response(200, {
    description: 'Plant model instance',
    content: {'application/json': {schema: getModelSchemaRef(Plant)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Plant, {
            title: 'NewPlant',
            exclude: ['id'],
          }),
        },
      },
    })
    plant: Omit<Plant, 'id'>,
  ): Promise<Plant> {
    return this.plantRepository.create(plant);
  }

  @get('/plants/count')
  @response(200, {
    description: 'Plant model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(Plant) where?: Where<Plant>,
  ): Promise<Count> {
    return this.plantRepository.count(where);
  }

  @get('/plants')
  @response(200, {
    description: 'Array of Plant model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(Plant, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(Plant) filter?: Filter<Plant>,
  ): Promise<Plant[]> {
    return this.plantRepository.find(filter);
  }

  @patch('/plants')
  @response(200, {
    description: 'Plant PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Plant, {partial: true}),
        },
      },
    })
    plant: Plant,
    @param.where(Plant) where?: Where<Plant>,
  ): Promise<Count> {
    return this.plantRepository.updateAll(plant, where);
  }

  @get('/plants/{id}')
  @response(200, {
    description: 'Plant model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(Plant, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(Plant, {exclude: 'where'}) filter?: FilterExcludingWhere<Plant>
  ): Promise<Plant> {
    return this.plantRepository.findById(id, filter);
  }

  @patch('/plants/{id}')
  @response(204, {
    description: 'Plant PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Plant, {partial: true}),
        },
      },
    })
    plant: Plant,
  ): Promise<void> {
    await this.plantRepository.updateById(id, plant);
  }

  @put('/plants/{id}')
  @response(204, {
    description: 'Plant PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() plant: Plant,
  ): Promise<void> {
    await this.plantRepository.replaceById(id, plant);
  }

  @del('/plants/{id}')
  @response(204, {
    description: 'Plant DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.plantRepository.deleteById(id);
  }
}
