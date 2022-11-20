import pgPromise from 'pg-promise'

const promise = pgPromise();
const  connectionURL = 'postgres://paul:paul@localhost:5432/middle-earth';
export const db = promise(connectionURL);
