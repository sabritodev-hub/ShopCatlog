import { createRouter, createWebHistory } from 'vue-router'
import CatalogPage from '@/pages/CatalogPage.vue'
import AdminPage from '@/pages/AdminPage.vue'
import LoginPage from '@/pages/LoginPage.vue'
import CategoriesPage from '@/pages/CategoriesPage.vue'
import { getSession } from '@/services/authService.js'

const routes = [
  {
    path: '/',
    name: 'Catalog',
    component: CatalogPage,
    meta: {
      title: 'Catalogue - ShopCatalog'
    }
  },
  {
    path: '/login',
    name: 'Login',
    component: LoginPage,
    meta: {
      title: 'Connexion - ShopCatalog'
    }
  },
  {
    path: '/admin',
    name: 'Admin',
    component: AdminPage,
    meta: {
      title: 'Administration - ShopCatalog',
      requiresAuth: true
    }
  },
  {
    path: '/admin/categories',
    name: 'Categories',
    component: CategoriesPage,
    meta: {
      title: 'Catégories - ShopCatalog',
      requiresAuth: true
    }
  },
  // Redirection 404 vers le catalogue
  {
    path: '/:pathMatch(.*)*',
    redirect: '/'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  }
})

// Guard pour protéger les routes admin
router.beforeEach(async (to, from, next) => {
  document.title = to.meta.title || 'ShopCatalog'
  
  // Vérifier si la route nécessite une authentification
  if (to.meta.requiresAuth) {
    const session = await getSession()
    
    if (!session) {
      // Rediriger vers la page de connexion
      next({ name: 'Login', query: { redirect: to.fullPath } })
      return
    }
  }
  
  // Si l'utilisateur est connecté et essaie d'accéder à /login
  if (to.name === 'Login') {
    const session = await getSession()
    if (session) {
      next({ name: 'Admin' })
      return
    }
  }
  
  next()
})

export default router
