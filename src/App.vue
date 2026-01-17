<template>
  <div id="app">
    <!-- Navigation (cachée sur la page login) -->
    <nav v-if="!isLoginPage" class="main-nav">
      <div class="nav-container">
        <router-link to="/" class="nav-logo">
          <span class="logo-icon">🛒</span>
          <span class="logo-text">ShopCatalog</span>
        </router-link>
        
        <div class="nav-links">
          <router-link to="/" class="nav-link" active-class="nav-link-active">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <rect x="3" y="3" width="7" height="7"></rect>
              <rect x="14" y="3" width="7" height="7"></rect>
              <rect x="14" y="14" width="7" height="7"></rect>
              <rect x="3" y="14" width="7" height="7"></rect>
            </svg>
            <span>Catalogue</span>
          </router-link>
          
          <router-link v-if="!isAuthenticated" to="/login" class="nav-link" active-class="nav-link-active">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
              <polyline points="10 17 15 12 10 7"></polyline>
              <line x1="15" y1="12" x2="3" y2="12"></line>
            </svg>
            <span>Connexion</span>
          </router-link>
          
          <router-link v-if="isAuthenticated" to="/admin" class="nav-link" active-class="nav-link-active">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M12 20h9"></path>
              <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
            </svg>
            <span>Admin</span>
          </router-link>
          
          <button v-if="isAuthenticated" class="nav-link logout-btn" @click="handleLogout">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
              <polyline points="16 17 21 12 16 7"></polyline>
              <line x1="21" y1="12" x2="9" y2="12"></line>
            </svg>
            <span>Déconnexion</span>
          </button>
        </div>
      </div>
    </nav>
    
    <!-- Main Content -->
    <main class="main-content">
      <router-view />
    </main>
    
    <!-- Footer (caché sur la page login) -->
    <footer v-if="!isLoginPage" class="main-footer">
      <div class="footer-container">
        <p>&copy; 2026 ShopCatalog. Tous droits réservés.</p>
      </div>
    </footer>
  </div>
</template>

<script>
import { logout, onAuthStateChange, getSession } from '@/services/authService.js'

export default {
  name: 'App',
  data() {
    return {
      isAuthenticated: false,
      unsubscribe: null
    }
  },
  computed: {
    isLoginPage() {
      return this.$route.name === 'Login'
    }
  },
  async mounted() {
    // Vérifier la session initiale
    const session = await getSession()
    this.isAuthenticated = !!session
    
    // Écouter les changements d'authentification
    this.unsubscribe = onAuthStateChange((event, session) => {
      this.isAuthenticated = !!session
    })
  },
  beforeUnmount() {
    if (this.unsubscribe) {
      this.unsubscribe()
    }
  },
  methods: {
    async handleLogout() {
      await logout()
      this.$router.push('/')
    }
  }
}
</script>

<style>
/* Navigation */
.main-nav {
  background-color: var(--color-white);
  border-bottom: var(--border-width-thin) solid var(--color-border-light);
  position: sticky;
  top: 0;
  z-index: var(--z-index-sticky);
}

.nav-container {
  max-width: var(--container-max-width);
  margin: 0 auto;
  padding: 0 var(--spacing-4);
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: var(--header-height);
}

.nav-logo {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
  text-decoration: none;
  color: var(--color-text-primary);
}

.logo-icon {
  font-size: var(--font-size-2xl);
}

.logo-text {
  font-size: var(--font-size-xl);
  font-weight: var(--font-weight-bold);
}

.nav-links {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
}

.nav-link {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
  padding: var(--spacing-2) var(--spacing-4);
  border-radius: var(--border-radius-lg);
  text-decoration: none;
  color: var(--color-text-secondary);
  font-weight: var(--font-weight-medium);
  transition: all var(--transition-fast);
}

.nav-link:hover {
  background-color: var(--color-gray-100);
  color: var(--color-text-primary);
}

.nav-link-active {
  background-color: var(--color-primary-bg);
  color: var(--color-primary);
}

.nav-link-active:hover {
  background-color: var(--color-primary-bg);
  color: var(--color-primary);
}

/* Main Content */
.main-content {
  min-height: calc(100vh - var(--header-height) - 80px);
}

/* Footer */
.main-footer {
  background-color: var(--color-gray-800);
  color: var(--color-gray-400);
  padding: var(--spacing-6) var(--spacing-4);
}

.footer-container {
  max-width: var(--container-max-width);
  margin: 0 auto;
  text-align: center;
}

.footer-container p {
  margin: 0;
  font-size: var(--font-size-sm);
  color: var(--color-gray-400);
}

/* Responsive */
@media (max-width: 640px) {
  .logo-text {
    display: none;
  }
  
  .nav-link span {
    display: none;
  }
  
  .nav-link {
    padding: var(--spacing-3);
  }
}

/* Logout button */
.logout-btn {
  background: none;
  border: none;
  cursor: pointer;
  font-size: var(--font-size-base);
}

.logout-btn:hover {
  color: var(--color-danger);
  background-color: var(--color-danger-bg);
}
</style>
