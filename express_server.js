const express = require('express')
const app = express()
const port = 3000

app.use(express.json())

let tasks = []

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

app.post('/data', (req, res) => {
  console.log('Body de la requête:', req.body)
  res.json(req.body)
})


app.get('/tasks', (req, res) => {
  res.json(tasks)
})

app.post('/new-task', (req, res) => {
  const { title, description, isDone } = req.body
  
  if (!title || !description) {
    return res.status(400).json({ error: 'Title and description are required' })
  }
  
  const newTask = {
    id: Date.now(), 
    title,
    description,
    isDone: isDone || false
  }
  
  tasks.push(newTask)
  res.status(201).json(newTask)
})

app.put('/update-task/:id', (req, res) => {
  const taskId = parseInt(req.params.id)
  const { title, description, isDone } = req.body
  
  const taskIndex = tasks.findIndex(task => task.id === taskId)
  
  if (taskIndex === -1) {
    return res.status(404).json({ error: 'Task not found' })
  }
  
  if (title !== undefined) tasks[taskIndex].title = title
  if (description !== undefined) tasks[taskIndex].description = description
  if (isDone !== undefined) tasks[taskIndex].isDone = isDone
  
  res.json(tasks[taskIndex])
})

app.delete('/delete-task/:id', (req, res) => {
  const taskId = parseInt(req.params.id)
  
  const taskIndex = tasks.findIndex(task => task.id === taskId)
  
  if (taskIndex === -1) {
    return res.status(404).json({ error: 'Task not found' })
  }
  
  const deletedTask = tasks.splice(taskIndex, 1)[0]
  res.json(deletedTask)
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
