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
                    <svg
                        width="20"
                        height="20"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                    >
                        <path d="m15 18-6-6 6-6" />
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
                    <!-- Infos sous la galerie (mobile/desktop) -->
                    <div class="gallery-info-duplicate">
                        <BaseBadge
                            :color="article.categorie_couleur"
                            size="md"
                            class="info-badge"
                        >
                            {{ article.categorie }}
                        </BaseBadge>
                        <h2 class="article-title-small">{{ article.nom }}</h2>
                        <p class="article-price-small">
                            {{ formatPrice(article.prix) }}
                        </p>
                        <div class="stock-info" :class="stockClass">
                            <svg
                                v-if="article.quantite > 0"
                                width="16"
                                height="16"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="2"
                            >
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                <polyline points="22 4 12 14.01 9 11.01" />
                            </svg>
                            <svg
                                v-else
                                width="16"
                                height="16"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="2"
                            >
                                <circle cx="12" cy="12" r="10" />
                                <line x1="15" y1="9" x2="9" y2="15" />
                                <line x1="9" y1="9" x2="15" y2="15" />
                            </svg>
                            <span v-if="article.quantite > 10"
                                >En stock ({{
                                    article.quantite
                                }}
                                disponibles)</span
                            >
                            <span v-else-if="article.quantite > 0"
                                >Stock limité ({{
                                    article.quantite
                                }}
                                restants)</span
                            >
                            <span v-else>Rupture de stock</span>
                        </div>
                        <div
                            v-if="article.description"
                            class="article-description-small"
                        >
                            <h3>Description</h3>
                            <p>{{ article.description }}</p>
                        </div>
                    </div>
                </div>

                <!-- Info Section -->
                <div class="info-section">
                    <BaseBadge :color="article.categorie_couleur" size="md">
                        {{ article.categorie }}
                    </BaseBadge>

                    <h1 class="article-title">{{ article.nom }}</h1>

                    <p class="article-price">{{ formatPrice(article.prix) }}</p>

                    <div class="stock-info" :class="stockClass">
                        <svg
                            v-if="article.quantite > 0"
                            width="16"
                            height="16"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                        >
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                            <polyline points="22 4 12 14.01 9 11.01" />
                        </svg>
                        <svg
                            v-else
                            width="16"
                            height="16"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                        >
                            <circle cx="12" cy="12" r="10" />
                            <line x1="15" y1="9" x2="9" y2="15" />
                            <line x1="9" y1="9" x2="15" y2="15" />
                        </svg>
                        <span v-if="article.quantite > 10"
                            >En stock ({{ article.quantite }} disponibles)</span
                        >
                        <span v-else-if="article.quantite > 0"
                            >Stock limité ({{
                                article.quantite
                            }}
                            restants)</span
                        >
                        <span v-else>Rupture de stock</span>
                    </div>

                    <div v-if="article.description" class="article-description">
                        <h2>Description</h2>
                        <p>{{ article.description }}</p>
                    </div>

                    <!-- Variantes Section -->
                    <div
                        v-if="
                            variantesGroupees &&
                            Object.keys(variantesGroupees).length > 0
                        "
                        class="variantes-section"
                    >
                        <h2>Variantes disponibles</h2>
                        <VarianteSelector
                            :variantes-groupees="variantesGroupees"
                            :selected-variantes="selectedVariantes"
                            @update:selected-variantes="
                                selectedVariantes = $event
                            "
                            @variante-selected="onVarianteSelected"
                        />
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { BaseButton, BaseBadge } from "@/components/ui";
import VarianteSelector from "@/components/articles/VarianteSelector.vue";
import {
    getArticleById,
    getVariantesGroupees,
} from "@/services/articleService.js";

