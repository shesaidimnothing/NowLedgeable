# 📚 Nowledgeable - Backend Node.js Course

This project contains all the exercises from the Node.js backend course, organized by sessions according to the curriculum.

## 📁 Project Structure

```
nowledgeable/
├── session-1-internet-web/           # Internet and web protocols
├── session-2-express-get/            # Express and GET requests
├── session-3-express-post/           # Express and POST methods
├── session-4-database-connection/    # Database connection introduction
├── session-5-middleware-static/      # Middleware and static files
├── session-6-auth-authorization/     # Authentication and authorization
└── README.md
```

## 🚀 Quick Start

Each session is independent and can be run separately:

### Session 2 - Express GET Requests
```bash
cd session-2-express-get
npm install
npm start
# Server runs on http://localhost:3000
```

### Session 3 - Express POST Methods
```bash
cd session-3-express-post
npm install
npm start
# Server runs on http://localhost:3001
```

### Session 4 - Database Connection
```bash
cd session-4-database-connection
npm install
# First setup PostgreSQL (see DATABASE_SETUP.md)
npm start
# Server runs on http://localhost:3002
```

### Session 5 - Middleware & Static Files
```bash
cd session-5-middleware-static
npm install
npm start
# Server runs on http://localhost:3003
# Test static files: http://localhost:3003/index.html
```

### Session 6 - Authentication & Authorization
```bash
cd session-6-auth-authorization
npm install
npm start
# Server runs on http://localhost:3005
# Test with Postman (see POSTMAN_TESTS.md)
```

## 📋 Session Details

### Session 2: Express GET Requests
- Basic Express server setup
- GET routes with different response types
- Query parameters handling
- URL parameters with `:userId`
- JSON responses

### Session 3: Express POST Methods
- POST endpoint implementation
- JSON body parsing with `express.json()`
- Echo server functionality
- Complete Todo List API (CRUD operations)
- Error handling and validation

### Session 4: Database Connection
- PostgreSQL connection with `pg` library
- Environment variables for credentials
- Database utility functions
- Express server with database integration
- User management endpoints

### Session 5: Middleware & Static Files
- Custom middleware creation
- Middleware execution order
- Static file serving with `express.static()`
- HTML and CSS file serving
- Request logging middleware

### Session 6: Authentication & Authorization
- Complete authentication system
- JWT-like token generation
- User registration and login
- Role-based access control
- Protected routes with middleware
- Session management

## 🧪 Testing

Each session includes comprehensive tests:

- **Manual testing** with curl commands
- **Postman collections** for API testing
- **Automated test scripts** where applicable
- **Database setup guides** for PostgreSQL

## 📊 Features Implemented

- ✅ Express.js server setup
- ✅ RESTful API design
- ✅ HTTP methods (GET, POST, PUT, DELETE)
- ✅ Middleware implementation
- ✅ Static file serving
- ✅ Database integration (PostgreSQL)
- ✅ Authentication system
- ✅ Authorization with roles
- ✅ Error handling
- ✅ Input validation
- ✅ Environment variables
- ✅ JSON parsing
- ✅ Query parameters
- ✅ URL parameters

## 🔧 Dependencies

- **Express.js** - Web framework
- **pg** - PostgreSQL client
- **crypto** - Token generation (Node.js built-in)
- **axios** - HTTP client for testing

## 📚 Learning Objectives

This project demonstrates:

1. **HTTP Protocol Understanding** - GET, POST, headers, status codes
2. **Express.js Framework** - Routing, middleware, static files
3. **Database Integration** - Connection, queries, data persistence
4. **Authentication** - Login, registration, token-based auth
5. **Authorization** - Role-based access control
6. **API Design** - RESTful principles, error handling
7. **Security** - Input validation, protected routes

## 🎯 Next Steps

After completing all sessions, you'll have a solid foundation in:

- Node.js backend development
- Express.js framework
- Database integration
- Authentication systems
- API design and security
- Middleware patterns
- Static file serving

Perfect for building real-world web applications! 🚀
