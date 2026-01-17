<template>
  <div class="catalog-page">
    <header class="catalog-header">
      <div class="header-content">
        <h1>Catalogue</h1>
        <p class="header-subtitle">Découvrez notre sélection de produits</p>
      </div>
    </header>
    
    <!-- Filtres -->
    <section class="catalog-filters">
      <div class="filters-container">
        <BaseInput
          v-model="searchQuery"
          placeholder="Rechercher un article..."
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
      
      <p class="results-count">{{ filteredArticles.length }} article(s) trouvé(s)</p>
    </section>
    
    <!-- Grille d'articles -->
    <section class="catalog-grid">
      <div v-if="loading" class="loading-state">
        <p>Chargement des articles...</p>
      </div>
      
      <div v-else-if="filteredArticles.length === 0" class="empty-state">
        <p>Aucun article trouvé</p>
        <BaseButton variant="outline" @click="resetFilters">
          Réinitialiser les filtres
        </BaseButton>
      </div>
      
      <div v-else class="articles-grid">
        <ArticleCard
          v-for="article in filteredArticles"
          :key="article.id"
          :article="article"
        />
      </div>
    </section>
  </div>
</template>

<script>
import { BaseInput, BaseSelect, BaseButton } from '@/components/ui'
import ArticleCard from '@/components/articles/ArticleCard.vue'
import { getArticles, getCategories } from '@/services/articleService.js'

export default {
  name: 'CatalogPage',
  components: {
    BaseInput,
    BaseSelect,
    BaseButton,
    ArticleCard
  },
  data() {
    return {
      articles: [],
      categories: [],
      searchQuery: '',
      selectedCategory: '',
      loading: true
    }
  },
  computed: {
    categoryOptions() {
      return [
        { value: '', label: 'Toutes les catégories' },
        ...this.categories.map(cat => ({ value: cat, label: cat }))
      ]
    },
    filteredArticles() {
      let result = [...this.articles]
      
      // Filtre par recherche
      if (this.searchQuery.trim()) {
        const query = this.searchQuery.toLowerCase()
        result = result.filter(article =>
          article.nom.toLowerCase().includes(query) ||
          article.categorie.toLowerCase().includes(query)
        )
      }
      
      // Filtre par catégorie
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
    resetFilters() {
      this.searchQuery = ''
      this.selectedCategory = ''
    }
  }
}
</script>

<style scoped>
.catalog-page {
  min-height: 100vh;
}

/* Header */
.catalog-header {
  background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-primary-dark) 100%);
  color: var(--color-white);
  padding: var(--spacing-12) var(--spacing-4);
  text-align: center;
}

.header-content {
  max-width: var(--container-max-width);
  margin: 0 auto;
}

.catalog-header h1 {
  font-size: var(--font-size-4xl);
  margin-bottom: var(--spacing-2);
  color: var(--color-white);
}

.header-subtitle {
  font-size: var(--font-size-lg);
  opacity: 0.9;
  margin: 0;
  color: var(--color-white);
}

/* Filters */
.catalog-filters {
  background-color: var(--color-white);
  padding: var(--spacing-6) var(--spacing-4);
  border-bottom: var(--border-width-thin) solid var(--color-border-light);
  position: sticky;
  top: 0;
  z-index: var(--z-index-sticky);
}

.filters-container {
  max-width: var(--container-max-width);
  margin: 0 auto;
  display: flex;
  gap: var(--spacing-4);
  flex-wrap: wrap;
}

.search-input {
  flex: 1;
  min-width: 250px;
}

.category-filter {
  min-width: 200px;
}

.results-count {
  max-width: var(--container-max-width);
  margin: var(--spacing-4) auto 0;
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
}

/* Grid */
.catalog-grid {
  max-width: var(--container-max-width);
  margin: 0 auto;
  padding: var(--spacing-8) var(--spacing-4);
}

.articles-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: var(--spacing-6);
}

/* States */
.loading-state,
.empty-state {
  text-align: center;
  padding: var(--spacing-16) var(--spacing-4);
  color: var(--color-text-muted);
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--spacing-4);
}

@media (max-width: 640px) {
  .catalog-header {
    padding: var(--spacing-8) var(--spacing-4);
  }
  
  .catalog-header h1 {
    font-size: var(--font-size-3xl);
  }
  
  .filters-container {
    flex-direction: column;
  }
  
  .search-input,
  .category-filter {
    width: 100%;
    min-width: auto;
  }
}
</style>
