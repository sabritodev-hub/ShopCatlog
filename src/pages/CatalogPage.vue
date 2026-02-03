<template>
    <div class="catalog-page">
        <header class="catalog-header">
            <div class="header-content">
                <h1>Catalogue</h1>
                <p class="header-subtitle">
                    Découvrez notre sélection de produits
                </p>
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
                        <svg
                            width="20"
                            height="20"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                        >
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

            <p class="results-count">
                {{ filteredArticles.length }} article(s) trouvé(s)
            </p>
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
import { BaseInput, BaseSelect, BaseButton } from "@/components/ui";
import ArticleCard from "@/components/articles/ArticleCard.vue";
import { getArticles, getCategories } from "@/services/articleService.js";

export default {
    name: "CatalogPage",
    components: {
        BaseInput,
        BaseSelect,
        BaseButton,
        ArticleCard,
    },
    data() {
        return {
            articles: [],
            categories: [],
            searchQuery: "",
            selectedCategory: "",
            loading: true,
        };
    },
    computed: {
        categoryOptions() {
            return [
                { value: "", label: "Toutes les catégories" },
                ...this.categories.map((cat) => ({ value: cat, label: cat })),
            ];
        },
        filteredArticles() {
            let result = [...this.articles];

            // Filtre par recherche
            if (this.searchQuery.trim()) {
                const query = this.searchQuery.toLowerCase();
                result = result.filter(
                    (article) =>
                        article.nom.toLowerCase().includes(query) ||
                        article.categorie.toLowerCase().includes(query),
                );
            }

            // Filtre par catégorie
            if (this.selectedCategory) {
                result = result.filter(
                    (article) => article.categorie === this.selectedCategory,
                );
            }

            return result;
        },
    },
    async mounted() {
        await this.loadData();
    },
    methods: {
        async loadData() {
            this.loading = true;
            try {
                const [articles, categories] = await Promise.all([
                    getArticles(),
                    getCategories(),
                ]);
                this.articles = articles;
                this.categories = categories;
            } catch (error) {
                console.error("Erreur lors du chargement des données:", error);
            } finally {
                this.loading = false;
            }
        },
        resetFilters() {
            this.searchQuery = "";
            this.selectedCategory = "";
        },
    },
};
</script>

<style scoped>
/* ===== CATALOG PAGE - MODERN 2026 ===== */
.catalog-page {
    min-height: 100vh;
    background: linear-gradient(135deg, #ffffff 0%, #f9fafb 100%);
}

/* Header */
.catalog-header {
    background: #ffffff;
    border-bottom: 1px solid #e5e7eb;
    padding: var(--spacing-16) var(--spacing-4);
    text-align: center;
}

.header-content {
    max-width: var(--container-max-width);
    margin: 0 auto;
}

.catalog-header h1 {
    font-size: var(--font-size-4xl);
    color: var(--color-text-primary);
    margin-bottom: var(--spacing-3);
    background: linear-gradient(135deg, #6366f1 0%, #ec4899 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.header-subtitle {
    font-size: var(--font-size-lg);
    color: var(--color-text-secondary);
    margin: 0;
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

/* Filters - Modern floating bar */
.catalog-filters {
    position: sticky;
    top: var(--spacing-4);
    z-index: var(--z-index-sticky);
    margin: calc(-1 * var(--spacing-8)) var(--spacing-4) 0;
    max-width: var(--container-max-width);
    margin-left: auto;
    margin-right: auto;
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: var(--radius-lg);
    padding: var(--spacing-5);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    overflow: visible;
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
    border-top: 1px solid #e5e7eb;
}

/* Grid */
.catalog-grid {
    max-width: var(--container-max-width);
    margin: 0 auto;
    padding: var(--spacing-10) var(--spacing-4);
}

.articles-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: var(--spacing-6);
}

/* States */
.loading-state,
.empty-state {
    grid-column: 1 / -1;
    text-align: center;
    padding: var(--spacing-16) var(--spacing-6);
    color: var(--color-text-primary);
    background: #ffffff;
    border-radius: var(--radius-lg);
    border: 1px solid #e5e7eb;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
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
