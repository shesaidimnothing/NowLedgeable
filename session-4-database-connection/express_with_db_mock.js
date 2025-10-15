const express = require('express');

const app = express();
const port = 3002;

// Middleware to parse JSON bodies
app.use(express.json());

// Mock database data
const mockUsers = [
  { id: 1, email: 'user1@test.com' },
  { id: 2, email: 'user2@test.com' },
  { id: 3, email: 'user3@test.com' }
];

// Route to get all users from database
app.get('/users', (req, res) => {
  console.log('Getting all users from mock database');
  res.json(mockUsers);
});

// Route to add a new user
app.post('/users', (req, res) => {
  const { email } = req.body;
  
  if (!email) {
    return res.status(400).json({ error: 'Email is required' });
  }
  
  const newUser = {
    id: mockUsers.length + 1,
    email: email
  };
  
  mockUsers.push(newUser);
  console.log('Added new user:', newUser);
  res.status(201).json(newUser);
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'Server is running with mock database' });
});

app.listen(port, () => {
  console.log(`Express server with mock database running on port ${port}`);
  console.log(`Health check: http://localhost:${port}/health`);
  console.log(`Get users: http://localhost:${port}/users`);
  console.log(`Add user: POST http://localhost:${port}/users`);
});
