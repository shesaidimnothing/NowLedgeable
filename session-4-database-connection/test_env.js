console.log('Testing environment variables...');

console.log('DB_USER:', process.env.DB_USER || 'Not set');
console.log('DB_PWD:', process.env.DB_PWD || 'Not set');

if (!process.env.DB_USER) {
  process.env.DB_USER = 'postgres';
  console.log('Set DB_USER to default: postgres');
}

if (!process.env.DB_PWD) {
  process.env.DB_PWD = 'password';
  console.log('Set DB_PWD to default: password');
}

console.log('\nAfter setting defaults:');
console.log('DB_USER:', process.env.DB_USER);
console.log('DB_PWD:', process.env.DB_PWD);
