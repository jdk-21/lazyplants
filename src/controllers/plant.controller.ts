import {authenticate} from '@loopback/authentication';
import {inject} from '@loopback/core';
import {authorize} from '@loopback/authorization';
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
  HttpErrors,
} from '@loopback/rest';
import {Plant, User} from '../models';
import {PlantRepository} from '../repositories';
import {SecurityBindings, securityId, UserProfile} from '@loopback/security';
import {basicAuthorization} from '../middlewares/auth.midd';
import _ from 'lodash';


export class PlantController {
  constructor(
    @repository(PlantRepository)
    public plantRepository: PlantRepository,
  ) { }

  @post('/plant')
  @response(200, {
    description: 'Plant model instance',
    content: {'application/json': {schema: getModelSchemaRef(Plant, {exclude: ['userId']})}},
  })
  @authenticate('jwt')
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Plant, {
            title: 'NewPlant',
            exclude: ['plantId', 'userId'],
          }),
        },
      },
    })
    plant: Omit<Plant, 'plantId'>,
    @inject(SecurityBindings.USER)
    currentUserProfile: UserProfile,
  ): Promise<Plant> {
    const userId = currentUserProfile[securityId];
    plant.userId = userId;
    return this.plantRepository.create(plant);
  }

  @get('/plant/count')
  @response(200, {
    description: 'Plant model count',
    content: {'application/json': {schema: CountSchema}},
  })
  @authenticate('jwt')
  @authorize({
    allowedRoles: ['admin'],
    voters: [basicAuthorization],
  })
  async count(
    @param.where(Plant) where?: Where<Plant>,
  ): Promise<Count> {
    return this.plantRepository.count(where);
  }

  @get('/plant')
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
  @authenticate('jwt')
  async find(
    //@param.filter(Plant) filter?: Filter<Plant>,
    @inject(SecurityBindings.USER)
    currentUserProfile: UserProfile,
  ): Promise<Plant[]> {
    //return this.plantRepository.find(filter);
    const userId = currentUserProfile[securityId];
    return this.plantRepository.find({where: {userId: userId}});
  }

  @patch('/plant')
  @response(200, {
    description: 'Plant PATCH success count',
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
          schema: getModelSchemaRef(Plant, {partial: true}),
        },
      },
    })
    plant: Plant,
    @param.where(Plant) where?: Where<Plant>,
  ): Promise<Count> {
    return this.plantRepository.updateAll(plant, where);
  }

  //ToDo
  @get('/plant/{id}')
  @response(200, {
    description: 'Plant model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(Plant, {includeRelations: true}),
      },
    },
  })
  @authenticate('jwt')
  async findById(
    @param.path.string('id') id: string,
    @param.filter(Plant, {exclude: 'where'}) filter?: FilterExcludingWhere<Plant>
  ): Promise<Plant> {
    return this.plantRepository.findById(id, filter);
  }

  @patch('/plant/{id}')
  @response(204, {
    description: 'Plant PATCH success',
    content: {'application/json': {schema: CountSchema}},
  })
  @authenticate('jwt')
  async updateById(
    @param.path.string('id') id: string,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Plant, {partial: true, exclude: ['userId', 'plantId']}),
        },
      },
    })
    plant: Plant,
    @inject(SecurityBindings.USER)
    currentUserProfile: UserProfile,
  ): Promise<void> {
    const userId = currentUserProfile[securityId];
    //console.log('PlantId:',id);
    //console.log('TokenId:', userId);
    const userIdOfPlantId = await this.plantRepository.find({where: {plantId: id}});
    //console.log('UserId:',userIdOfPlantId[0]['userId']);
    if (userId == userIdOfPlantId[0]['userId']) {
      plant.userId = userId;
      plant.plantId = id;
      await this.plantRepository.updateById(id, plant);
    } else {
      throw new HttpErrors.Unauthorized('Access Denied');
    }
  }

  @put('/plant/{id}')
  @response(204, {
    description: 'Plant PUT success',
  })
  @authenticate('jwt')
  @authorize({
    allowedRoles: ['admin'],
    voters: [basicAuthorization],
  })
  async replaceById(
    @param.path.string('id') id: string,
    @requestBody() plant: Plant,
  ): Promise<void> {
    await this.plantRepository.replaceById(id, plant);
  }

  @del('/plant/{id}')
  @response(204, {
    description: 'Plant DELETE success',
  })
  @authenticate('jwt')
  async deleteById(@param.path.string('id') id: string,
    @inject(SecurityBindings.USER)
    currentUserProfile: UserProfile,
  ): Promise<void> {
    const userId = currentUserProfile[securityId];
    const userIdOfPlantId = await this.plantRepository.find({where: {plantId: id}});
    if (userId == userIdOfPlantId[0]['userId']) {
      await this.plantRepository.deleteById(id);
    } else {
      throw new HttpErrors.Unauthorized('Access Denied');
    }
    await this.plantRepository.deleteById(id);
  }
}