export default {
    name: "ArticleDetailPage",
    components: {
        BaseButton,
        BaseBadge,
        VarianteSelector,
    },
    data() {
        return {
            article: null,
            loading: true,
            error: "",
            currentImageIndex: 0,
            imageError: false,
            variantesGroupees: {},
            selectedVariantes: {},
        };
    },
    computed: {
        allPhotos() {
            if (!this.article) return [];

            const photos = [this.article.photo];

            if (this.article.photo_2) photos.push(this.article.photo_2);
            if (this.article.photo_3) photos.push(this.article.photo_3);
            if (this.article.photo_4) photos.push(this.article.photo_4);
            if (this.article.photo_5) photos.push(this.article.photo_5);

            return photos.filter(Boolean);
        },
        currentImage() {
            return (
                this.allPhotos[this.currentImageIndex] || this.article?.photo
            );
        },
        stockClass() {
            if (!this.article) return "";
            if (this.article.quantite > 10) return "in-stock";
            if (this.article.quantite > 0) return "low-stock";
            return "out-of-stock";
        },
    },
    async created() {
        await this.loadArticle();
    },
    methods: {
        async loadArticle() {
            this.loading = true;
            this.error = "";

            try {
                const id = this.$route.params.id;
                this.article = await getArticleById(id);

                if (!this.article) {
                    this.error = "Cet article n'existe pas ou a été supprimé.";
                } else {
                    // Charger les variantes groupées
                    this.variantesGroupees = await getVariantesGroupees(id);
                }
            } catch (err) {
                console.error("Erreur chargement article:", err);
                this.error = "Erreur lors du chargement de l'article.";
            } finally {
                this.loading = false;
            }
        },
        formatPrice(price) {
            return new Intl.NumberFormat("fr-FR", {
                style: "currency",
                currency: "EUR",
            }).format(price);
        },
        goBack() {
            this.$router.push("/");
        },
        handleImageError() {
            this.imageError = true;
        },
        onVarianteSelected(data) {
            console.log("Variante sélectionnée:", data.type, data.item);
            // Vous pouvez ici mettre à jour l'image principale si la variante a une image
            if (data.item.image_url) {
                // Chercher et afficher l'image de la variante
                const index = this.allPhotos.findIndex(
                    (photo) => photo === data.item.image_url,
                );
                if (index > -1) {
                    this.currentImageIndex = index;
                }
            }
        },
    },
};
</script>

<style scoped>
/* ===== ARTICLE DETAIL - LIQUID GLASS ===== */
.article-detail-page {
    min-height: 100vh;
    position: relative;
    z-index: 1;
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
    padding: var(--spacing-8);
    color: var(--color-text-primary);
}

.error-state {
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(20px);
    border-radius: var(--radius-2xl);
    border: 1px solid rgba(0, 0, 0, 0.06);
    max-width: 500px;
    margin: var(--spacing-8) auto;
    box-shadow: var(--shadow-glass);
}

.error-state h2 {
    color: var(--color-text-primary);
    margin: 0;
}

.error-state p {
    color: var(--color-text-secondary);
    margin: 0;
}

.article-content {
    max-width: 1200px;
    margin: 0 auto;
    padding: var(--spacing-8);
}

.detail-header {
    margin-bottom: var(--spacing-8);
}

/* Back button - Pill shape */
.back-btn {
    display: inline-flex;
    align-items: center;
    gap: var(--spacing-2);
    padding: var(--spacing-3) var(--spacing-6);
    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(0, 0, 0, 0.06);
    border-radius: var(--radius-full);
    color: var(--color-text-primary);
    font-size: var(--font-size-sm);
    font-weight: var(--font-weight-medium);
    cursor: pointer;
    transition: all var(--transition-bounce);
    box-shadow: var(--shadow-glass);
}

.back-btn:hover {
    background: rgba(255, 255, 255, 0.85);
    transform: translateY(-3px) translateX(-3px);
    box-shadow: var(--shadow-glass-hover);
}

.back-btn:active {
    transform: scale(0.97);
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

/* Gallery - Liquid glass */
.gallery-section {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-4);
}

.main-image {
    position: relative;
    aspect-ratio: 1;
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(10px);
    border-radius: var(--radius-2xl);
    overflow: hidden;
    border: 1px solid rgba(0, 0, 0, 0.06);
    box-shadow: var(--shadow-glass-float);
}

/* Reflet image principale */
.main-image::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 30%;
    background: linear-gradient(
        180deg,
        rgba(255, 255, 255, 0.5) 0%,
        transparent 100%
    );
    pointer-events: none;
    z-index: 1;
    border-radius: var(--radius-2xl) var(--radius-2xl) 0 0;
}

.main-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.6s var(--transition-bounce);
}

.main-image:hover img {
    transform: scale(1.05);
}

.thumbnails {
    display: flex;
    gap: var(--spacing-3);
    flex-wrap: wrap;
}

.thumbnail {
    width: 80px;
    height: 80px;
    padding: 0;
    border: 2px solid rgba(0, 0, 0, 0.08);
    border-radius: var(--radius-lg);
    overflow: hidden;
    cursor: pointer;
    transition: all var(--transition-bounce);
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(10px);
}

.thumbnail:hover {
    border-color: rgba(56, 189, 248, 0.4);
    transform: translateY(-4px) scale(1.05);
    box-shadow: 0 12px 32px rgba(0, 0, 0, 0.1);
}

.thumbnail.active {
    border-color: var(--color-primary);
    box-shadow: 0 0 0 4px rgba(56, 189, 248, 0.2);
}

.thumbnail img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

/* Info Section - Glass card neutre */
.info-section {
    position: relative;
    display: flex;
    flex-direction: column;
    gap: var(--spacing-5);
    background: rgba(255, 255, 255, 0.75);
    backdrop-filter: blur(20px) saturate(120%);
    -webkit-backdrop-filter: blur(20px) saturate(120%);
    border-radius: var(--radius-2xl);
    border: 1px solid rgba(0, 0, 0, 0.06);
    padding: var(--spacing-8);
    box-shadow: var(--shadow-glass);
}

