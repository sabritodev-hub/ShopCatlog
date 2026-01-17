<template>
  <div class="admin-page">
    <header class="admin-header">
      <div class="header-content">
        <div class="header-main">
          <div>
            <h1>Administration</h1>
            <p class="header-subtitle">Gérez vos articles</p>
          </div>
          <div class="header-nav">
            <router-link to="/admin/categories" class="nav-link">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M4 4h6v6H4zM14 4h6v6h-6zM4 14h6v6H4zM14 14h6v6h-6z"/>
              </svg>
              Catégories
            </router-link>
          </div>
        </div>
      </div>
    </header>
    
    <!-- Actions bar -->
    <section class="admin-actions">
      <div class="actions-container">
        <div class="actions-left">
          <BaseInput
            v-model="searchQuery"
            placeholder="Rechercher..."
            size="md"
            :full-width="false"
            class="search-input"
          >
            <template #prefix>
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"></circle>
                <path d="m21 21-4.35-4.35"></path>
              </svg>
            </template>
          </BaseInput>
          
          <BaseSelect
            v-model="selectedCategory"
            :options="categoryOptions"
            placeholder="Toutes les catégories"
            :full-width="false"
            class="category-filter"
          />
        </div>
        
        <BaseButton variant="primary" @click="openAddModal">
          <template #icon>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="12" y1="5" x2="12" y2="19"></line>
              <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
          </template>
          Ajouter un article
        </BaseButton>
      </div>
    </section>
    
    <!-- Table -->
    <section class="admin-content">
      <div v-if="loading" class="loading-state">
        <p>Chargement des articles...</p>
      </div>
      
      <div v-else-if="filteredArticles.length === 0" class="empty-state">
        <p>Aucun article trouvé</p>
        <BaseButton variant="primary" @click="openAddModal">
          Ajouter votre premier article
        </BaseButton>
      </div>
      
      <div v-else class="table-container">
        <table class="articles-table">
          <thead>
            <tr>
              <th>Image</th>
              <th>Nom</th>
              <th>Catégorie</th>
              <th>Prix</th>
              <th>Stock</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="article in filteredArticles" :key="article.id">
              <td class="cell-image">
                <img :src="article.photo" :alt="article.nom" />
              </td>
              <td class="cell-name">{{ article.nom }}</td>
              <td>
                <BaseBadge :variant="getCategoryVariant(article.categorie)" size="sm" rounded>
                  {{ article.categorie }}
                </BaseBadge>
              </td>
              <td class="cell-price">{{ formatPrice(article.prix) }}</td>
              <td>
                <span :class="['stock-badge', getStockClass(article.quantite)]">
                  {{ article.quantite }}
                </span>
              </td>
              <td class="cell-actions">
                <BaseButton variant="ghost" size="sm" @click="openEditModal(article)">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                  </svg>
                </BaseButton>
                <BaseButton variant="ghost" size="sm" @click="confirmDelete(article)">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="text-danger">
                    <polyline points="3 6 5 6 21 6"></polyline>
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                  </svg>
                </BaseButton>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
    
    <!-- Form Modal -->
    <ArticleForm
      v-model="showFormModal"
      :article="selectedArticle"
      @submit="handleFormSubmit"
    />
    
    <!-- Delete Confirmation Modal -->
    <BaseModal
      v-model="showDeleteModal"
      title="Confirmer la suppression"
      size="sm"
    >
      <p>Êtes-vous sûr de vouloir supprimer l'article "{{ articleToDelete?.nom }}" ?</p>
      <p class="text-muted text-sm">Cette action est irréversible.</p>
      
      <template #footer>
        <BaseButton variant="ghost" @click="showDeleteModal = false">
          Annuler
        </BaseButton>
        <BaseButton variant="danger" :loading="deleting" @click="handleDelete">
          Supprimer
        </BaseButton>
      </template>
    </BaseModal>
  </div>
</template>

<script>
import { BaseButton, BaseInput, BaseSelect, BaseBadge, BaseModal } from '@/components/ui'
import ArticleForm from '@/components/articles/ArticleForm.vue'
import { 
  getArticles, 
  createArticle, 
  updateArticle, 
  deleteArticle 
} from '@/services/articleService.js'
import { getCategories } from '@/services/categoryService.js'

