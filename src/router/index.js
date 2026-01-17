import { createRouter, createWebHistory } from 'vue-router'
import CatalogPage from '@/pages/CatalogPage.vue'
import AdminPage from '@/pages/AdminPage.vue'

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
    path: '/admin',
    name: 'Admin',
    component: AdminPage,
    meta: {
      title: 'Administration - ShopCatalog'
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

// Mise à jour du titre de la page
router.beforeEach((to, from, next) => {
  document.title = to.meta.title || 'ShopCatalog'
  next()
})

export default router
