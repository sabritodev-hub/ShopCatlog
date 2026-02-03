<template>
    <div class="variante-input">
        <div class="variante-header">
            <h3>Variantes de l'article</h3>
            <BaseButton
                variant="primary"
                size="sm"
                @click="isAddingVariante = true"
            >
                + Ajouter une variante
            </BaseButton>
        </div>

        <!-- Formulaire d'ajout de variante -->
        <BaseCard v-if="isAddingVariante" class="variante-form-card">
            <div class="form-group">
                <label>Type de variante</label>
                <BaseInput
                    v-model="newVariante.nom_variante"
                    placeholder="Ex: Couleur, Taille, Modèle..."
                    size="md"
                    :full-width="true"
                />
            </div>

            <div class="form-group">
                <label>Valeur</label>
                <BaseInput
                    v-model="newVariante.valeur"
                    placeholder="Ex: Noir, M, Pro..."
                    size="md"
                    :full-width="true"
                />
            </div>

            <div class="form-group">
                <label>Image (optionnel)</label>
                <ImageUploader
                    v-model="newVariante.image_url"
                    folder="variants"
                />
            </div>

            <div class="form-actions">
                <BaseButton
                    variant="secondary"
                    size="sm"
                    @click="addVariante"
                    :full-width="true"
                >
                    Ajouter
                </BaseButton>
                <BaseButton
                    variant="ghost"
                    size="sm"
                    @click="cancelAddVariante"
                    :full-width="true"
                >
                    Annuler
                </BaseButton>
            </div>
        </BaseCard>

        <!-- Liste des variantes -->
        <div class="variantes-list">
            <div v-if="variantes.length === 0" class="empty-state">
                <p>Aucune variante pour le moment</p>
            </div>

            <div
                v-for="(variante, index) in variantes"
                :key="variante._tempId || variante.id || index"
                class="variante-item"
                :class="{ 'variante-deleted': variante._deleted }"
            >
                <div class="variante-info">
                    <div class="variante-type">{{ variante.nom_variante }}</div>
                    <div class="variante-value">{{ variante.valeur }}</div>
                    <img
                        v-if="variante.image_url"
                        :src="variante.image_url"
                        :alt="variante.valeur"
                        class="variante-image"
                    />
                </div>

                <div class="variante-actions">
                    <BaseButton
                        variant="danger"
                        size="sm"
                        @click="deleteVariante(index)"
                    >
                        🗑️
                    </BaseButton>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import {
    BaseInput,
    BaseButton,
    BaseCard,
    ImageUploader,
} from "@/components/ui";

export default {
    name: "VarianteInput",
    components: {
        BaseInput,
        BaseButton,
        BaseCard,
        ImageUploader,
    },
    props: {
        modelValue: {
            type: Array,
            default: () => [],
        },
    },
    emits: ["update:modelValue"],
    data() {
        return {
            variantes: [],
            isAddingVariante: false,
            nextTempId: 1,
            newVariante: {
                nom_variante: "",
                valeur: "",
                image_url: "",
            },
        };
    },
    watch: {
        modelValue(newVal) {
            if (Array.isArray(newVal)) {
                this.variantes = JSON.parse(JSON.stringify(newVal));
                // Initialiser les tempIds si manquants
                this.variantes.forEach((v, idx) => {
                    if (!v._tempId && !v.id) {
                        v._tempId = `temp_${Date.now()}_${idx}`;
                    }
                });
            }
        },
    },
    mounted() {
        if (this.modelValue && Array.isArray(this.modelValue)) {
            this.variantes = JSON.parse(JSON.stringify(this.modelValue));
            this.variantes.forEach((v, idx) => {
                if (!v._tempId && !v.id) {
                    v._tempId = `temp_${Date.now()}_${idx}`;
                }
            });
        }
    },
    methods: {
        addVariante() {
            if (
                !this.newVariante.nom_variante.trim() ||
                !this.newVariante.valeur.trim()
            ) {
                alert("Veuillez remplir le type et la valeur de la variante");
                return;
            }

            const variante = {
                _tempId: `temp_${Date.now()}_${this.nextTempId++}`,
                nom_variante: this.newVariante.nom_variante,
                valeur: this.newVariante.valeur,
                image_url: this.newVariante.image_url || null,
            };

            this.variantes.push(variante);
            this.$emit("update:modelValue", this.variantes);
            this.resetForm();
        },
        deleteVariante(index) {
            // Marquer comme supprimé ou supprimer directement
            const variante = this.variantes[index];
            if (variante.id) {
                // Si c'est une variante existante (avec ID BD), la marquer comme supprimée
                variante._deleted = true;
            } else {
                // Si c'est une nouvelle variante, la supprimer directement
                this.variantes.splice(index, 1);
            }
            this.$emit("update:modelValue", this.variantes);
        },
        cancelAddVariante() {
            this.resetForm();
        },
        resetForm() {
            this.newVariante = {
                nom_variante: "",
                valeur: "",
                image_url: "",
            };
            this.isAddingVariante = false;
        },
    },
};
</script>

<style scoped>
.variante-input {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.variante-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 12px;
}

.variante-header h3 {
    margin: 0;
    font-size: 18px;
    font-weight: 600;
    color: #111827;
}

.variante-form-card {
    padding: 20px;
    margin-bottom: 20px;
}

.form-group {
    margin-bottom: 16px;
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.form-group label {
    font-size: 14px;
    font-weight: 500;
    color: #374151;
}

.form-actions {
    display: flex;
    gap: 12px;
    margin-top: 16px;
}

.variantes-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.empty-state {
    text-align: center;
    padding: 40px 20px;
    color: #6b7280;
    background: #f9fafb;
    border-radius: 12px;
    border: 1px dashed #d1d5db;
}

.variante-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16px;
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    transition: all 250ms ease;
}

.variante-item:hover {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    border-color: #d1d5db;
}

.variante-item.variante-deleted {
    opacity: 0.5;
    background: #fef2f2;
    border-color: #fecaca;
}

.variante-info {
    flex: 1;
    display: flex;
    align-items: center;
    gap: 12px;
}

.variante-type {
    font-size: 12px;
    font-weight: 600;
    color: #6366f1;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.variante-value {
    font-size: 16px;
    font-weight: 500;
    color: #111827;
}

.variante-image {
    width: 48px;
    height: 48px;
    object-fit: cover;
    border-radius: 8px;
    border: 1px solid #e5e7eb;
}

.variante-actions {
    display: flex;
    gap: 8px;
}

@media (max-width: 768px) {
    .variante-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 12px;
    }

    .variante-item {
        flex-direction: column;
        align-items: flex-start;
    }

    .variante-actions {
        width: 100%;
        margin-top: 12px;
    }
}
</style>
