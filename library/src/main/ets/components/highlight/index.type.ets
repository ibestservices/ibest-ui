export interface Chunk {
  start: number;
  end: number;
  highlight: boolean;
}

export type Chunks = Array<Chunk>;