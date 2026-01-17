<template>
  <div class="image-uploader">
    <label v-if="label" class="uploader-label">{{ label }}</label>
    
    <div class="upload-zone" :class="{ 'has-image': hasImage, 'dragging': isDragging }">
      <!-- Preview si image existante -->
      <div v-if="hasImage" class="image-preview">
        <img :src="imageUrl" :alt="label" @error="handleImageError" />
        <div class="image-actions">
          <button type="button" class="action-btn change" @click="triggerFileInput">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
              <polyline points="17 8 12 3 7 8"/>
              <line x1="12" y1="3" x2="12" y2="15"/>
            </svg>
            Changer
          </button>
          <button v-if="!required" type="button" class="action-btn remove" @click="removeImage">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <polyline points="3 6 5 6 21 6"/>
              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
            </svg>
            Supprimer
          </button>
        </div>
      </div>
      
      <!-- Zone de drop si pas d'image -->
      <div 
        v-else 
        class="drop-zone"
        @click="triggerFileInput"
        @dragover.prevent="isDragging = true"
        @dragleave.prevent="isDragging = false"
        @drop.prevent="handleDrop"
      >
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
          <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
          <circle cx="8.5" cy="8.5" r="1.5"/>
          <polyline points="21 15 16 10 5 21"/>
        </svg>
        <p class="drop-text">
          <span class="primary">Cliquez ou déposez une image</span>
          <span class="secondary">JPG, PNG, WebP • Max 5MB</span>
        </p>
      </div>
    </div>
    
    <!-- Input file caché -->
    <input
      ref="fileInput"
      type="file"
      accept="image/jpeg,image/png,image/webp,image/gif"
      :required="required && !hasImage"
      @change="handleFileSelect"
      style="display: none"
    />
    
    <!-- Barre de progression -->
    <div v-if="uploading" class="upload-progress">
      <div class="progress-bar">
        <div class="progress-fill" :style="{ width: progress + '%' }"></div>
      </div>
      <span class="progress-text">Upload en cours...</span>
    </div>
    
    <!-- Erreur -->
    <p v-if="error" class="upload-error">{{ error }}</p>
  </div>
</template>

<script>
import { uploadImage } from '@/services/storageService.js'

export default {
  name: 'ImageUploader',
  props: {
    modelValue: {
      type: String,
      default: ''
    },
    label: {
      type: String,
      default: ''
    },
    required: {
      type: Boolean,
      default: false
    },
    folder: {
      type: String,
      default: 'images'
    }
  },
  emits: ['update:modelValue', 'uploaded'],
  data() {
    return {
      isDragging: false,
      uploading: false,
      progress: 0,
      error: '',
      imageError: false
    }
  },
  computed: {
    hasImage() {
      return !!this.modelValue && !this.imageError
    },
    imageUrl() {
      return this.modelValue
    }
  },
  methods: {
    triggerFileInput() {
      this.$refs.fileInput.click()
    },
    
    async handleFileSelect(event) {
      const file = event.target.files[0]
      if (file) {
        await this.uploadFile(file)
      }
      // Reset input pour pouvoir sélectionner le même fichier
      event.target.value = ''
    },
    
    async handleDrop(event) {
      this.isDragging = false
      const file = event.dataTransfer.files[0]
      if (file && file.type.startsWith('image/')) {
        await this.uploadFile(file)
      }
    },
    
    async uploadFile(file) {
      this.error = ''
      this.uploading = true
      this.progress = 0
      
      try {
        // Simuler la progression
        const progressInterval = setInterval(() => {
          if (this.progress < 90) {
            this.progress += 10
          }
        }, 100)
        
        const result = await uploadImage(file, this.folder)
        
        clearInterval(progressInterval)
        this.progress = 100
        
        // Émettre l'URL
        this.$emit('update:modelValue', result.url)
        this.$emit('uploaded', result)
        
        setTimeout(() => {
          this.uploading = false
          this.progress = 0
        }, 500)
        
      } catch (err) {
        this.error = err.message
        this.uploading = false
        this.progress = 0
      }
    },
    
    removeImage() {
      this.$emit('update:modelValue', '')
      this.imageError = false
    },
    
    handleImageError() {
      this.imageError = true
    }
  }
}
</script>

<style scoped>
.image-uploader {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-2);
}

.uploader-label {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--color-text-primary);
}

.upload-zone {
  border: 2px dashed var(--color-border);
  border-radius: var(--border-radius-lg);
  transition: all 0.2s ease;
  overflow: hidden;
}

.upload-zone.dragging {
  border-color: var(--color-primary);
  background-color: var(--color-primary-light);
}

.upload-zone.has-image {
  border-style: solid;
  border-color: var(--color-border-light);
}

.drop-zone {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--spacing-8);
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.drop-zone:hover {
  background-color: var(--color-bg-secondary);
}

.drop-zone svg {
  color: var(--color-text-muted);
  margin-bottom: var(--spacing-4);
}

.drop-text {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--spacing-1);
  margin: 0;
}

.drop-text .primary {
  font-weight: var(--font-weight-medium);
  color: var(--color-primary);
}

.drop-text .secondary {
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
}

.image-preview {
  position: relative;
}

.image-preview img {
  width: 100%;
  max-height: 200px;
  object-fit: cover;
  display: block;
}

.image-actions {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  gap: var(--spacing-2);
  padding: var(--spacing-2);
  background: linear-gradient(transparent, rgba(0,0,0,0.7));
}

.action-btn {
  display: flex;
  align-items: center;
  gap: var(--spacing-1);
  padding: var(--spacing-2) var(--spacing-3);
  border: none;
  border-radius: var(--border-radius-md);
  font-size: var(--font-size-sm);
  cursor: pointer;
  transition: all 0.2s ease;
}

.action-btn.change {
  background-color: white;
  color: var(--color-text-primary);
}

.action-btn.change:hover {
  background-color: var(--color-bg-secondary);
}

.action-btn.remove {
  background-color: var(--color-error);
  color: white;
}

.action-btn.remove:hover {
  opacity: 0.9;
}

.upload-progress {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-1);
}

.progress-bar {
  height: 4px;
  background-color: var(--color-bg-tertiary);
  border-radius: 2px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background-color: var(--color-primary);
  transition: width 0.2s ease;
}

.progress-text {
  font-size: var(--font-size-xs);
  color: var(--color-text-muted);
}

.upload-error {
  color: var(--color-error);
  font-size: var(--font-size-sm);
  margin: 0;
}
</style>
