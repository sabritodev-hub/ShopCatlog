<template>
  <div class="article-detail-page">
    <!-- Loading -->
    <div v-if="loading" class="loading-state">
      <p>Chargement de l'article...</p>
    </div>
    
    <!-- Error -->
    <div v-else-if="error" class="error-state">
      <h2>Article non trouvé</h2>
      <p>{{ error }}</p>
      <BaseButton variant="primary" @click="goBack">
        Retour au catalogue
      </BaseButton>
    </div>
    
    <!-- Article Content -->
    <div v-else-if="article" class="article-content">
      <!-- Header -->
      <header class="detail-header">
        <button class="back-btn" @click="goBack">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="m15 18-6-6 6-6"/>
          </svg>
          Retour
        </button>
      </header>
      
      <div class="detail-grid">
        <!-- Gallery Section -->
        <div class="gallery-section">
          <!-- Main Image -->
          <div class="main-image">
            <img 
              :src="currentImage" 
              :alt="article.nom"
              @error="handleImageError"
            />
          </div>
          
          <!-- Thumbnails -->
          <div v-if="allPhotos.length > 1" class="thumbnails">
            <button
              v-for="(photo, index) in allPhotos"
              :key="index"
              class="thumbnail"
              :class="{ active: currentImageIndex === index }"
              @click="currentImageIndex = index"
            >
              <img :src="photo" :alt="`Photo ${index + 1}`" />
            </button>
          </div>
        </div>
        
        <!-- Info Section -->
        <div class="info-section">
          <BaseBadge 
            :color="article.categorie_couleur" 
            size="md"
          >
            {{ article.categorie }}
          </BaseBadge>
          
          <h1 class="article-title">{{ article.nom }}</h1>
          
          <p class="article-price">{{ formatPrice(article.prix) }}</p>
          
          <div class="stock-info" :class="stockClass">
            <svg v-if="article.quantite > 0" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
              <polyline points="22 4 12 14.01 9 11.01"/>
            </svg>
            <svg v-else width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="12" cy="12" r="10"/>
              <line x1="15" y1="9" x2="9" y2="15"/>
              <line x1="9" y1="9" x2="15" y2="15"/>
            </svg>
            <span v-if="article.quantite > 10">En stock ({{ article.quantite }} disponibles)</span>
            <span v-else-if="article.quantite > 0">Stock limité ({{ article.quantite }} restants)</span>
            <span v-else>Rupture de stock</span>
          </div>
          
          <div v-if="article.description" class="article-description">
            <h2>Description</h2>
            <p>{{ article.description }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { BaseButton, BaseBadge } from '@/components/ui'
import { getArticleById } from '@/services/articleService.js'

export default {
  name: 'ArticleDetailPage',
  components: {
    BaseButton,
    BaseBadge
  },
  data() {
    return {
      article: null,
      loading: true,
      error: '',
      currentImageIndex: 0,
      imageError: false
    }
  },
  computed: {
    allPhotos() {
      if (!this.article) return []
      
      const photos = [this.article.photo]
      
      if (this.article.photo_2) photos.push(this.article.photo_2)
      if (this.article.photo_3) photos.push(this.article.photo_3)
      if (this.article.photo_4) photos.push(this.article.photo_4)
      if (this.article.photo_5) photos.push(this.article.photo_5)
      
      return photos.filter(Boolean)
    },
    currentImage() {
      return this.allPhotos[this.currentImageIndex] || this.article?.photo
    },
    stockClass() {
      if (!this.article) return ''
      if (this.article.quantite > 10) return 'in-stock'
      if (this.article.quantite > 0) return 'low-stock'
      return 'out-of-stock'
    }
  },
  async created() {
    await this.loadArticle()
  },
  methods: {
    async loadArticle() {
      this.loading = true
      this.error = ''
      
      try {
        const id = this.$route.params.id
        this.article = await getArticleById(id)
        
        if (!this.article) {
          this.error = 'Cet article n\'existe pas ou a été supprimé.'
        }
      } catch (err) {
        console.error('Erreur chargement article:', err)
        this.error = 'Erreur lors du chargement de l\'article.'
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
    goBack() {
      this.$router.push('/')
    },
    handleImageError() {
      this.imageError = true
    }
  }
}
</script>

<style scoped>
.article-detail-page {
  min-height: 100vh;
  background-color: var(--color-bg-primary);
}

.loading-state,
.error-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 60vh;
  gap: var(--spacing-4);
  text-align: center;
  padding: var(--spacing-6);
}

.error-state h2 {
  color: var(--color-text-primary);
  margin: 0;
}

.error-state p {
  color: var(--color-text-muted);
  margin: 0;
}

.article-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: var(--spacing-6);
}

.detail-header {
  margin-bottom: var(--spacing-6);
}

.back-btn {
  display: inline-flex;
  align-items: center;
  gap: var(--spacing-2);
  padding: var(--spacing-2) var(--spacing-4);
  background: none;
  border: 1px solid var(--color-border);
  border-radius: var(--border-radius-lg);
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
  cursor: pointer;
  transition: all 0.2s ease;
}

.back-btn:hover {
  background-color: var(--color-bg-secondary);
  color: var(--color-text-primary);
}

.detail-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--spacing-10);
}

@media (max-width: 900px) {
  .detail-grid {
    grid-template-columns: 1fr;
    gap: var(--spacing-6);
  }
}

/* Gallery */
.gallery-section {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-4);
}

.main-image {
  aspect-ratio: 1;
  background-color: var(--color-bg-secondary);
  border-radius: var(--border-radius-xl);
  overflow: hidden;
}

.main-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.thumbnails {
  display: flex;
  gap: var(--spacing-2);
  flex-wrap: wrap;
}

.thumbnail {
  width: 80px;
  height: 80px;
  padding: 0;
  border: 2px solid transparent;
  border-radius: var(--border-radius-md);
  overflow: hidden;
  cursor: pointer;
  transition: all 0.2s ease;
  background: var(--color-bg-secondary);
}

.thumbnail:hover {
  border-color: var(--color-border);
}

.thumbnail.active {
  border-color: var(--color-primary);
}

.thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* Info Section */
.info-section {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-4);
}

.article-title {
  font-size: var(--font-size-3xl);
  font-weight: var(--font-weight-bold);
  color: var(--color-text-primary);
  margin: 0;
  line-height: 1.2;
}

.article-price {
  font-size: var(--font-size-2xl);
  font-weight: var(--font-weight-semibold);
  color: var(--color-primary);
  margin: 0;
}

.stock-info {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
  font-size: var(--font-size-sm);
  padding: var(--spacing-3);
  border-radius: var(--border-radius-md);
}

.stock-info.in-stock {
  background-color: #dcfce7;
  color: #166534;
}

.stock-info.low-stock {
  background-color: #fef3c7;
  color: #92400e;
}

.stock-info.out-of-stock {
  background-color: #fee2e2;
  color: #991b1b;
}

.article-description {
  padding-top: var(--spacing-4);
  border-top: 1px solid var(--color-border-light);
}

.article-description h2 {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin: 0 0 var(--spacing-2) 0;
}

.article-description p {
  color: var(--color-text-secondary);
  line-height: 1.6;
  margin: 0;
}

.article-actions {
  margin-top: var(--spacing-4);
}
</style>
