const express = require('express')
const app = express()
const port = 3004

// Middleware 1: Logger avant JSON
function loggerBeforeJson(request, response, next) {
  console.log('=== AVANT express.json() ===')
  console.log('Body vide:', request.body)
  next()
}

// Middleware 2: Logger après JSON
function loggerAfterJson(request, response, next) {
  console.log('=== APRÈS express.json() ===')
  console.log('Body rempli:', request.body)
  next()
}

// Test 1: Logger AVANT express.json()
console.log('=== TEST 1: Logger AVANT express.json() ===')
app.use(loggerBeforeJson)
app.use(express.json())
app.use(loggerAfterJson)

app.post('/test-order', (req, res) => {
  console.log('=== DANS LA ROUTE ===')
  console.log('Body final:', req.body)
  res.json({ message: 'Test de l\'ordre des middlewares', body: req.body })
})

app.listen(port, () => {
  console.log(`Test middleware order on port ${port}`)
  console.log(`Test: POST http://localhost:${port}/test-order`)
})
