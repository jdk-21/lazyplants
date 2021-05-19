import {
  Count,
  CountSchema,
  Filter,
  repository,
  Where,
} from '@loopback/repository';
import {
  del,
  get,
  getModelSchemaRef,
  getWhereSchemaFor,
  param,
  patch,
  post,
  requestBody,
} from '@loopback/rest';
import {
  Plant,
  PlantData,
} from '../models';
import {PlantRepository} from '../repositories';

export class PlantPlantDataController {
  constructor(
    @repository(PlantRepository) protected plantRepository: PlantRepository,
  ) { }

  @get('/plants/{id}/plant-data', {
    responses: {
      '200': {
        description: 'Array of Plant has many PlantData',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(PlantData)},
          },
        },
      },
    },
  })
  async find(
    @param.path.string('id') id: string,
    @param.query.object('filter') filter?: Filter<PlantData>,
  ): Promise<PlantData[]> {
    return this.plantRepository.plantData(id).find(filter);
  }

  @post('/plants/{id}/plant-data', {
    responses: {
      '200': {
        description: 'Plant model instance',
        content: {'application/json': {schema: getModelSchemaRef(PlantData)}},
      },
    },
  })
  async create(
    @param.path.string('id') id: typeof Plant.prototype.id,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PlantData, {
            title: 'NewPlantDataInPlant',
            exclude: ['id'],
            optional: ['plantId']
          }),
        },
      },
    }) plantData: Omit<PlantData, 'id'>,
  ): Promise<PlantData> {
    return this.plantRepository.plantData(id).create(plantData);
  }

  @patch('/plants/{id}/plant-data', {
    responses: {
      '200': {
        description: 'Plant.PlantData PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async patch(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PlantData, {partial: true}),
        },
      },
    })
    plantData: Partial<PlantData>,
    @param.query.object('where', getWhereSchemaFor(PlantData)) where?: Where<PlantData>,
  ): Promise<Count> {
    return this.plantRepository.plantData(id).patch(plantData, where);
  }

  @del('/plants/{id}/plant-data', {
    responses: {
      '200': {
        description: 'Plant.PlantData DELETE success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async delete(
    @param.path.string('id') id: string,
    @param.query.object('where', getWhereSchemaFor(PlantData)) where?: Where<PlantData>,
  ): Promise<Count> {
    return this.plantRepository.plantData(id).delete(where);
  }
}
