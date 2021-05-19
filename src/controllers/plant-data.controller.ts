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
import {PlantData} from '../models';
import {PlantDataRepository} from '../repositories';

export class PlantDataController {
  constructor(
    @repository(PlantDataRepository)
    public plantDataRepository : PlantDataRepository,
  ) {}

  @post('/PlantData')
  @response(200, {
    description: 'PlantData model instance',
    content: {'application/json': {schema: getModelSchemaRef(PlantData)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PlantData, {
            title: 'NewPlantData',
            exclude: ['id'],
          }),
        },
      },
    })
    plantData: Omit<PlantData, 'id'>,
  ): Promise<PlantData> {
    return this.plantDataRepository.create(plantData);
  }

  @get('/PlantData/count')
  @response(200, {
    description: 'PlantData model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(PlantData) where?: Where<PlantData>,
  ): Promise<Count> {
    return this.plantDataRepository.count(where);
  }

  @get('/PlantData')
  @response(200, {
    description: 'Array of PlantData model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(PlantData, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(PlantData) filter?: Filter<PlantData>,
  ): Promise<PlantData[]> {
    return this.plantDataRepository.find(filter);
  }

  @patch('/PlantData')
  @response(200, {
    description: 'PlantData PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PlantData, {partial: true}),
        },
      },
    })
    plantData: PlantData,
    @param.where(PlantData) where?: Where<PlantData>,
  ): Promise<Count> {
    return this.plantDataRepository.updateAll(plantData, where);
  }

  @get('/PlantData/{id}')
  @response(200, {
    description: 'PlantData model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(PlantData, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.string('id') id: string,
    @param.filter(PlantData, {exclude: 'where'}) filter?: FilterExcludingWhere<PlantData>
  ): Promise<PlantData> {
    return this.plantDataRepository.findById(id, filter);
  }

  @patch('/PlantData/{id}')
  @response(204, {
    description: 'PlantData PATCH success',
  })
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PlantData, {partial: true}),
        },
      },
    })
    plantData: PlantData,
  ): Promise<void> {
    await this.plantDataRepository.updateById(id, plantData);
  }

  @put('/PlantData/{id}')
  @response(204, {
    description: 'PlantData PUT success',
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() plantData: PlantData,
  ): Promise<void> {
    await this.plantDataRepository.replaceById(id, plantData);
  }

  @del('/PlantData/{id}')
  @response(204, {
    description: 'PlantData DELETE success',
  })
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.plantDataRepository.deleteById(id);
  }
}
