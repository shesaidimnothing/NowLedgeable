const { Client } = require('pg');

function getConnection(username, password, database) {
  const client = new Client({
    host: 'localhost',
    port: 5432,
    database: database,
    user: username,
    password: password,
  });
  
  return client;
}

function getUsers(callback) {
  const client = getConnection(
    process.env.DB_USER || 'postgres', 
    process.env.DB_PWD || 'password', 
    'mabase'
  );
  
  client.connect((err) => {
    if (err) {
      console.error('Connection error:', err.stack);
      callback(err, null);
      return;
    }
    
    console.log('Connected to PostgreSQL database');
    
    client.query('SELECT * FROM "user"', (err, result) => {
      if (err) {
        console.error('Query error:', err.stack);
        callback(err, null);
      } else {
        console.log('Query result:', result.rows);
        callback(null, result.rows);
      }
      
      client.end();
    });
  });
}

function insertUser(user, callback) {
  const client = getConnection(
    process.env.DB_USER || 'postgres', 
    process.env.DB_PWD || 'password', 
    'mabase'
  );
  
  client.connect((err) => {
    if (err) {
      console.error('Connection error:', err.stack);
      callback(err, null);
      return;
    }
    
    console.log('Connected to PostgreSQL database for insert');
    
    const query = 'INSERT INTO "user" (email) VALUES ($1) RETURNING *';
    const values = [user.email];
    
    client.query(query, values, (err, result) => {
      if (err) {
        console.error('Insert error:', err.stack);
        callback(err, null);
      } else {
        console.log('User inserted successfully:', result.rows[0]);
        callback(null, result.rows[0]);
      }
      
      client.end();
    });
  });
}

module.exports = {
  getConnection,
  getUsers,
  insertUser
};
