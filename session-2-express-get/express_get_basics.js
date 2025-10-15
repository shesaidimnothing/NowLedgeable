const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.get('/some-html', (req, res) => {
  res.send('<html><body><h1>bonjour html</h1></body></html>')
})

app.get('/some-json', (req, res) => {
  console.log('Headers de la requête:', req.headers)
  console.log('Body de la requête:', req.body)
  
  const person = {
    "age": 22,
    "nom": "Jane"
  }
  res.json(person)
})

app.get('/transaction', (req, res) => {
  const transactions = [100, 2000, 3000]
  res.json(transactions)
})

app.get('/exo-query-string', (req, res) => {
  console.log('Query parameters:', req.query)
  
  const age = req.query.age
  
  if (age) {
    res.send(`<h1>L'âge de la personne est : ${age}</h1>`)
  } else {
    res.send('hello')
  }
})

app.get('/get-user/:userId', (req, res) => {
  const userId = req.params.userId
  
  console.log('User ID reçu:', userId)
  
  res.send(`<h1>ID de l'utilisateur : ${userId}</h1>`)
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
  console.log(`\n=== ROUTES GET DISPONIBLES ===`)
  console.log(`GET  /                    - Hello World`)
  console.log(`GET  /some-html           - Page HTML`)
  console.log(`GET  /some-json           - Données JSON`)
  console.log(`GET  /transaction         - Liste de transactions`)
  console.log(`GET  /exo-query-string    - Test query parameters (?age=25)`)
  console.log(`GET  /get-user/:userId    - Test paramètres d'URL (/get-user/123)`)
})
