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
  Data,
} from '../models';
import {UserRepository} from '../repositories';

export class UserDataController {
  constructor(
    @repository(UserRepository) protected userRepository: UserRepository,
  ) { }

  @get('/users/{id}/data', {
    responses: {
      '200': {
        description: 'Array of User has many Data',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(Data)},
          },
        },
      },
    },
  })
  async find(
    @param.path.string('id') id: string,
    @param.query.object('filter') filter?: Filter<Data>,
  ): Promise<Data[]> {
    return this.userRepository.data(id).find(filter);
  }

  @post('/users/{id}/data', {
    responses: {
      '200': {
        description: 'User model instance',
        content: {'application/json': {schema: getModelSchemaRef(Data)}},
      },
    },
  })
  async create(
    @param.path.string('id') id: typeof User.prototype.userId,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Data, {
            title: 'NewDataInUser',
            exclude: ['dataId'],
            optional: ['userId']
          }),
        },
      },
    }) data: Omit<Data, 'dataId'>,
  ): Promise<Data> {
    return this.userRepository.data(id).create(data);
  }

  @patch('/users/{id}/data', {
    responses: {
      '200': {
        description: 'User.Data PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async patch(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Data, {partial: true}),
        },
      },
    })
    data: Partial<Data>,
    @param.query.object('where', getWhereSchemaFor(Data)) where?: Where<Data>,
  ): Promise<Count> {
    return this.userRepository.data(id).patch(data, where);
  }

  @del('/users/{id}/data', {
    responses: {
      '200': {
        description: 'User.Data DELETE success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async delete(
    @param.path.string('id') id: string,
    @param.query.object('where', getWhereSchemaFor(Data)) where?: Where<Data>,
  ): Promise<Count> {
    return this.userRepository.data(id).delete(where);
  }
}
