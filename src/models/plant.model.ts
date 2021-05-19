import {Entity, model, property} from '@loopback/repository';

@model()
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


  constructor(data?: Partial<Plant>) {
    super(data);
  }
}

export interface PlantRelations {
  // describe navigational properties here
}

export type PlantWithRelations = Plant & PlantRelations;
