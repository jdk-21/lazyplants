import {Entity, model, property, hasMany} from '@loopback/repository';
import {PlantData} from './plant-data.model';

@model(  {
  settings: {
    foreignKeys: {
      fk_Plant_userId: {
        name: 'fk_Plant_userId',
        entity: 'User',
        entityKey: 'id',
        foreignKey: 'userId',
        onDelete: 'cascade',
      },
    },
  },
})
export class Plant extends Entity {
  @property({
    type: 'string',
    id: true,
    generated: true,
  })
  id?: string;

  @property({
    type: 'string',
  })
  plantName?: string;

  @property({
    type: 'date',
  })
  plantDate?: string;

  @property({
    type: 'string',
    required: true,
  })
  espId: string;

  @property({
    type: 'string',
  })
  room?: string;

  @property({
    type: 'number',
  })
  soilMoisture?: number;

  @property({
    type: 'number',
  })
  humidity?: number;

  @property({
    type: 'string',
  })
  userId?: string;

  @hasMany(() => PlantData)
  plantData: PlantData[];

  constructor(data?: Partial<Plant>) {
    super(data);
  }
}

export interface PlantRelations {
  // describe navigational properties here
}

export type PlantWithRelations = Plant & PlantRelations;
