const express = require('express');
const { getUsers, insertUser } = require('./db_utils');

const app = express();
const port = 3001;

app.use(express.json());

app.get('/users', (req, res) => {
  getUsers((err, users) => {
    if (err) {
      res.status(500).json({ error: 'Database error', details: err.message });
    } else {
      res.json(users);
    }
  });
});

app.post('/users', (req, res) => {
  const { email } = req.body;
  
  if (!email) {
    return res.status(400).json({ error: 'Email is required' });
  }
  
  insertUser({ email }, (err, insertedUser) => {
    if (err) {
      res.status(500).json({ error: 'Database error', details: err.message });
    } else {
      res.status(201).json(insertedUser);
    }
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'Server is running' });
});

app.listen(port, () => {
  console.log(`Express server with database running on port ${port}`);
  console.log(`Health check: http://localhost:${port}/health`);
  console.log(`Get users: http://localhost:${port}/users`);
  console.log(`Add user: POST http://localhost:${port}/users`);
});