export default {
  name: 'AdminPage',
  components: {
    BaseButton,
    BaseInput,
    BaseSelect,
    BaseBadge,
    BaseModal,
    ArticleForm
  },
  data() {
    return {
      articles: [],
      categories: [],
      searchQuery: '',
      selectedCategory: '',
      loading: true,
      showFormModal: false,
      showDeleteModal: false,
      selectedArticle: null,
      articleToDelete: null,
      deleting: false
    }
  },
  computed: {
    categoryOptions() {
      return [
        { value: '', label: 'Toutes les catégories' },
        ...this.categories.map(cat => ({ value: cat.nom, label: cat.nom }))
      ]
    },
    filteredArticles() {
      let result = [...this.articles]
      
      if (this.searchQuery.trim()) {
        const query = this.searchQuery.toLowerCase()
        result = result.filter(article =>
          article.nom.toLowerCase().includes(query) ||
          (article.categorie && article.categorie.toLowerCase().includes(query))
        )
      }
      
      if (this.selectedCategory) {
        result = result.filter(article => article.categorie === this.selectedCategory)
      }
      
      return result
    }
  },
  async mounted() {
    await this.loadData()
  },
  methods: {
    async loadData() {
      this.loading = true
      try {
        const [articles, categories] = await Promise.all([
          getArticles(),
          getCategories()
        ])
        this.articles = articles
        this.categories = categories
      } catch (error) {
        console.error('Erreur lors du chargement des données:', error)
      } finally {
        this.loading = false
      }
    },
    formatPrice(price) {
      return new Intl.NumberFormat('fr-FR', {
        style: 'currency',
        currency: 'EUR'
      }).format(price)
    },
    getCategoryVariant(category) {
      const variants = {
        'Électronique': 'primary',
        'Chaussures': 'secondary',
        'Accessoires': 'info',
        'Vêtements': 'warning',
        'Mobilier': 'success'
      }
      return variants[category] || 'default'
    },
    getStockClass(quantity) {
      if (quantity === 0) return 'stock-empty'
      if (quantity <= 10) return 'stock-low'
      return 'stock-available'
    },
    openAddModal() {
      this.selectedArticle = null
      this.showFormModal = true
    },
    openEditModal(article) {
      this.selectedArticle = { ...article }
      this.showFormModal = true
    },
    confirmDelete(article) {
      this.articleToDelete = article
      this.showDeleteModal = true
    },
    async handleFormSubmit(articleData) {
      try {
        if (articleData.id) {
          await updateArticle(articleData.id, articleData)
        } else {
          await createArticle(articleData)
        }
        await this.loadData()
      } catch (error) {
        console.error('Erreur lors de la sauvegarde:', error)
      }
    },
    async handleDelete() {
      if (!this.articleToDelete) return
      
      this.deleting = true
      try {
        await deleteArticle(this.articleToDelete.id)
        await this.loadData()
        this.showDeleteModal = false
        this.articleToDelete = null
      } catch (error) {
        console.error('Erreur lors de la suppression:', error)
      } finally {
        this.deleting = false
      }
    }
  }
}
</script>

<style scoped>
.admin-page {
  min-height: 100vh;
  background-color: var(--color-bg-secondary);
}

/* Header */
.admin-header {
  background: linear-gradient(135deg, var(--color-gray-800) 0%, var(--color-gray-900) 100%);
  color: var(--color-white);
  padding: var(--spacing-8) var(--spacing-4);
}

.header-content {
  max-width: var(--container-max-width);
  margin: 0 auto;
}

.header-main {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: var(--spacing-4);
}

.header-nav {
  display: flex;
  gap: var(--spacing-3);
}

.nav-link {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
  padding: var(--spacing-2) var(--spacing-4);
  background: rgba(255, 255, 255, 0.15);
  border-radius: var(--border-radius-md);
  color: var(--color-white);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  text-decoration: none;
  transition: all 0.2s ease;
}

.nav-link:hover {
  background: rgba(255, 255, 255, 0.25);
}

.admin-header h1 {
  font-size: var(--font-size-3xl);
  margin-bottom: var(--spacing-1);
  color: var(--color-white);
}

.header-subtitle {
  font-size: var(--font-size-base);
  opacity: 0.8;
  margin: 0;
  color: var(--color-white);
}

/* Actions */
.admin-actions {
  background-color: var(--color-white);
  padding: var(--spacing-4);
  border-bottom: var(--border-width-thin) solid var(--color-border-light);
}

.actions-container {
  max-width: var(--container-max-width);
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: var(--spacing-4);
  flex-wrap: wrap;
}

.actions-left {
  display: flex;
  gap: var(--spacing-4);
  flex-wrap: wrap;
  flex: 1;
}

.search-input {
  min-width: 200px;
}

.category-filter {
  min-width: 180px;
}

/* Content */
.admin-content {
  max-width: var(--container-max-width);
  margin: 0 auto;
  padding: var(--spacing-6) var(--spacing-4);
}

/* Table */
.table-container {
  background-color: var(--color-white);
  border-radius: var(--border-radius-xl);
  box-shadow: var(--shadow-sm);
  overflow: hidden;
}

.articles-table {
  width: 100%;
  border-collapse: collapse;
}

.articles-table th {
  background-color: var(--color-gray-50);
  padding: var(--spacing-4);
  text-align: left;
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-secondary);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.articles-table td {
  padding: var(--spacing-4);
  border-top: var(--border-width-thin) solid var(--color-border-light);
  vertical-align: middle;
}

.articles-table tr:hover {
  background-color: var(--color-gray-50);
}

.cell-image img {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: var(--border-radius-md);
}

.cell-name {
  font-weight: var(--font-weight-medium);
  color: var(--color-text-primary);
}

.cell-price {
  font-weight: var(--font-weight-semibold);
  color: var(--color-primary);
}

.cell-actions {
  display: flex;
  gap: var(--spacing-1);
}

.stock-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 40px;
  padding: var(--spacing-1) var(--spacing-2);
  border-radius: var(--border-radius-full);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
}

.stock-available {
  background-color: var(--color-success-bg);
  color: var(--color-success-dark);
}

.stock-low {
  background-color: var(--color-warning-bg);
  color: var(--color-warning-dark);
}

.stock-empty {
  background-color: var(--color-danger-bg);
  color: var(--color-danger-dark);
}

.text-danger {
  color: var(--color-danger);
}

/* States */
.loading-state,
.empty-state {
  text-align: center;
  padding: var(--spacing-16) var(--spacing-4);
  color: var(--color-text-muted);
  background-color: var(--color-white);
  border-radius: var(--border-radius-xl);
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--spacing-4);
}

@media (max-width: 768px) {
  .actions-container {
    flex-direction: column;
    align-items: stretch;
  }
  
  .actions-left {
    flex-direction: column;
  }
  
  .search-input,
  .category-filter {
    width: 100%;
    min-width: auto;
  }
  
  .table-container {
    overflow-x: auto;
  }
  
  .articles-table {
    min-width: 600px;
  }
}
</style>
