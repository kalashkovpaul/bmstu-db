import pgPromise from 'pg-promise'

const promise = pgPromise();
const  connectionURL = 'postgres://root:postgres@localhost:5432/postgres';
export const db = promise(connectionURL);
