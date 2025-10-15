const express = require('express')
const path = require('path')
const app = express()
const port = 3003

// 6. Mon premier middleware
function loggerMiddleware(request, response, next) {
  console.log('nouvelle requête entrante')
  next()
}

// 8. Test de l'ordre des middlewares
function loggerMiddleware2(request, response, next) {
  console.log('Body avant JSON parsing:', request.body)
  next()
}

// Ajouter le middleware logger AVANT express.json()
app.use(loggerMiddleware)
app.use(loggerMiddleware2)

// Middleware JSON
app.use(express.json())

// 10. Charger des fichiers statiques
app.use(express.static('public'))

// Routes
app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.get('/get-user/:userId', (req, res) => {
  const userId = req.params.userId
  console.log('User ID reçu:', userId)
  res.send(`<h1>ID de l'utilisateur : ${userId}</h1>`)
})

app.post('/data', (req, res) => {
  console.log('Body de la requête:', req.body)
  res.json(req.body)
})

app.get('/tasks', (req, res) => {
  res.json([])
})

app.listen(port, () => {
  console.log(`Express server with middleware running on port ${port}`)
  console.log(`Test middleware: http://localhost:${port}/`)
  console.log(`Test static files: http://localhost:${port}/index.html`)
})
