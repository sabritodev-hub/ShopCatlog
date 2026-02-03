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
                            <svg
                                width="20"
                                height="20"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="2"
                            >
                                <path
                                    d="M4 4h6v6H4zM14 4h6v6h-6zM4 14h6v6H4zM14 14h6v6h-6z"
                                />
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

                <BaseButton variant="primary" @click="openAddModal">
                    <template #icon>
                        <svg
                            width="20"
                            height="20"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                        >
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
                        <tr
                            v-for="article in filteredArticles"
                            :key="article.id"
                        >
                            <td class="cell-image">
                                <img :src="article.photo" :alt="article.nom" />
                            </td>
                            <td class="cell-name">{{ article.nom }}</td>
                            <td>
                                <BaseBadge
                                    :variant="
                                        getCategoryVariant(article.categorie)
                                    "
                                    size="sm"
                                    rounded
                                >
                                    {{ article.categorie }}
                                </BaseBadge>
                            </td>
                            <td class="cell-price">
                                {{ formatPrice(article.prix) }}
                            </td>
                            <td>
                                <span
                                    :class="[
                                        'stock-badge',
                                        getStockClass(article.quantite),
                                    ]"
                                >
                                    {{ article.quantite }}
                                </span>
                            </td>
                            <td class="cell-actions">
                                <BaseButton
                                    variant="ghost"
                                    size="sm"
                                    @click="openEditModal(article)"
                                >
                                    <svg
                                        width="16"
                                        height="16"
                                        viewBox="0 0 24 24"
                                        fill="none"
                                        stroke="currentColor"
                                        stroke-width="2"
                                    >
                                        <path
                                            d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"
                                        ></path>
                                        <path
                                            d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"
                                        ></path>
                                    </svg>
                                </BaseButton>
                                <BaseButton
                                    variant="ghost"
                                    size="sm"
                                    @click="confirmDelete(article)"
                                >
                                    <svg
                                        width="16"
                                        height="16"
                                        viewBox="0 0 24 24"
                                        fill="none"
                                        stroke="currentColor"
                                        stroke-width="2"
                                        class="text-danger"
                                    >
                                        <polyline
                                            points="3 6 5 6 21 6"
                                        ></polyline>
                                        <path
                                            d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"
                                        ></path>
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
            <p>
                Êtes-vous sûr de vouloir supprimer l'article "{{
                    articleToDelete?.nom
                }}" ?
            </p>
            <p class="text-muted text-sm">Cette action est irréversible.</p>

            <template #footer>
                <BaseButton variant="ghost" @click="showDeleteModal = false">
                    Annuler
                </BaseButton>
                <BaseButton
                    variant="danger"
                    :loading="deleting"
                    @click="handleDelete"
                >
                    Supprimer
                </BaseButton>
            </template>
        </BaseModal>
    </div>
</template>

<script>
import {
    BaseButton,
    BaseInput,
    BaseSelect,
    BaseBadge,
    BaseModal,
} from "@/components/ui";
import ArticleForm from "@/components/articles/ArticleForm.vue";
import {
    getArticles,
    createArticle,
    updateArticle,
    deleteArticle,
    createVariante,
    deleteVariante,
    getVariantes,
} from "@/services/articleService.js";
import { getCategories } from "@/services/categoryService.js";

