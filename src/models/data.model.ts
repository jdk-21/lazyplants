import {Entity, model, property} from '@loopback/repository';

@model()
export class Data extends Entity {
  @property({
    type: 'string',
    id: true,
    generated: false,
    defaultFn: 'uuidv4',
  })
  dataId?: string;

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
