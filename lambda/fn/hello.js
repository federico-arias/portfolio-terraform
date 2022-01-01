const { Client } = require('pg')
const client = new Client()

module.exports.handler = async (event) => {
  console.log('Event: ', event);
  let responseMessage = 'Hello, World!';

  if (event.queryStringParameters && event.queryStringParameters['Name']) {
    responseMessage = 'Hello, ' + event.queryStringParameters['Name'] + '!' + process.env.PSQL_CONN_STRING;
  }
  await client.connect()
  const res = await client.query('SELECT $1::text as message', ['Hello world!'])

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: res,
    }),
  }
}
