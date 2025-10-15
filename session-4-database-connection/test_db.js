const { getUsers, insertUser } = require('./db_utils');

// Test function to get all users
console.log('Testing getUsers function...');
getUsers((err, users) => {
  if (err) {
    console.error('Error getting users:', err);
  } else {
    console.log('All users:', users);
  }
});

// Test function to insert a new user
setTimeout(() => {
  console.log('\nTesting insertUser function...');
  const newUser = {
    email: 'test@example.com'
  };
  
  insertUser(newUser, (err, insertedUser) => {
    if (err) {
      console.error('Error inserting user:', err);
    } else {
      console.log('User inserted successfully:', insertedUser);
    }
  });
}, 2000);
