import {authenticate} from '@loopback/authentication';
import {authorize} from '@loopback/authorization';
import {inject} from '@loopback/core';
import {
  Count,
  CountSchema,

  FilterExcludingWhere,
  repository,
  Where
} from '@loopback/repository';
import {
  del, get,
  getModelSchemaRef, param,


  patch, post,




  put,

  requestBody,
  response
} from '@loopback/rest';
import {SecurityBindings, securityId, UserProfile} from '@loopback/security';
import {UserServiceBindings} from '../keys';
import {basicAuthorization} from '../middlewares/auth.midd';
import {Data, User} from '../models';
import {DataRepository} from '../repositories';

export class DataController {
  constructor(
    @repository(DataRepository)
    public dataRepository: DataRepository,
  ) { }

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
    @inject(UserServiceBindings.USER_SERVICE)
    user: User,
    @inject(SecurityBindings.USER)
    currentUserProfile: UserProfile,
  ): Promise<Data[]> {
    //return this.dataRepository.find(filter);
    const userId = currentUserProfile[securityId];
    if (user.role == 'admin') {
      return this.dataRepository.find({where: {userId: {neq: ''}}});
    }
    return this.dataRepository.find({where: {userId: userId}});
  }

  @get('/dataplant/{id}/{limit}')
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
  async findmyplant(
    @inject(SecurityBindings.USER)
    currentUserProfile: UserProfile,
    @param.path.string('id') id: string,
    @param.path.string('limit') limit: number,
    @param.filter(Data, {exclude: 'where'}) filter?: FilterExcludingWhere<Data>,
  ): Promise<Data[]> {
    const userId = currentUserProfile[securityId];
    return this.dataRepository.find({limit: limit}, {where: {and: [{plantId: id}, {userId: userId}]}});
  }

  @patch('/data')
  @response(200, {
    description: 'Data PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  @authenticate('jwt')
  @authorize({
    allowedRoles: ['admin'],
    voters: [basicAuthorization],
  })
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
  @authorize({
    allowedRoles: ['admin'],
    voters: [basicAuthorization],
  })
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
  @authorize({
    allowedRoles: ['admin'],
    voters: [basicAuthorization],
  })
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
  @authorize({
    allowedRoles: ['admin'],
    voters: [basicAuthorization],
  })
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
  @authorize({
    allowedRoles: ['admin'],
    voters: [basicAuthorization],
  })
  @response(204, {
    description: 'Data DELETE success',
  })
  @authenticate('jwt')
  async deleteById(@param.path.string('id') id: string): Promise<void> {
    await this.dataRepository.deleteById(id);
  }
}