export default {
    name: "AdminPage",
    components: {
        BaseButton,
        BaseInput,
        BaseSelect,
        BaseBadge,
        BaseModal,
        ArticleForm,
    },
    data() {
        return {
            articles: [],
            categories: [],
            searchQuery: "",
            selectedCategory: "",
            loading: true,
            showFormModal: false,
            showDeleteModal: false,
            selectedArticle: null,
            articleToDelete: null,
            deleting: false,
        };
    },
    computed: {
        categoryOptions() {
            return [
                { value: "", label: "Toutes les catégories" },
                ...this.categories.map((cat) => ({
                    value: cat.nom,
                    label: cat.nom,
                })),
            ];
        },
        filteredArticles() {
            let result = [...this.articles];

            if (this.searchQuery.trim()) {
                const query = this.searchQuery.toLowerCase();
                result = result.filter(
                    (article) =>
                        article.nom.toLowerCase().includes(query) ||
                        (article.categorie &&
                            article.categorie.toLowerCase().includes(query)),
                );
            }

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
        formatPrice(price) {
            return new Intl.NumberFormat("fr-FR", {
                style: "currency",
                currency: "EUR",
            }).format(price);
        },
        getCategoryVariant(category) {
            const variants = {
                Électronique: "primary",
                Chaussures: "secondary",
                Accessoires: "info",
                Vêtements: "warning",
                Mobilier: "success",
            };
            return variants[category] || "default";
        },
        getStockClass(quantity) {
            if (quantity === 0) return "stock-empty";
            if (quantity <= 10) return "stock-low";
            return "stock-available";
        },
        openAddModal() {
            this.selectedArticle = null;
            this.showFormModal = true;
        },
        openEditModal(article) {
            this.selectedArticle = { ...article };
            this.showFormModal = true;
        },
        confirmDelete(article) {
            this.articleToDelete = article;
            this.showDeleteModal = true;
        },
        async handleFormSubmit(articleData, variantes = []) {
            try {
                let articleId;

                if (articleData.id) {
                    // Modification d'article existant
                    await updateArticle(articleData.id, articleData);
                    articleId = articleData.id;

                    // Mettre à jour les variantes
                    if (variantes && variantes.length > 0) {
                        // Récupérer les variantes existantes
                        const existingVariantes = await getVariantes(articleId);
                        const existingIds = existingVariantes.map((v) => v.id);

                        // Traiter les variantes supprimées
                        for (const variant of variantes) {
                            if (variant._deleted && variant.id) {
                                await deleteVariante(variant.id);
                            }
                        }

                        // Traiter les variantes existantes (non supprimées)
                        for (const variant of variantes) {
                            if (!variant._deleted) {
                                if (variant.id) {
                                    // Variante existante - vérifier si modification nécessaire
                                    // Pour l'instant, on suppose pas de modification directe
                                } else if (variant._tempId) {
                                    // Nouvelle variante - créer
                                    await createVariante(articleId, {
                                        nom_variante: variant.nom_variante,
                                        valeur: variant.valeur,
                                        image_url: variant.image_url || null,
                                    });
                                }
                            }
                        }
                    }
                } else {
                    // Création d'article
                    const newArticle = await createArticle(articleData);
                    articleId = newArticle.id;

                    // Créer les variantes
                    if (variantes && variantes.length > 0) {
                        for (const variant of variantes) {
                            if (!variant._deleted && variant._tempId) {
                                await createVariante(articleId, {
                                    nom_variante: variant.nom_variante,
                                    valeur: variant.valeur,
                                    image_url: variant.image_url || null,
                                });
                            }
                        }
                    }
                }

                await this.loadData();
            } catch (error) {
                console.error("Erreur lors de la sauvegarde:", error);
            }
        },
        async handleDelete() {
            if (!this.articleToDelete) return;

            this.deleting = true;
            try {
                await deleteArticle(this.articleToDelete.id);
                await this.loadData();
                this.showDeleteModal = false;
                this.articleToDelete = null;
            } catch (error) {
                console.error("Erreur lors de la suppression:", error);
            } finally {
                this.deleting = false;
            }
        },
    },
};
</script>

<style scoped>
/* ===== ADMIN PAGE - LIQUID GLASS ===== */
.admin-page {
    min-height: 100vh;
    position: relative;
    z-index: 1;
}

/* Header - Glass transparent */
.admin-header {
    position: relative;
    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(20px) saturate(120%);
    -webkit-backdrop-filter: blur(20px) saturate(120%);
    border-bottom: 1px solid rgba(0, 0, 0, 0.06);
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
    padding: var(--spacing-3) var(--spacing-5);
    background: rgba(255, 255, 255, 0.6);
    border: 1px solid rgba(0, 0, 0, 0.06);
    border-radius: var(--radius-full);
    color: var(--color-text-primary);
    font-size: var(--font-size-sm);
    font-weight: var(--font-weight-medium);
    text-decoration: none;
    transition: all var(--transition-normal);
    backdrop-filter: blur(10px);
}

.nav-link:hover {
    background: linear-gradient(
        135deg,
        rgba(255, 255, 255, 0.25) 0%,
        rgba(255, 255, 255, 0.15) 100%
    );
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}

.admin-header h1 {
    font-size: var(--font-size-3xl);
    margin-bottom: var(--spacing-1);
    color: var(--color-text-primary);
    text-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.header-subtitle {
    font-size: var(--font-size-base);
    color: var(--color-text-secondary);
    margin: 0;
}

/* Actions - Floating glass bar */
.admin-actions {
    position: sticky;
    top: var(--spacing-4);
    z-index: var(--z-index-sticky);
    margin: calc(-1 * var(--spacing-4)) var(--spacing-4) 0;
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
}

.actions-container {
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
    min-width: 220px;
}

.category-filter {
    min-width: 200px;
}

/* Content */
.admin-content {
    max-width: var(--container-max-width);
    margin: 0 auto;
    padding: var(--spacing-8) var(--spacing-4);
}

/* Table - Liquid glass */
.table-container {
    position: relative;
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(20px) saturate(120%);
    -webkit-backdrop-filter: blur(20px) saturate(120%);
    border-radius: var(--radius-2xl);
    box-shadow: var(--shadow-glass);
    border: 1px solid rgba(0, 0, 0, 0.06);
    overflow: hidden;
}

/* Reflet supérieur table */
.table-container::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 60px;
    background: linear-gradient(
        180deg,
        rgba(255, 255, 255, 0.5) 0%,
        transparent 100%
    );
    pointer-events: none;
    border-radius: var(--radius-2xl) var(--radius-2xl) 0 0;
}

.articles-table {
    width: 100%;
    border-collapse: collapse;
    position: relative;
    z-index: 1;
}

.articles-table th {
    background: rgba(0, 0, 0, 0.03);
    padding: var(--spacing-4) var(--spacing-5);
    text-align: left;
    font-size: var(--font-size-xs);
    font-weight: var(--font-weight-semibold);
    color: var(--color-text-secondary);
    text-transform: uppercase;
    letter-spacing: 0.08em;
    border-bottom: 1px solid rgba(0, 0, 0, 0.06);
}

.articles-table td {
    padding: var(--spacing-4) var(--spacing-5);
    border-bottom: 1px solid rgba(0, 0, 0, 0.04);
    vertical-align: middle;
    color: var(--color-text-primary);
}

.articles-table tr {
    transition:
        background var(--transition-fast),
        transform var(--transition-fast);
}

.articles-table tr:hover {
    background: rgba(56, 189, 248, 0.1);
}

.cell-image img {
    width: 64px;
    height: 64px;
    object-fit: cover;
    border-radius: var(--radius-lg);
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    transition: transform var(--transition-bounce);
}

.cell-image img:hover {
    transform: scale(1.1) rotate(2deg);
}

.cell-name {
    font-weight: var(--font-weight-medium);
    color: var(--color-text-primary);
}

.cell-price {
    font-weight: var(--font-weight-bold);
    color: var(--color-primary-light);
    text-shadow: 0 0 20px rgba(56, 189, 248, 0.3);
}

.cell-actions {
    display: flex;
    gap: var(--spacing-2);
}

.stock-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 44px;
    padding: var(--spacing-2) var(--spacing-3);
    border-radius: var(--radius-full);
    font-size: var(--font-size-sm);
    font-weight: var(--font-weight-semibold);
    backdrop-filter: blur(10px);
}

