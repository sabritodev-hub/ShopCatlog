<template>
  <BaseModal
    :model-value="modelValue"
    :title="isEditMode ? 'Modifier l\'article' : 'Ajouter un article'"
    size="lg"
    @update:model-value="$emit('update:modelValue', $event)"
    @close="resetForm"
  >
    <form @submit.prevent="handleSubmit" class="article-form">
      <BaseInput
        v-model="form.nom"
        label="Nom de l'article"
        placeholder="Ex: iPhone 15 Pro"
        :error="errors.nom"
        required
      />
      
      <BaseInput
        v-model="form.description"
        label="Description"
        placeholder="Description détaillée de l'article..."
        :error="errors.description"
      />
      
      <div class="form-row">
        <BaseInput
          v-model="form.prix"
          type="number"
          label="Prix (€)"
          placeholder="0.00"
          :min="0"
          :step="0.01"
          :error="errors.prix"
          required
        />
        
        <BaseInput
          v-model="form.quantite"
          type="number"
          label="Quantité"
          placeholder="0"
          :min="0"
          :error="errors.quantite"
          required
        />
      </div>
      
      <BaseSelect
        v-model="form.categorie_id"
        label="Catégorie"
        :options="categorieOptions"
        :error="errors.categorie_id"
        required
      />
      
      <!-- Photo de couverture -->
      <div class="photos-section">
        <h3 class="section-title">Photo de couverture *</h3>
        <ImageUploader
          v-model="form.photo"
          folder="covers"
          required
          @uploaded="handleCoverUploaded"
        />
        <p v-if="errors.photo" class="field-error">{{ errors.photo }}</p>
      </div>
      
      <!-- Photos supplémentaires -->
      <div class="photos-section">
        <h3 class="section-title">Photos supplémentaires (optionnel)</h3>
        <p class="section-description">Ajoutez jusqu'à 4 photos supplémentaires pour la galerie</p>
        
        <div class="gallery-grid">
          <ImageUploader
            v-model="form.photo_2"
            label="Photo 2"
            folder="gallery"
          />
          <ImageUploader
            v-model="form.photo_3"
            label="Photo 3"
            folder="gallery"
          />
          <ImageUploader
            v-model="form.photo_4"
            label="Photo 4"
            folder="gallery"
          />
          <ImageUploader
            v-model="form.photo_5"
            label="Photo 5"
            folder="gallery"
          />
        </div>
      </div>
    </form>
    
    <template #footer>
      <BaseButton variant="ghost" @click="close">
        Annuler
      </BaseButton>
      <BaseButton 
        variant="primary" 
        :loading="loading"
        @click="handleSubmit"
      >
        {{ isEditMode ? 'Modifier' : 'Ajouter' }}
      </BaseButton>
    </template>
  </BaseModal>
</template>

<script>
import { BaseModal, BaseInput, BaseSelect, BaseButton, ImageUploader } from '@/components/ui'
import { getCategories } from '@/services/categoryService.js'

export default {
  name: 'ArticleForm',
  components: {
    BaseModal,
    BaseInput,
    BaseSelect,
    BaseButton,
    ImageUploader
  },
  props: {
    modelValue: {
      type: Boolean,
      default: false
    },
    article: {
      type: Object,
      default: null
    }
  },
  emits: ['update:modelValue', 'submit'],
  data() {
    return {
      form: {
        nom: '',
        description: '',
        prix: '',
        quantite: '',
        photo: '',
        photo_2: '',
        photo_3: '',
        photo_4: '',
        photo_5: '',
        categorie_id: ''
      },
      errors: {},
      categories: [],
      loading: false
    }
  },
  computed: {
    isEditMode() {
      return !!this.article
    },
    categorieOptions() {
      return this.categories.map(cat => ({
        value: cat.id.toString(),
        label: cat.nom
      }))
    }
  },
  watch: {
    modelValue(newValue) {
      if (newValue) {
        this.loadCategories()
        if (this.article) {
          this.populateForm()
        }
      }
    },
    article: {
      handler(newArticle) {
        if (newArticle && this.modelValue) {
          this.populateForm()
        }
      },
      immediate: true
    }
  },
  methods: {
    async loadCategories() {
      this.categories = await getCategories()
    },
    populateForm() {
      if (this.article) {
        this.form = {
          nom: this.article.nom,
          description: this.article.description || '',
          prix: this.article.prix.toString(),
          quantite: this.article.quantite.toString(),
          photo: this.article.photo,
          photo_2: this.article.photo_2 || '',
          photo_3: this.article.photo_3 || '',
          photo_4: this.article.photo_4 || '',
          photo_5: this.article.photo_5 || '',
          categorie_id: this.article.categorie_id?.toString() || ''
        }
      }
    },
    validate() {
      this.errors = {}
      
      if (!this.form.nom.trim()) {
        this.errors.nom = 'Le nom est requis'
      }
      
      if (!this.form.prix || parseFloat(this.form.prix) < 0) {
        this.errors.prix = 'Le prix doit être positif'
      }
      
      if (!this.form.quantite || parseInt(this.form.quantite) < 0) {
        this.errors.quantite = 'La quantité doit être positive'
      }
      
      if (!this.form.categorie_id) {
        this.errors.categorie_id = 'La catégorie est requise'
      }
      
      if (!this.form.photo.trim()) {
        this.errors.photo = 'La photo de couverture est requise'
      }
      
      return Object.keys(this.errors).length === 0
    },
    async handleSubmit() {
      if (!this.validate()) return
      
      this.loading = true
      
      try {
        const articleData = {
          nom: this.form.nom.trim(),
          description: this.form.description.trim() || null,
          prix: parseFloat(this.form.prix),
          quantite: parseInt(this.form.quantite),
          photo: this.form.photo.trim(),
          photo_2: this.form.photo_2.trim() || null,
          photo_3: this.form.photo_3.trim() || null,
          photo_4: this.form.photo_4.trim() || null,
          photo_5: this.form.photo_5.trim() || null,
          categorie_id: parseInt(this.form.categorie_id)
        }
        
        if (this.isEditMode) {
          articleData.id = this.article.id
        }
        
        this.$emit('submit', articleData)
        this.close()
      } finally {
        this.loading = false
      }
    },
    handleCoverUploaded(result) {
      console.log('Photo de couverture uploadée:', result.url)
    },
    resetForm() {
      this.form = {
        nom: '',
        description: '',
        prix: '',
        quantite: '',
        photo: '',
        photo_2: '',
        photo_3: '',
        photo_4: '',
        photo_5: '',
        categorie_id: ''
      }
      this.errors = {}
    },
    close() {
      this.$emit('update:modelValue', false)
      this.resetForm()
    }
  }
}
</script>

<style scoped>
.article-form {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-4);
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--spacing-4);
}

@media (max-width: 480px) {
  .form-row {
    grid-template-columns: 1fr;
  }
}

.photos-section {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-2);
  padding-top: var(--spacing-4);
  border-top: 1px solid var(--color-border-light);
}

.section-title {
  font-size: var(--font-size-md);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin: 0;
}

.section-description {
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
  margin: 0;
}

.gallery-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: var(--spacing-3);
}

@media (max-width: 600px) {
  .gallery-grid {
    grid-template-columns: 1fr;
  }
}

.field-error {
  color: var(--color-error);
  font-size: var(--font-size-sm);
  margin: 0;
}
</style>
