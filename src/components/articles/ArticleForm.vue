<template>
  <BaseModal
    :model-value="modelValue"
    :title="isEditMode ? 'Modifier l\'article' : 'Ajouter un article'"
    size="md"
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
        v-model="form.categorie"
        label="Catégorie"
        :options="categorieOptions"
        :error="errors.categorie"
        required
      />
      
      <BaseInput
        v-model="form.photo"
        label="URL de la photo"
        placeholder="https://example.com/image.jpg"
        :error="errors.photo"
        required
      />
      
      <div v-if="form.photo" class="image-preview">
        <p class="preview-label">Aperçu :</p>
        <img :src="form.photo" :alt="form.nom" @error="handleImageError" />
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
import { BaseModal, BaseInput, BaseSelect, BaseButton } from '@/components/ui'
import { getCategories } from '@/services/articleService.js'

export default {
  name: 'ArticleForm',
  components: {
    BaseModal,
    BaseInput,
    BaseSelect,
    BaseButton
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
        prix: '',
        quantite: '',
        photo: '',
        categorie: ''
      },
      errors: {},
      categories: [],
      loading: false,
      imageError: false
    }
  },
  computed: {
    isEditMode() {
      return !!this.article
    },
    categorieOptions() {
      return this.categories.map(cat => ({
        value: cat,
        label: cat
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
          prix: this.article.prix.toString(),
          quantite: this.article.quantite.toString(),
          photo: this.article.photo,
          categorie: this.article.categorie
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
      
      if (!this.form.categorie) {
        this.errors.categorie = 'La catégorie est requise'
      }
      
      if (!this.form.photo.trim()) {
        this.errors.photo = 'L\'URL de la photo est requise'
      }
      
      return Object.keys(this.errors).length === 0
    },
    async handleSubmit() {
      if (!this.validate()) return
      
      this.loading = true
      
      try {
        const articleData = {
          nom: this.form.nom.trim(),
          prix: parseFloat(this.form.prix),
          quantite: parseInt(this.form.quantite),
          photo: this.form.photo.trim(),
          categorie: this.form.categorie
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
    resetForm() {
      this.form = {
        nom: '',
        prix: '',
        quantite: '',
        photo: '',
        categorie: ''
      }
      this.errors = {}
      this.imageError = false
    },
    close() {
      this.$emit('update:modelValue', false)
      this.resetForm()
    },
    handleImageError() {
      this.imageError = true
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

.image-preview {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-2);
}

.preview-label {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--color-text-secondary);
  margin: 0;
}

.image-preview img {
  max-width: 200px;
  max-height: 150px;
  object-fit: cover;
  border-radius: var(--border-radius-lg);
  border: var(--border-width-thin) solid var(--color-border-light);
}
</style>
