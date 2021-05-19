import {Entity, model, property} from '@loopback/repository';

@model({
  settings: {
    foreignKeys: {
      fk_PlantData_userId: {
        name: 'fk_PlantData_userId',
        entity: 'User',
        entityKey: 'id',
        foreignKey: 'userId',
        onDelete: 'cascade',
      },
      fk_PlantData_plantId: {
        name: 'fk_PlantData_plantId',
        entity: 'Plant',
        entityKey: 'id',
        foreignKey: 'plantId',
        onDelete: 'cascade',
      },
    },
  },
})
export class PlantData extends Entity {
  @property({
    type: 'string',
    id: true,
    generated: true,
  })
  id?: string;

  @property({
    type: 'string',
    required: true,
  })
  espId: string;

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
    type: 'boolean',
  })
  water?: boolean;

  @property({
    type: 'date',
    required: true,
  })
  measuringTime: string;

  @property({
    type: 'string',
  })
  userId?: string;

  @property({
    type: 'string',
  })
  plantId?: string;

  constructor(data?: Partial<PlantData>) {
    super(data);
  }
}

export interface PlantDataRelations {
  // describe navigational properties here
}

export type PlantDataWithRelations = PlantData & PlantDataRelations;
