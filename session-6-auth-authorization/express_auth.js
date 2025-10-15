const express = require('express')
const { checkCredentials, addUser, generateToken } = require('./inMemoryUserRepository')

const app = express()
const port = 3005

app.use(express.json())

const authenticatedUsers = {}

function headersMiddleware(req, res, next) {
  console.log('=== HEADERS ===')
  console.log('Authorization:', req.headers.authorization)
  console.log('Content-Type:', req.headers['content-type'])
  console.log('User-Agent:', req.headers['user-agent'])
  console.log('================')
  next()
}

function firewallMiddleware(req, res, next) {
  const unprotectedUrls = [
    '/',
    '/authenticate',
    '/register',
    '/public'
  ]
  
  const requestedUrl = req.path
  
  console.log(`Vérification de l'URL: ${requestedUrl}`)
  
  if (unprotectedUrls.includes(requestedUrl)) {
    console.log('URL non protégée - accès autorisé')
    return next()
  }
  
  const authHeader = req.headers.authorization
  if (!authHeader) {
    console.log('Aucun token fourni - accès refusé')
    return res.status(403).json({ error: 'Token d\'autorisation requis' })
  }
  
  const token = authHeader.replace('Bearer ', '')
  
  if (!authenticatedUsers[token]) {
    console.log('Token invalide - accès refusé')
    return res.status(403).json({ error: 'Token invalide' })
  }
  
  console.log('Token valide - accès autorisé')
  req.user = authenticatedUsers[token]
  next()
}

app.use(headersMiddleware)
app.use(firewallMiddleware)

app.get('/', (req, res) => {
  res.json({ message: 'Bienvenue sur l\'API d\'authentification' })
})

app.get('/public', (req, res) => {
  res.json({ message: 'Cette route est publique' })
})

app.post('/authenticate', (req, res) => {
  const { email, password } = req.body
  
  if (!email || !password) {
    return res.status(400).json({ error: 'Email et mot de passe requis' })
  }
  
  console.log(`Tentative de connexion pour: ${email}`)
  
  const user = checkCredentials(email, password)
  
  if (!user) {
    console.log('Identifiants invalides')
    return res.status(403).json({ error: 'Identifiants invalides' })
  }
  
  const token = generateToken()
  
  authenticatedUsers[token] = {
    id: user.id,
    email: user.email,
    role: user.role
  }
  
  console.log(`Utilisateur ${email} authentifié avec le token: ${token}`)
  
  res.json({
    message: 'Authentification réussie',
    token: token,
    user: {
      id: user.id,
      email: user.email,
      role: user.role
    }
  })
})

app.post('/register', (req, res) => {
  const { email, password, role = 'user' } = req.body
  
  if (!email || !password) {
    return res.status(400).json({ error: 'Email et mot de passe requis' })
  }
  
  const existingUser = checkCredentials(email, password)
  if (existingUser) {
    return res.status(409).json({ error: 'Utilisateur déjà existant' })
  }
  
  const newUser = addUser(email, password, role)
  
  console.log(`Nouvel utilisateur inscrit: ${email}`)
  
  res.status(201).json({
    message: 'Utilisateur inscrit avec succès',
    user: {
      id: newUser.id,
      email: newUser.email,
      role: newUser.role
    }
  })
})

app.get('/protected', (req, res) => {
  res.json({
    message: 'Cette route est protégée',
    user: req.user
  })
})

app.get('/admin', (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Accès admin requis' })
  }
  
  res.json({
    message: 'Zone admin',
    user: req.user
  })
})

app.get('/profile', (req, res) => {
  res.json({
    message: 'Profil utilisateur',
    user: req.user
  })
})

app.get('/users', (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Accès admin requis' })
  }
  
  res.json({
    authenticatedUsers: Object.values(authenticatedUsers),
    total: Object.keys(authenticatedUsers).length
  })
})

app.post('/logout', (req, res) => {
  const authHeader = req.headers.authorization
  if (authHeader) {
    const token = authHeader.replace('Bearer ', '')
    if (authenticatedUsers[token]) {
      delete authenticatedUsers[token]
      console.log(`Utilisateur déconnecté: ${token}`)
    }
  }
  
  res.json({ message: 'Déconnexion réussie' })
})

app.listen(port, () => {
  console.log(`Serveur d'authentification démarré sur le port ${port}`)
  console.log(`\n=== ROUTES DISPONIBLES ===`)
  console.log(`GET  /                    - Page d'accueil (public)`)
  console.log(`GET  /public              - Route publique`)
  console.log(`POST /authenticate        - Se connecter`)
  console.log(`POST /register            - S'inscrire`)
  console.log(`GET  /protected           - Route protégée`)
  console.log(`GET  /admin               - Zone admin`)
  console.log(`GET  /profile             - Profil utilisateur`)
  console.log(`GET  /users               - Liste des utilisateurs (admin)`)
  console.log(`POST /logout              - Se déconnecter`)
  console.log(`\n=== UTILISATEURS DE TEST ===`)
  console.log(`admin@test.com / admin123 (admin)`)
  console.log(`user@test.com / user123 (user)`)
  console.log(`demo@test.com / demo123 (user)`)
})
