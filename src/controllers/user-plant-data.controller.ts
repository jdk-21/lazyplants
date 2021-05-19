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
  User,
  PlantData,
} from '../models';
import {UserRepository} from '../repositories';

export class UserPlantDataController {
  constructor(
    @repository(UserRepository) protected userRepository: UserRepository,
  ) { }

  @get('/users/{id}/plant-data', {
    responses: {
      '200': {
        description: 'Array of User has many PlantData',
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
    return this.userRepository.plantData(id).find(filter);
  }

  @post('/users/{id}/plant-data', {
    responses: {
      '200': {
        description: 'User model instance',
        content: {'application/json': {schema: getModelSchemaRef(PlantData)}},
      },
    },
  })
  async create(
    @param.path.string('id') id: typeof User.prototype.id,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(PlantData, {
            title: 'NewPlantDataInUser',
            exclude: ['id'],
            optional: ['userId']
          }),
        },
      },
    }) plantData: Omit<PlantData, 'id'>,
  ): Promise<PlantData> {
    return this.userRepository.plantData(id).create(plantData);
  }

  @patch('/users/{id}/plant-data', {
    responses: {
      '200': {
        description: 'User.PlantData PATCH success count',
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
    return this.userRepository.plantData(id).patch(plantData, where);
  }

  @del('/users/{id}/plant-data', {
    responses: {
      '200': {
        description: 'User.PlantData DELETE success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async delete(
    @param.path.string('id') id: string,
    @param.query.object('where', getWhereSchemaFor(PlantData)) where?: Where<PlantData>,
  ): Promise<Count> {
    return this.userRepository.plantData(id).delete(where);
  }
}