.stock-available {
    background: rgba(34, 197, 94, 0.2);
    color: var(--color-success-light);
    border: 1px solid rgba(34, 197, 94, 0.3);
}

.stock-low {
    background: rgba(245, 158, 11, 0.2);
    color: var(--color-warning-light);
    border: 1px solid rgba(245, 158, 11, 0.3);
}

.stock-empty {
    background: rgba(239, 68, 68, 0.2);
    color: var(--color-danger-light);
    border: 1px solid rgba(239, 68, 68, 0.3);
}

.text-danger {
    color: var(--color-danger-light);
}

/* States - Liquid glass */
.loading-state,
.empty-state {
    text-align: center;
    padding: var(--spacing-16) var(--spacing-6);
    color: var(--color-text-secondary);
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
@media (max-width: 768px) {
    .admin-header {
        padding: var(--spacing-6) var(--spacing-4);
    }

    .header-main {
        flex-direction: column;
        align-items: flex-start;
        gap: var(--spacing-4);
    }

    .admin-header h1 {
        font-size: var(--font-size-xl);
    }

    .admin-actions {
        margin: calc(-1 * var(--spacing-3)) var(--spacing-3) 0;
        padding: var(--spacing-4);
        border-radius: var(--radius-xl);
        top: var(--spacing-3);
    }

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
        -webkit-overflow-scrolling: touch;
        border-radius: var(--radius-xl);
    }

    .articles-table {
        min-width: 600px;
    }

    .admin-content {
        padding: var(--spacing-5) var(--spacing-3);
    }

    /* Touch interactions */
    .articles-table tr:hover {
        background: transparent;
    }

    .cell-image img:hover {
        transform: none;
    }

    .articles-table tr:active {
        background: rgba(56, 189, 248, 0.1);
    }
}

/* Animation d'entrée fluide */
@keyframes rowSlideIn {
    from {
        opacity: 0;
        transform: translateX(-20px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

.articles-table tbody tr {
    animation: rowSlideIn 0.4s var(--transition-bounce) forwards;
    opacity: 0;
}

.articles-table tbody tr:nth-child(1) {
    animation-delay: 0.05s;
}
.articles-table tbody tr:nth-child(2) {
    animation-delay: 0.1s;
}
.articles-table tbody tr:nth-child(3) {
    animation-delay: 0.15s;
}
.articles-table tbody tr:nth-child(4) {
    animation-delay: 0.2s;
}
.articles-table tbody tr:nth-child(5) {
    animation-delay: 0.25s;
}
.articles-table tbody tr:nth-child(6) {
    animation-delay: 0.3s;
}

/* Préférence mouvement réduit */
@media (prefers-reduced-motion: reduce) {
    .articles-table tbody tr {
        animation: none;
        opacity: 1;
    }

    .cell-image img {
        transition: none;
    }
}
</style>
