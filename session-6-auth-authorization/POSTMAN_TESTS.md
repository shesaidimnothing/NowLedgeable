# 🧪 Guide de Test Postman - Système d'Authentification

## 📋 Collection de Tests

### 1. **Route Publique** ✅
```
GET http://localhost:3005/
Headers: Aucun
Expected: {"message": "Bienvenue sur l'API d'authentification"}
```

### 2. **Route Protégée Sans Token** ❌
```
GET http://localhost:3005/protected
Headers: Aucun
Expected: 403 {"error": "Token d'autorisation requis"}
```

### 3. **Authentification** 🔐
```
POST http://localhost:3005/authenticate
Headers: Content-Type: application/json
Body: {
  "email": "admin@test.com",
  "password": "admin123"
}
Expected: 200 {"message": "Authentification réussie", "token": "...", "user": {...}}
```

### 4. **Route Protégée Avec Token** ✅
```
GET http://localhost:3005/protected
Headers: Authorization: Bearer [TOKEN_FROM_STEP_3]
Expected: 200 {"message": "Cette route est protégée", "user": {...}}
```

### 5. **Zone Admin** 👑
```
GET http://localhost:3005/admin
Headers: Authorization: Bearer [TOKEN_FROM_STEP_3]
Expected: 200 {"message": "Zone admin", "user": {...}}
```

### 6. **Inscription** 📝
```
POST http://localhost:3005/register
Headers: Content-Type: application/json
Body: {
  "email": "nouveau@test.com",
  "password": "nouveau123"
}
Expected: 201 {"message": "Utilisateur inscrit avec succès", "user": {...}}
```

### 7. **Test Utilisateur Normal** 👤
```
POST http://localhost:3005/authenticate
Headers: Content-Type: application/json
Body: {
  "email": "user@test.com",
  "password": "user123"
}
Expected: 200 {"message": "Authentification réussie", "token": "...", "user": {...}}
```

### 8. **Accès Admin avec Utilisateur Normal** ❌
```
GET http://localhost:3005/admin
Headers: Authorization: Bearer [TOKEN_USER_NORMAL]
Expected: 403 {"error": "Accès admin requis"}
```

### 9. **Profil Utilisateur** 👤
```
GET http://localhost:3005/profile
Headers: Authorization: Bearer [TOKEN]
Expected: 200 {"message": "Profil utilisateur", "user": {...}}
```

### 10. **Liste des Utilisateurs (Admin)** 📊
```
GET http://localhost:3005/users
Headers: Authorization: Bearer [TOKEN_ADMIN]
Expected: 200 {"authenticatedUsers": [...], "total": X}
```

### 11. **Déconnexion** 🚪
```
POST http://localhost:3005/logout
Headers: Authorization: Bearer [TOKEN]
Expected: 200 {"message": "Déconnexion réussie"}
```

### 12. **Token Invalide Après Déconnexion** ❌
```
GET http://localhost:3005/protected
Headers: Authorization: Bearer [TOKEN_DECONNECTE]
Expected: 403 {"error": "Token invalide"}
```

## 🔍 **Vérifications dans le Terminal**

Pendant les tests, vous devriez voir dans le terminal du serveur :

1. **Headers affichés** pour chaque requête
2. **Vérification des URLs** (protégées/non protégées)
3. **Messages d'authentification** (succès/échec)
4. **Logs de connexion/déconnexion**

## 📊 **Utilisateurs de Test**

| Email | Password | Role | Description |
|-------|----------|------|-------------|
| admin@test.com | admin123 | admin | Administrateur |
| user@test.com | user123 | user | Utilisateur normal |
| demo@test.com | demo123 | user | Utilisateur démo |

## 🎯 **Points Clés à Vérifier**

- ✅ Les routes publiques sont accessibles sans token
- ❌ Les routes protégées refusent l'accès sans token
- 🔐 L'authentification génère un token valide
- ✅ Les routes protégées acceptent l'accès avec token valide
- 👑 Seuls les admins accèdent à la zone admin
- 📝 L'inscription fonctionne et crée de nouveaux utilisateurs
- 🚪 La déconnexion invalide le token
- 📊 Les logs montrent le flux d'authentification
