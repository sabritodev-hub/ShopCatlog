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
/* ===== CATALOG PAGE - LIQUID GLASS ===== */
.catalog-page {
  min-height: 100vh;
  position: relative;
  z-index: 1;
}

/* Header - Transparent glass */
.catalog-header {
  position: relative;
  background: linear-gradient(
    180deg,
    rgba(255, 255, 255, 0.12) 0%,
    rgba(255, 255, 255, 0.05) 100%
  );
  backdrop-filter: blur(30px) saturate(150%);
  -webkit-backdrop-filter: blur(30px) saturate(150%);
  border-bottom: 1px solid rgba(255, 255, 255, 0.15);
  padding: var(--spacing-16) var(--spacing-4);
  text-align: center;
  overflow: hidden;
}

/* Effet lumineux header */
.catalog-header::before {
  content: '';
  position: absolute;
  top: -50%;
  left: 50%;
  transform: translateX(-50%);
  width: 120%;
  height: 100%;
  background: radial-gradient(
    ellipse at center,
    rgba(255, 255, 255, 0.2) 0%,
    transparent 60%
  );
  pointer-events: none;
}

.header-content {
  position: relative;
  max-width: var(--container-max-width);
  margin: 0 auto;
  z-index: 1;
}

.catalog-header h1 {
  font-size: var(--font-size-5xl);
  font-weight: var(--font-weight-bold);
  margin-bottom: var(--spacing-3);
  color: var(--color-text-primary);
  text-shadow: 0 2px 20px rgba(0, 0, 0, 0.15);
  animation: fadeInDown 0.6s var(--transition-bounce) forwards;
}

.header-subtitle {
  font-size: var(--font-size-xl);
  color: var(--color-text-secondary);
  margin: 0;
  animation: fadeInUp 0.6s var(--transition-bounce) 0.1s forwards;
  opacity: 0;
}

@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Filters - Floating glass bar */
.catalog-filters {
  position: sticky;
  top: var(--spacing-4);
  z-index: var(--z-index-sticky);
  margin: calc(-1 * var(--spacing-8)) var(--spacing-4) 0;
  max-width: var(--container-max-width);
  margin-left: auto;
  margin-right: auto;
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(20px) saturate(120%);
  -webkit-backdrop-filter: blur(20px) saturate(120%);
  border: 1px solid rgba(0, 0, 0, 0.06);
  border-radius: var(--radius-2xl);
  padding: var(--spacing-5);
  box-shadow: var(--shadow-glass);
  animation: floatIn 0.5s var(--transition-bounce) 0.2s forwards;
  opacity: 0;
  transform: translateY(20px);
}

@keyframes floatIn {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.filters-container {
  display: flex;
  gap: var(--spacing-4);
  flex-wrap: wrap;
  align-items: center;
}

.search-input {
  flex: 1;
  min-width: 280px;
}

.category-filter {
  min-width: 220px;
}

.results-count {
  width: 100%;
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
  margin-top: var(--spacing-3);
  padding-top: var(--spacing-3);
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

/* Grid */
.catalog-grid {
  max-width: var(--container-max-width);
  margin: 0 auto;
  padding: var(--spacing-10) var(--spacing-4);
}

.articles-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: var(--spacing-6);
}

/* States */
.loading-state,
.empty-state {
  text-align: center;
  padding: var(--spacing-16) var(--spacing-6);
  color: var(--color-text-primary);
  background: linear-gradient(
    135deg,
    rgba(255, 255, 255, 0.12) 0%,
    rgba(255, 255, 255, 0.06) 100%
  );
  backdrop-filter: blur(30px);
  -webkit-backdrop-filter: blur(30px);
  border-radius: var(--radius-2xl);
  border: 1px solid rgba(255, 255, 255, 0.15);
  box-shadow: var(--shadow-glass);
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--spacing-5);
}

/* ===== MOBILE ===== */
@media (max-width: 640px) {
  .catalog-header {
    padding: var(--spacing-10) var(--spacing-4) var(--spacing-12);
  }
  
  .catalog-header h1 {
    font-size: var(--font-size-3xl);
  }
  
  .header-subtitle {
    font-size: var(--font-size-base);
  }
  
  .catalog-filters {
    margin: calc(-1 * var(--spacing-6)) var(--spacing-3) 0;
    padding: var(--spacing-4);
    border-radius: var(--radius-xl);
    top: var(--spacing-3);
  }
  
  .filters-container {
    flex-direction: column;
    gap: var(--spacing-3);
  }
  
  .search-input,
  .category-filter {
    width: 100%;
    min-width: auto;
  }
  
  .results-count {
    text-align: center;
  }
  
  .catalog-grid {
    padding: var(--spacing-6) var(--spacing-3);
  }
  
  .articles-grid {
    grid-template-columns: 1fr;
    gap: var(--spacing-4);
  }
}

/* Tablette */
@media (min-width: 641px) and (max-width: 1024px) {
  .articles-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .catalog-filters {
    margin-left: var(--spacing-4);
    margin-right: var(--spacing-4);
  }
}

/* Préférence mouvement réduit */
@media (prefers-reduced-motion: reduce) {
  .catalog-header h1,
  .header-subtitle,
  .catalog-filters {
    animation: none;
    opacity: 1;
    transform: none;
  }
}
</style>
