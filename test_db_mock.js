// Mock test for database functions without actual pg dependency
console.log('Testing database function structure...');

const mockClient = {
  connect: (callback) => {
    console.log('Mock: Connected to PostgreSQL database');
    callback(null);
  },
  query: (sql, values, callback) => {
    console.log('Mock: Executing query:', sql);
    console.log('Mock: With values:', values);
    callback(null, { rows: [{ id: 1, email: 'test@example.com' }] });
  },
  end: () => {
    console.log('Mock: Connection closed');
  }
};

const mockClientClass = function() {
  return mockClient;
};

const originalRequire = require;
require = function(module) {
  if (module === 'pg') {
    return { Client: mockClientClass };
  }
  return originalRequire(module);
};

const { getUsers, insertUser } = require('./db_utils');

console.log('\n=== Testing getUsers function ===');
getUsers((err, users) => {
  if (err) {
    console.error('Error getting users:', err);
  } else {
    console.log('Success! Users retrieved:', users);
  }
});

setTimeout(() => {
  console.log('\n=== Testing insertUser function ===');
  const newUser = { email: 'newuser@example.com' };
  
  insertUser(newUser, (err, insertedUser) => {
    if (err) {
      console.error('Error inserting user:', err);
    } else {
      console.log('Success! User inserted:', insertedUser);
    }
  });
}, 1000);
