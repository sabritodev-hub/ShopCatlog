<template>
  <BaseCard :image="article.photo" :image-alt="article.nom" hoverable variant="elevated">
    <template #header>
      <div class="article-header">
        <h3 class="article-name">{{ article.nom }}</h3>
        <BaseBadge :variant="categoryVariant" size="sm" rounded>
          {{ article.categorie }}
        </BaseBadge>
      </div>
    </template>
    
    <div class="article-details">
      <p class="article-price">{{ formatPrice(article.prix) }}</p>
      <p :class="['article-stock', stockClass]">
        <span class="stock-icon">●</span>
        {{ stockText }}
      </p>
    </div>
    
    <template #footer>
      <slot name="actions">
        <router-link :to="`/article/${article.id}`" class="detail-link">
          <BaseButton variant="primary" size="sm" full-width>
            Voir détails
          </BaseButton>
        </router-link>
      </slot>
    </template>
  </BaseCard>
</template>

<script>
import { BaseCard, BaseBadge, BaseButton } from '@/components/ui'

export default {
  name: 'ArticleCard',
  components: {
    BaseCard,
    BaseBadge,
    BaseButton
  },
  props: {
    article: {
      type: Object,
      required: true
    }
  },
  computed: {
    categoryVariant() {
      const variants = {
        'Électronique': 'primary',
        'Chaussures': 'secondary',
        'Accessoires': 'info',
        'Vêtements': 'warning',
        'Mobilier': 'success'
      }
      return variants[this.article.categorie] || 'default'
    },
    stockClass() {
      if (this.article.quantite === 0) return 'stock-empty'
      if (this.article.quantite <= 10) return 'stock-low'
      return 'stock-available'
    },
    stockText() {
      if (this.article.quantite === 0) return 'Rupture de stock'
      if (this.article.quantite <= 10) return `Plus que ${this.article.quantite} en stock`
      return `${this.article.quantite} en stock`
    }
  },
  methods: {
    formatPrice(price) {
      return new Intl.NumberFormat('fr-FR', {
        style: 'currency',
        currency: 'EUR'
      }).format(price)
    }
  }
}
</script>

<style scoped>
/* ===== ARTICLE CARD - LIQUID GLASS ===== */
.article-header {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-2);
}

.article-name {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-shadow: 0 1px 8px rgba(0, 0, 0, 0.1);
}

.article-details {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-2);
}

.article-price {
  font-size: var(--font-size-xl);
  font-weight: var(--font-weight-bold);
  color: var(--color-primary);
  margin: 0;
  text-shadow: 0 0 20px rgba(56, 189, 248, 0.2);
}

.article-stock {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
  font-size: var(--font-size-sm);
  margin: 0;
}

.stock-icon {
  font-size: 10px;
  text-shadow: 0 0 8px currentColor;
}

.stock-available {
  color: #16a34a;
}

.stock-low {
  color: #d97706;
}

.stock-empty {
  color: #dc2626;
}

.detail-link {
  text-decoration: none;
  display: block;
  width: 100%;
}
</style>
