import {authenticate} from '@loopback/authentication';
import {inject} from '@loopback/core';
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
import {Data} from '../models';
import {DataRepository} from '../repositories';
import {SecurityBindings, securityId, UserProfile} from '@loopback/security';

export class DataController {
  constructor(
    @repository(DataRepository)
    public dataRepository : DataRepository,
  ) {}

  @post('/data')
  @response(200, {
    description: 'Data model instance',
    content: {'application/json': {schema: getModelSchemaRef(Data, {exclude: ['userId']})}},
  })
  @authenticate('jwt')
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Data, {
            title: 'NewData',
            exclude: ['dataId', 'userId'],
          }),
        },
      },
    })
    data: Omit<Data, 'dataId'>,
    @inject(SecurityBindings.USER)
    currentUserProfile: UserProfile,
  ): Promise<Data> {
    const userId = currentUserProfile[securityId];
    data.userId = userId;
    return this.dataRepository.create(data);
  }

  @get('/data/count')
  @response(200, {
    description: 'Data model count',
    content: {'application/json': {schema: CountSchema}},
  })
  @authenticate('jwt')
  async count(
    @param.where(Data) where?: Where<Data>,
  ): Promise<Count> {
    return this.dataRepository.count(where);
  }

  @get('/data')
  @response(200, {
    description: 'Array of Data model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(Data, {includeRelations: true}),
        },
      },
    },
  })
  @authenticate('jwt')
  async find(
    //@param.filter(Data) filter?: Filter<Data>,
    @inject(SecurityBindings.USER)
    currentUserProfile: UserProfile,
  ): Promise<Data[]> {
    //return this.dataRepository.find(filter);
    const userId = currentUserProfile[securityId];
    return this.dataRepository.find({where: {userId: userId}});
  }

  @patch('/data')
  @response(200, {
    description: 'Data PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  @authenticate('jwt')
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Data, {partial: true}),
        },
      },
    })
    data: Data,
    @param.where(Data) where?: Where<Data>,
  ): Promise<Count> {
    return this.dataRepository.updateAll(data, where);
  }

  @get('/data/{id}')
  @response(200, {
    description: 'Data model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(Data, {includeRelations: true}),
      },
    },
  })
  @authenticate('jwt')
  async findById(
    @param.path.string('id') id: string,
    @param.filter(Data, {exclude: 'where'}) filter?: FilterExcludingWhere<Data>
  ): Promise<Data> {
    return this.dataRepository.findById(id, filter);
  }

  @patch('/data/{id}')
  @response(204, {
    description: 'Data PATCH success',
  })
  @authenticate('jwt')
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Data, {partial: true}),
        },
      },
    })
    data: Data,
  ): Promise<void> {
    await this.dataRepository.updateById(id, data);
  }

  @put('/data/{id}')
  @response(204, {
    description: 'Data PUT success',
  })
  @authenticate('jwt')
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() data: Data,
  ): Promise<void> {
    await this.dataRepository.replaceById(id, data);
  }

  @del('/data/{id}')
  @response(204, {
    description: 'Data DELETE success',
  })
  @authenticate('jwt')
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.dataRepository.deleteById(id);
  }
}
