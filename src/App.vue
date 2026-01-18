<template>
  <div id="app">
    <!-- Navigation (cachée sur la page login) -->
    <nav v-if="!isLoginPage" class="main-nav">
      <div class="nav-container">
        <router-link to="/" class="nav-logo">
          <svg class="logo-icon-svg" width="32" height="32" viewBox="0 0 100 100">
            <defs>
              <linearGradient id="logoGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" style="stop-color:#6366f1;stop-opacity:1" />
                <stop offset="100%" style="stop-color:#8b5cf6;stop-opacity:1" />
              </linearGradient>
            </defs>
            <circle cx="50" cy="50" r="48" fill="url(#logoGrad)"/>
            <path d="M30 40 L30 75 C30 78 32 80 35 80 L65 80 C68 80 70 78 70 75 L70 40 Z" fill="white" opacity="0.95"/>
            <path d="M38 40 L38 32 C38 25 43 20 50 20 C57 20 62 25 62 32 L62 40" fill="none" stroke="white" stroke-width="4" stroke-linecap="round"/>
          </svg>
          <span class="logo-text">Bon plan 69</span>
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
        <p>&copy; 2026 Bon plan 69. Tous droits réservés.</p>
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
/* Navigation - Liquid Glass Style */
.main-nav {
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(20px) saturate(120%);
  -webkit-backdrop-filter: blur(20px) saturate(120%);
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
  position: sticky;
  top: 0;
  z-index: var(--z-index-sticky);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
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
  transition: all var(--transition-bounce);
}

.nav-logo:hover {
  transform: scale(1.02);
}

.logo-icon-svg {
  width: 32px;
  height: 32px;
  flex-shrink: 0;
}

.logo-text {
  font-size: var(--font-size-xl);
  font-weight: var(--font-weight-bold);
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
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
  border-radius: var(--radius-lg);
  text-decoration: none;
  color: var(--color-text-secondary);
  font-weight: var(--font-weight-medium);
  transition: all var(--transition-bounce);
  background: transparent;
  border: none;
}

.nav-link:hover {
  background: rgba(255, 255, 255, 0.8);
  color: var(--color-text-primary);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.nav-link-active {
  background: rgba(56, 189, 248, 0.12);
  color: var(--color-primary);
}

.nav-link-active:hover {
  background: rgba(56, 189, 248, 0.18);
  color: var(--color-primary);
}

/* Main Content */
.main-content {
  min-height: calc(100vh - var(--header-height) - 80px);
}

/* Footer - Liquid Glass Style */
.main-footer {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-top: 1px solid rgba(0, 0, 0, 0.06);
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
  color: var(--color-text-secondary);
}

/* Responsive */
@media (max-width: 640px) {
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
  color: #dc2626;
  background: rgba(239, 68, 68, 0.1);
}
</style>
