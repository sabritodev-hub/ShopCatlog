<template>
    <div class="categories-page">
        <header class="page-header">
            <div class="header-content">
                <div class="header-title">
                    <router-link to="/admin" class="back-link">
                        <svg
                            width="20"
                            height="20"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                        >
                            <path d="M19 12H5M12 19l-7-7 7-7" />
                        </svg>
                    </router-link>
                    <h1>Gestion des Catégories</h1>
                </div>
                <p class="header-subtitle">
                    Gérez les catégories de vos articles
                </p>
            </div>
        </header>

        <!-- Actions bar -->
        <section class="actions-bar">
            <div class="actions-container">
                <BaseInput
                    v-model="searchQuery"
                    placeholder="Rechercher une catégorie..."
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
                    Ajouter une catégorie
                </BaseButton>
            </div>
        </section>

        <!-- Categories List -->
        <section class="categories-content">
            <div v-if="loading" class="loading-state">
                <p>Chargement des catégories...</p>
            </div>

            <div
                v-else-if="filteredCategories.length === 0"
                class="empty-state"
            >
                <p>Aucune catégorie trouvée</p>
                <BaseButton variant="primary" @click="openAddModal">
                    Ajouter votre première catégorie
                </BaseButton>
            </div>

            <div v-else class="categories-grid">
                <div
                    v-for="category in filteredCategories"
                    :key="category.id"
                    class="category-card"
                >
                    <div
                        class="category-color"
                        :style="{ backgroundColor: category.couleur }"
                    ></div>
                    <div class="category-info">
                        <h3>{{ category.nom }}</h3>
                        <p class="category-description">
                            {{ category.description || "Aucune description" }}
                        </p>
                    </div>
                    <div class="category-actions">
                        <BaseButton
                            variant="ghost"
                            size="sm"
                            @click="openEditModal(category)"
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
                            @click="confirmDelete(category)"
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
                                <polyline points="3 6 5 6 21 6"></polyline>
                                <path
                                    d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"
                                ></path>
                            </svg>
                        </BaseButton>
                    </div>
                </div>
            </div>
        </section>

        <!-- Add/Edit Modal -->
        <BaseModal
            v-model="showFormModal"
            :title="isEditing ? 'Modifier la catégorie' : 'Nouvelle catégorie'"
            size="sm"
        >
            <form @submit.prevent="handleSubmit" class="category-form">
                <BaseInput
                    v-model="formData.nom"
                    label="Nom de la catégorie"
                    placeholder="Ex: Électronique"
                    required
                />

                <BaseInput
                    v-model="formData.description"
                    label="Description"
                    placeholder="Description de la catégorie"
                />

                <div class="color-picker-field">
                    <label>Couleur</label>
                    <div class="color-options">
                        <button
                            v-for="color in colorOptions"
                            :key="color"
                            type="button"
                            class="color-option"
                            :class="{ active: formData.couleur === color }"
                            :style="{ backgroundColor: color }"
                            @click="formData.couleur = color"
                        ></button>
                        <input
                            type="color"
                            v-model="formData.couleur"
                            class="custom-color-input"
                            title="Couleur personnalisée"
                        />
                    </div>
                </div>
            </form>

            <template #footer>
                <BaseButton variant="ghost" @click="closeFormModal">
                    Annuler
                </BaseButton>
                <BaseButton
                    variant="primary"
                    :loading="saving"
                    @click="handleSubmit"
                >
                    {{ isEditing ? "Enregistrer" : "Créer" }}
                </BaseButton>
            </template>
        </BaseModal>

        <!-- Delete Confirmation Modal -->
        <BaseModal
            v-model="showDeleteModal"
            title="Confirmer la suppression"
            size="sm"
        >
            <p>
                Êtes-vous sûr de vouloir supprimer la catégorie "{{
                    categoryToDelete?.nom
                }}" ?
            </p>
            <p class="text-muted text-sm">
                Cette action est irréversible. Les articles de cette catégorie
                ne seront pas supprimés.
            </p>

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
import { BaseButton, BaseInput, BaseModal } from "@/components/ui";
import {
    getCategories,
    createCategory,
    updateCategory,
    deleteCategory,
} from "@/services/categoryService.js";

