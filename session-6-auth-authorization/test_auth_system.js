const axios = require('axios');

const BASE_URL = 'http://localhost:3005';

async function testAuthSystem() {
  console.log('🧪 Test du système d\'authentification\n');
  
  try {
    // 1. Test route publique
    console.log('1. Test route publique...');
    const publicResponse = await axios.get(`${BASE_URL}/`);
    console.log('✅ Route publique:', publicResponse.data.message);
    
    // 2. Test route protégée sans token
    console.log('\n2. Test route protégée sans token...');
    try {
      await axios.get(`${BASE_URL}/protected`);
    } catch (error) {
      console.log('✅ Accès refusé (attendu):', error.response.data.error);
    }
    
    // 3. Test authentification
    console.log('\n3. Test authentification...');
    const authResponse = await axios.post(`${BASE_URL}/authenticate`, {
      email: 'admin@test.com',
      password: 'admin123'
    });
    const token = authResponse.data.token;
    console.log('✅ Authentification réussie, token:', token.substring(0, 8) + '...');
    
    // 4. Test route protégée avec token
    console.log('\n4. Test route protégée avec token...');
    const protectedResponse = await axios.get(`${BASE_URL}/protected`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log('✅ Accès autorisé:', protectedResponse.data.message);
    console.log('   Utilisateur:', protectedResponse.data.user.email);
    
    // 5. Test zone admin
    console.log('\n5. Test zone admin...');
    const adminResponse = await axios.get(`${BASE_URL}/admin`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log('✅ Accès admin:', adminResponse.data.message);
    
    // 6. Test inscription
    console.log('\n6. Test inscription...');
    const registerResponse = await axios.post(`${BASE_URL}/register`, {
      email: 'test@example.com',
      password: 'test123'
    });
    console.log('✅ Inscription réussie:', registerResponse.data.message);
    
    // 7. Test avec utilisateur normal
    console.log('\n7. Test avec utilisateur normal...');
    const userAuthResponse = await axios.post(`${BASE_URL}/authenticate`, {
      email: 'user@test.com',
      password: 'user123'
    });
    const userToken = userAuthResponse.data.token;
    console.log('✅ Connexion utilisateur normal:', userAuthResponse.data.user.email);
    
    // 8. Test accès admin avec utilisateur normal
    console.log('\n8. Test accès admin avec utilisateur normal...');
    try {
      await axios.get(`${BASE_URL}/admin`, {
        headers: { Authorization: `Bearer ${userToken}` }
      });
    } catch (error) {
      console.log('✅ Accès admin refusé (attendu):', error.response.data.error);
    }
    
    // 9. Test déconnexion
    console.log('\n9. Test déconnexion...');
    const logoutResponse = await axios.post(`${BASE_URL}/logout`, {}, {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log('✅ Déconnexion:', logoutResponse.data.message);
    
    // 10. Test token invalide après déconnexion
    console.log('\n10. Test token invalide après déconnexion...');
    try {
      await axios.get(`${BASE_URL}/protected`, {
        headers: { Authorization: `Bearer ${token}` }
      });
    } catch (error) {
      console.log('✅ Token invalide (attendu):', error.response.data.error);
    }
    
    console.log('\n🎉 Tous les tests sont passés avec succès !');
    
  } catch (error) {
    console.error('❌ Erreur lors des tests:', error.message);
    if (error.response) {
      console.error('   Détails:', error.response.data);
    }
  }
}

// Lancer les tests si le script est exécuté directement
if (require.main === module) {
  testAuthSystem();
}

module.exports = testAuthSystem;
