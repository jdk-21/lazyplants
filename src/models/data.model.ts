import {Entity, model, property, belongsTo} from '@loopback/repository';
import {Plant} from './plant.model';

@model({
  settings: {
    foreignKeys: {
      fk_Data_userId: {
        name: 'fk_Data_userId',
        entity: 'User',
        entityKey: 'userId',
        foreignKey: 'userId',
        onUpdate: 'restrict',
        onDelete: 'cascade',
      },
      fk_Data_plantId: {
        name: 'fk_Data_plantId',
        entity: 'Plant',
        entityKey: 'plantId',
        foreignKey: 'plantId',
        onUpdate: 'restrict',
        onDelete: 'cascade',
      },
    },
  },
})
export class Data extends Entity {
  @property({
    type: 'string',
    id: true,
    generated: false,
    defaultFn: 'uuidv4',
  })
  dataId?: string;

  @belongsTo(() => Plant)
  plantId: string;

  @property({
    type: 'string',
  })
  userId?: string;

  @property({
    type: 'number',
  })
  soilMoisture?: number;

  @property({
    type: 'number',
  })
  humidity?: number;

  @property({
    type: 'number',
  })
  temperature?: number;

  @property({
    type: 'number',
  })
  watertank?: number;

  @property({
    type: 'date',
    required: true,
  })
  measuringTime: string;

  @property({
    type: 'boolean',
    required: true,
  })
  water: boolean;

  constructor(data?: Partial<Data>) {
    super(data);
  }
}

export interface DataRelations {
  // describe navigational properties here
}

export type DataWithRelations = Data & DataRelations;