export default {
    name: "CategoriesPage",
    components: {
        BaseButton,
        BaseInput,
        BaseModal,
    },
    data() {
        return {
            categories: [],
            searchQuery: "",
            loading: true,
            saving: false,
            deleting: false,
            showFormModal: false,
            showDeleteModal: false,
            isEditing: false,
            selectedCategory: null,
            categoryToDelete: null,
            formData: {
                nom: "",
                description: "",
                couleur: "#3b82f6",
            },
            colorOptions: [
                "#3b82f6", // blue
                "#8b5cf6", // purple
                "#ec4899", // pink
                "#ef4444", // red
                "#f59e0b", // amber
                "#10b981", // emerald
                "#06b6d4", // cyan
                "#6b7280", // gray
            ],
        };
    },
    computed: {
        filteredCategories() {
            if (!this.searchQuery.trim()) {
                return this.categories;
            }
            const query = this.searchQuery.toLowerCase();
            return this.categories.filter(
                (cat) =>
                    cat.nom.toLowerCase().includes(query) ||
                    (cat.description &&
                        cat.description.toLowerCase().includes(query)),
            );
        },
    },
    async mounted() {
        await this.loadCategories();
    },
    methods: {
        async loadCategories() {
            this.loading = true;
            try {
                this.categories = await getCategories();
            } catch (error) {
                console.error(
                    "Erreur lors du chargement des catégories:",
                    error,
                );
            } finally {
                this.loading = false;
            }
        },
        openAddModal() {
            this.isEditing = false;
            this.selectedCategory = null;
            this.formData = {
                nom: "",
                description: "",
                couleur: "#3b82f6",
            };
            this.showFormModal = true;
        },
        openEditModal(category) {
            this.isEditing = true;
            this.selectedCategory = category;
            this.formData = {
                nom: category.nom,
                description: category.description || "",
                couleur: category.couleur || "#3b82f6",
            };
            this.showFormModal = true;
        },
        closeFormModal() {
            this.showFormModal = false;
            this.formData = {
                nom: "",
                description: "",
                couleur: "#3b82f6",
            };
        },
        confirmDelete(category) {
            this.categoryToDelete = category;
            this.showDeleteModal = true;
        },
        async handleSubmit() {
            if (!this.formData.nom.trim()) return;

            this.saving = true;
            try {
                if (this.isEditing) {
                    await updateCategory(
                        this.selectedCategory.id,
                        this.formData,
                    );
                } else {
                    await createCategory(this.formData);
                }
                await this.loadCategories();
                this.closeFormModal();
            } catch (error) {
                console.error("Erreur lors de l'enregistrement:", error);
            } finally {
                this.saving = false;
            }
        },
        async handleDelete() {
            if (!this.categoryToDelete) return;

            this.deleting = true;
            try {
                await deleteCategory(this.categoryToDelete.id);
                await this.loadCategories();
                this.showDeleteModal = false;
                this.categoryToDelete = null;
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
/* ===== CATEGORIES PAGE - LIQUID GLASS ===== */
.categories-page {
    min-height: 100vh;
    position: relative;
    z-index: 1;
}

/* Header - Glass transparent neutre */
.page-header {
    position: relative;
    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(20px) saturate(120%);
    -webkit-backdrop-filter: blur(20px) saturate(120%);
    border-bottom: 1px solid rgba(0, 0, 0, 0.06);
    padding: var(--spacing-8);
    box-shadow: var(--shadow-glass);
    animation: headerSlideIn 0.6s var(--transition-spring) forwards;
}

/* Reflet header */
.page-header::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 50%;
    background: linear-gradient(
        180deg,
        rgba(255, 255, 255, 0.5) 0%,
        transparent 100%
    );
    pointer-events: none;
}

@keyframes headerSlideIn {
    from {
        opacity: 0;
        transform: translateY(-30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.header-content {
    position: relative;
    max-width: 1200px;
    margin: 0 auto;
}

.header-title {
    display: flex;
    align-items: center;
    gap: var(--spacing-4);
}

/* Back link - Pill style */
.back-link {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 44px;
    height: 44px;
    border-radius: var(--radius-full);
    color: var(--color-text-primary);
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(0, 0, 0, 0.06);
    transition: all var(--transition-bounce);
    box-shadow: var(--shadow-glass);
}

.back-link:hover {
    background: rgba(255, 255, 255, 0.8);
    transform: translateX(-4px) scale(1.05);
    box-shadow: var(--shadow-glass-hover);
}

.header-title h1 {
    margin: 0;
    font-size: var(--font-size-2xl);
    font-weight: var(--font-weight-bold);
    color: var(--color-text-primary);
}

.header-subtitle {
    margin: var(--spacing-2) 0 0 0;
    color: var(--color-text-secondary);
    padding-left: calc(44px + var(--spacing-4));
}

/* Actions bar - Floating glass */
.actions-bar {
    position: relative;
    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(20px) saturate(120%);
    -webkit-backdrop-filter: blur(20px) saturate(120%);
    border-bottom: 1px solid rgba(0, 0, 0, 0.06);
    padding: var(--spacing-5) var(--spacing-8);
    box-shadow: var(--shadow-glass);
    animation: fadeInDown 0.5s var(--transition-spring) 0.2s forwards;
    opacity: 100;
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

.actions-container {
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: var(--spacing-4);
}

.search-input {
    width: 320px;
}

.categories-content {
    max-width: 1200px;
    margin: 0 auto;
    padding: var(--spacing-8);
}

/* Loading & Empty - Glass panels */
.loading-state,
.empty-state {
    text-align: center;
    padding: var(--spacing-12);
    color: var(--color-text-secondary);
    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(20px) saturate(120%);
    -webkit-backdrop-filter: blur(20px) saturate(120%);
    border-radius: var(--radius-2xl);
    border: 1px solid rgba(0, 0, 0, 0.06);
    box-shadow: var(--shadow-glass);
}

.empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.empty-state p {
    margin-bottom: var(--spacing-4);
    color: var(--color-text-primary);
}

/* Categories grid */
.categories-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: var(--spacing-5);
}

/* Category card - Liquid glass */
.category-card {
    position: relative;
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(20px) saturate(120%);
    -webkit-backdrop-filter: blur(20px) saturate(120%);
    border: 1px solid rgba(0, 0, 0, 0.06);
    border-radius: var(--radius-2xl);
    padding: var(--spacing-5);
    display: flex;
    align-items: center;
    gap: var(--spacing-4);
    transition: all var(--transition-bounce);
    animation: cardSlideIn 0.5s var(--transition-spring) forwards;
    opacity: 0;
    overflow: hidden;
}

/* Reflet card */
.category-card::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 50%;
    background: linear-gradient(
        180deg,
        rgba(255, 255, 255, 0.5) 0%,
        transparent 100%
    );
    pointer-events: none;
    border-radius: var(--radius-2xl) var(--radius-2xl) 0 0;
}

.category-card:nth-child(1) {
    animation-delay: 0.1s;
}
.category-card:nth-child(2) {
    animation-delay: 0.15s;
}
.category-card:nth-child(3) {
    animation-delay: 0.2s;
}
.category-card:nth-child(4) {
    animation-delay: 0.25s;
}
.category-card:nth-child(5) {
    animation-delay: 0.3s;
}
.category-card:nth-child(6) {
    animation-delay: 0.35s;
}
.category-card:nth-child(n + 7) {
    animation-delay: 0.4s;
}

@keyframes cardSlideIn {
    from {
        opacity: 0;
        transform: translateY(30px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

.category-card:hover {
    box-shadow: var(--shadow-glass-hover);
    transform: translateY(-6px) scale(1.02);
    background: rgba(255, 255, 255, 0.85);
    border-color: rgba(56, 189, 248, 0.3);
}

/* Color indicator with glow */
.category-color {
    position: relative;
    width: 56px;
    height: 56px;
    border-radius: var(--radius-xl);
    flex-shrink: 0;
    box-shadow:
        0 8px 24px rgba(0, 0, 0, 0.2),
        0 0 30px rgba(var(--glow-color), 0.3);
    transition: all var(--transition-bounce);
}

.category-card:hover .category-color {
    transform: scale(1.15) rotate(5deg);
    box-shadow:
        0 12px 32px rgba(0, 0, 0, 0.25),
        0 0 40px rgba(var(--glow-color), 0.4);
}

.category-info {
    flex: 1;
    min-width: 0;
    position: relative;
}

.category-info h3 {
    margin: 0;
    font-size: var(--font-size-lg);
    font-weight: var(--font-weight-semibold);
    color: var(--color-text-primary);
}

.category-description {
    margin: var(--spacing-1) 0 0 0;
    font-size: var(--font-size-sm);
    color: var(--color-text-secondary);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.category-actions {
    position: relative;
    display: flex;
    gap: var(--spacing-2);
}

/* Form styles */
.category-form {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-5);
}

.color-picker-field label {
    display: block;
    font-size: var(--font-size-sm);
    font-weight: var(--font-weight-medium);
    color: var(--color-text-primary);
    margin-bottom: var(--spacing-3);
}

.color-options {
    display: flex;
    gap: var(--spacing-3);
    flex-wrap: wrap;
    align-items: center;
}

.color-option {
    width: 40px;
    height: 40px;
    border-radius: var(--radius-full);
    border: 2.5px solid rgba(255, 255, 255, 0.3);
    cursor: pointer;
    transition: all var(--transition-bounce);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.color-option:hover {
    transform: scale(1.15) translateY(-3px);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
}

.color-option.active {
    border-color: var(--color-text-primary);
    box-shadow:
        0 0 0 3px rgba(255, 255, 255, 0.5),
        0 8px 20px rgba(0, 0, 0, 0.2);
    transform: scale(1.1);
}

.custom-color-input {
    width: 40px;
    height: 40px;
    border: none;
    border-radius: var(--radius-full);
    cursor: pointer;
    padding: 0;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    transition: all var(--transition-bounce);
}

.custom-color-input:hover {
    transform: scale(1.1);
}

.custom-color-input::-webkit-color-swatch-wrapper {
    padding: 0;
}

.custom-color-input::-webkit-color-swatch {
    border: none;
    border-radius: var(--radius-full);
}

.text-danger {
    color: var(--color-danger-light);
}

.text-muted {
    color: var(--color-text-secondary);
}

.text-sm {
    font-size: var(--font-size-sm);
}

/* ===== MOBILE ===== */
@media (max-width: 768px) {
    .page-header {
        padding: var(--spacing-5);
    }

    .header-title {
        gap: var(--spacing-3);
    }

    .back-link {
        width: 40px;
        height: 40px;
    }

    .header-title h1 {
        font-size: var(--font-size-lg);
    }

    .header-subtitle {
        padding-left: calc(40px + var(--spacing-3));
        font-size: var(--font-size-sm);
    }

    .actions-bar {
        padding: var(--spacing-4) var(--spacing-5);
    }

    .actions-container {
        flex-direction: column;
        gap: var(--spacing-3);
    }

    .search-input {
        width: 100%;
    }

    .categories-content {
        padding: var(--spacing-5);
    }

    .categories-grid {
        grid-template-columns: 1fr;
        gap: var(--spacing-4);
    }

    .category-card {
        padding: var(--spacing-4);
        border-radius: var(--radius-xl);
    }

    .category-color {
        width: 48px;
        height: 48px;
        border-radius: var(--radius-lg);
    }

    /* Touch interactions */
    .category-card:hover {
        transform: none;
        box-shadow: var(--shadow-glass);
    }

    .category-card:hover .category-color {
        transform: none;
    }

    .category-card:active {
        transform: scale(0.98);
        background: rgba(255, 255, 255, 0.2);
    }

    .back-link:hover {
        transform: none;
    }

    .back-link:active {
        transform: scale(0.95);
    }
}

/* Préférence mouvement réduit */
@media (prefers-reduced-motion: reduce) {
    .page-header,
    .actions-bar,
    .category-card {
        animation: none;
        opacity: 1;
    }

    .category-card,
    .category-color,
    .back-link,
    .color-option {
        transition: none;
    }
}
</style>
