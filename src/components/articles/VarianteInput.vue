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
    <BaseCard
      v-if="isAddingVariante"
      variant="outlined"
      class="variante-form-card"
    >
      <div class="form-group">
        <label>Type de variante</label>
        <BaseInput
          v-model="newVariante.nom_variante"
          placeholder="Ex: Couleur, Taille, Modèle..."
          size="md"
          full-width
        />
      </div>

      <div class="form-group">
        <label>Valeur</label>
        <BaseInput
          v-model="newVariante.valeur"
          placeholder="Ex: Noir, M, Pro..."
          size="md"
          full-width
        />
      </div>

      <div class="form-group">
        <label>Image (optionnel)</label>
        <ImageUploader
          v-model:image-url="newVariante.image_url"
          placeholder="Uploader une image de la variante"
        />
      </div>

      <div class="form-actions">
        <BaseButton
          variant="secondary"
          size="sm"
          @click="addVariante"
          full-width
        >
          Ajouter
        </BaseButton>
        <BaseButton
          variant="ghost"
          size="sm"
          @click="cancelAddVariante"
          full-width
        >
          Annuler
        </BaseButton>
      </div>
    </BaseCard>

    <!-- Liste des variantes -->
    <div class="variantes-list">
      <div
        v-if="variantes.length === 0"
        class="empty-state"
      >
        <p>Aucune variante pour le moment</p>
      </div>

      <div
        v-for="(variante, index) in variantes"
        :key="variante.id || index"
        class="variante-item"
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
            variant="ghost"
            size="sm"
            @click="editVariante(variante)"
          >
            ✏️
          </BaseButton>
          <BaseButton
            variant="danger"
            size="sm"
            @click="deleteVariante(variante.id || index)"
          >
            🗑️
          </BaseButton>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { BaseInput, BaseButton, BaseCard } from '@/components/ui'
import ImageUploader from '@/components/ui/ImageUploader.vue'

export default {
  name: 'VarianteInput',
  components: {
    BaseInput,
    BaseButton,
    BaseCard,
    ImageUploader
  },
  props: {
    modelValue: {
      type: Array,
      default: () => []
    },
    loading: {
      type: Boolean,
      default: false
    }
  },
  emits: ['update:modelValue', 'add', 'delete'],
  data() {
    return {
      variantes: [],
      isAddingVariante: false,
      newVariante: {
        nom_variante: '',
        valeur: '',
        image_url: ''
      }
    }
  },
  watch: {
    modelValue(newVal) {
      this.variantes = [...newVal]
    }
  },
  mounted() {
    this.variantes = [...this.modelValue]
  },
  methods: {
    addVariante() {
      if (!this.newVariante.nom_variante || !this.newVariante.valeur) {
        alert('Veuillez remplir le type et la valeur de la variante')
        return
      }

      const variante = {
        ...this.newVariante,
        id: Date.now() // ID temporaire avant sauvegarde en BD
      }

      this.variantes.push(variante)
      this.$emit('update:modelValue', this.variantes)
      this.$emit('add', variante)

      this.resetForm()
    },
    editVariante(variante) {
      // TODO: Implémenter l'édition
      console.log('Edit variante:', variante)
    },
    deleteVariante(id) {
      const index = this.variantes.findIndex(v => v.id === id || this.variantes.indexOf(v) === id)
      if (index > -1) {
        const removedVariante = this.variantes[index]
        this.variantes.splice(index, 1)
        this.$emit('update:modelValue', this.variantes)
        this.$emit('delete', removedVariante.id || id)
      }
    },
    cancelAddVariante() {
      this.resetForm()
    },
    resetForm() {
      this.newVariante = {
        nom_variante: '',
        valeur: '',
        image_url: ''
      }
      this.isAddingVariante = false
    }
  }
}
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
