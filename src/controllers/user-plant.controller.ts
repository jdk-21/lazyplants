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
  Plant,
} from '../models';
import {UserRepository} from '../repositories';

export class UserPlantController {
  constructor(
    @repository(UserRepository) protected userRepository: UserRepository,
  ) { }

  @get('/users/{id}/plants', {
    responses: {
      '200': {
        description: 'Array of User has many Plant',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(Plant)},
          },
        },
      },
    },
  })
  async find(
    @param.path.string('id') id: string,
    @param.query.object('filter') filter?: Filter<Plant>,
  ): Promise<Plant[]> {
    return this.userRepository.plant(id).find(filter);
  }

  @post('/users/{id}/plants', {
    responses: {
      '200': {
        description: 'User model instance',
        content: {'application/json': {schema: getModelSchemaRef(Plant)}},
      },
    },
  })
  async create(
    @param.path.string('id') id: typeof User.prototype.userId,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Plant, {
            title: 'NewPlantInUser',
            exclude: ['plantId'],
            optional: ['userId']
          }),
        },
      },
    }) plant: Omit<Plant, 'plantId'>,
  ): Promise<Plant> {
    return this.userRepository.plant(id).create(plant);
  }

  @patch('/users/{id}/plants', {
    responses: {
      '200': {
        description: 'User.Plant PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async patch(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Plant, {partial: true}),
        },
      },
    })
    plant: Partial<Plant>,
    @param.query.object('where', getWhereSchemaFor(Plant)) where?: Where<Plant>,
  ): Promise<Count> {
    return this.userRepository.plant(id).patch(plant, where);
  }

  @del('/users/{id}/plants', {
    responses: {
      '200': {
        description: 'User.Plant DELETE success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async delete(
    @param.path.string('id') id: string,
    @param.query.object('where', getWhereSchemaFor(Plant)) where?: Where<Plant>,
  ): Promise<Count> {
    return this.userRepository.plant(id).delete(where);
  }
}
