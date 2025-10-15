const crypto = require('crypto');

const registeredUsers = [
  {
    id: 1,
    email: 'admin@test.com',
    password: 'admin123',
    role: 'admin'
  },
  {
    id: 2,
    email: 'user@test.com',
    password: 'user123',
    role: 'user'
  },
  {
    id: 3,
    email: 'demo@test.com',
    password: 'demo123',
    role: 'user'
  }
];

function getRegisteredUsers() {
  return registeredUsers;
}

function checkCredentials(email, password) {
  const user = registeredUsers.find(u => u.email === email && u.password === password);
  return user || null;
}

function addUser(email, password, role = 'user') {
  const newUser = {
    id: registeredUsers.length + 1,
    email,
    password,
    role
  };
  registeredUsers.push(newUser);
  return newUser;
}

function generateToken() {
  return crypto.randomUUID();
}

module.exports = {
  getRegisteredUsers,
  checkCredentials,
  addUser,
  generateToken
};
