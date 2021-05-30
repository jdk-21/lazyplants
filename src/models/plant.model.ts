import {Entity, model, property} from '@loopback/repository';

@model({
  settings: {
    foreignKeys: {
      fk_Plant_userId: {
        name: 'fk_Plant_userId',
        entity: 'User',
        entityKey: 'userId',
        foreignKey: 'userId',
        onUpdate: 'restrict',
        onDelete: 'cascade',
      },
    },
  },
})
export class Plant extends Entity {
  @property({
    type: 'string',
    id: true,
    generated: false,
    defaultFn: 'uuidv4',
  })
  plantId?: string;

  @property({
    type: 'string',
  })
  userId?: string;

  @property({
    type: 'string',
    required: true,
    index: {
      unique: true
    }
  })
  espName: string;

  @property({
    type: 'string',
  })
  plantName: string;

  @property({
    type: 'date',
    required: true,
  })
  plantDate: string;

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

  constructor(data?: Partial<Plant>) {
    super(data);
  }
}

export interface PlantRelations {
  // describe navigational properties here
}

export type PlantWithRelations = Plant & PlantRelations;
