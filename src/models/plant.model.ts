import {Entity, model, property} from '@loopback/repository';

@model()
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
    required: true,
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
