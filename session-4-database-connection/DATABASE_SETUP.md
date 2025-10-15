# PostgreSQL Database Setup Instructions

## 1. Install PostgreSQL

### On macOS (using Homebrew):
```bash
brew install postgresql
brew services start postgresql
```

### On Ubuntu/Debian:
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

## 2. Create Database and Table

Connect to PostgreSQL:
```bash
psql -U postgres
```

Run these commands:
```sql
CREATE DATABASE mabase;
\c mabase;
CREATE TABLE "user" (id SERIAL PRIMARY KEY, email VARCHAR(80));
INSERT INTO "user" (email) VALUES ('email1@test.com');
INSERT INTO "user" (email) VALUES ('email2@test.com');
INSERT INTO "user" (email) VALUES ('email3@test.com');
\q
```

## 3. Install Node.js Dependencies

```bash
npm install
```

## 4. Set Environment Variables

### Option 1: Set in terminal session
```bash
export DB_USER=postgres
export DB_PWD=your_password_here
```

### Option 2: Create .env file
Create a `.env` file in the project root:
```
DB_USER=postgres
DB_PWD=your_password_here
```

## 5. Test the Connection

```bash
# Test environment variables
npm run test-env

# Test database functions
npm run test-db

# Run Express server with database
npm start
```

## 6. API Endpoints

When running `express_with_db.js`:

- `GET /health` - Health check
- `GET /users` - Get all users from database
- `POST /users` - Add new user (send JSON with email field)

## 7. Example API Usage

### Get all users:
```bash
curl http://localhost:3002/users
```

### Add a new user:
```bash
curl -X POST http://localhost:3002/users \
  -H "Content-Type: application/json" \
  -d '{"email": "newuser@example.com"}'
```

## Troubleshooting

1. **Connection refused**: Make sure PostgreSQL is running
2. **Authentication failed**: Check username and password
3. **Database does not exist**: Make sure you created the `mabase` database
4. **Table does not exist**: Make sure you created the `user` table