/* Reflet info section */
.info-section::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 50%;
    background: linear-gradient(
        180deg,
        rgba(255, 255, 255, 0.1) 0%,
        transparent 100%
    );
    pointer-events: none;
    border-radius: var(--radius-2xl) var(--radius-2xl) 0 0;
}

.article-title {
    position: relative;
    font-size: var(--font-size-3xl);
    font-weight: var(--font-weight-bold);
    color: var(--color-text-primary);
    margin: 0;
    line-height: 1.2;
    text-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.article-price {
    position: relative;
    font-size: var(--font-size-2xl);
    font-weight: var(--font-weight-bold);
    color: var(--color-primary-light);
    margin: 0;
    text-shadow: 0 0 30px rgba(56, 189, 248, 0.4);
}

.stock-info {
    position: relative;
    display: inline-flex;
    align-items: center;
    gap: var(--spacing-2);
    font-size: var(--font-size-sm);
    font-weight: var(--font-weight-semibold);
    padding: var(--spacing-3) var(--spacing-5);
    border-radius: var(--radius-full);
    backdrop-filter: blur(10px);
    width: fit-content;
}

.stock-info.in-stock {
    background: rgba(34, 197, 94, 0.15);
    color: #16a34a;
    border: 1px solid rgba(34, 197, 94, 0.25);
}

.stock-info.low-stock {
    background: rgba(245, 158, 11, 0.15);
    color: #d97706;
    border: 1px solid rgba(245, 158, 11, 0.25);
}

.stock-info.out-of-stock {
    background: rgba(239, 68, 68, 0.15);
    color: #dc2626;
    border: 1px solid rgba(239, 68, 68, 0.25);
}

.article-description {
    position: relative;
    padding-top: var(--spacing-5);
    border-top: 1px solid rgba(0, 0, 0, 0.08);
}

.article-description h2 {
    font-size: var(--font-size-lg);
    font-weight: var(--font-weight-semibold);
    color: var(--color-text-primary);
    margin: 0 0 var(--spacing-3) 0;
}

.article-description p {
    color: var(--color-text-secondary);
    line-height: 1.7;
    margin: 0;
}

/* Variantes Section */
.variantes-section {
    position: relative;
    padding-top: var(--spacing-5);
    border-top: 1px solid #e5e7eb;
}

.variantes-section h2 {
    font-size: var(--font-size-lg);
    font-weight: 600;
    color: #111827;
    margin: 0 0 var(--spacing-4) 0;
}

.article-actions {
    position: relative;
    margin-top: var(--spacing-4);
}

/* ===== MOBILE ===== */
@media (max-width: 768px) {
    .article-content {
        padding: var(--spacing-4);
    }

    .detail-header {
        margin-bottom: var(--spacing-5);
    }

    .back-btn {
        padding: var(--spacing-2) var(--spacing-4);
        font-size: var(--font-size-sm);
    }

    .detail-grid {
        gap: var(--spacing-5);
    }

    .gallery-section {
        gap: var(--spacing-3);
    }

    .main-image {
        border-radius: var(--radius-xl);
    }

    .info-section {
        border-radius: var(--radius-xl);
        padding: var(--spacing-5);
    }

    .thumbnails {
        gap: var(--spacing-2);
    }

    .thumbnail {
        width: 64px;
        height: 64px;
        border-radius: var(--radius-md);
    }

    .article-title {
        font-size: var(--font-size-xl);
    }

    .article-price {
        font-size: var(--font-size-lg);
    }

    .stock-info {
        padding: var(--spacing-2) var(--spacing-4);
        font-size: var(--font-size-xs);
    }

    /* Touch interactions */
    .thumbnail:hover {
        transform: none;
        box-shadow: none;
    }

    .main-image:hover img {
        transform: none;
    }

    .thumbnail:active {
        transform: scale(0.95);
        background: rgba(255, 255, 255, 0.2);
    }

    .back-btn:hover {
        transform: none;
    }

    .back-btn:active {
        transform: scale(0.95);
    }
}

/* Animations d'entrée fluides */
@keyframes glassSlideIn {
    from {
        opacity: 0;
        transform: translateY(40px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

.gallery-section {
    animation: glassSlideIn 0.6s var(--transition-spring) forwards;
}

.info-section {
    animation: glassSlideIn 0.6s var(--transition-spring) 0.15s forwards;
    opacity: 0;
}

/* Préférence mouvement réduit */
@media (prefers-reduced-motion: reduce) {
    .gallery-section,
    .info-section {
        animation: none;
        opacity: 1;
    }

    .thumbnail,
    .back-btn,
    .main-image img {
        transition: none;
    }
}
</style>
