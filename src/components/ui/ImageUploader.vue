<template>
    <div class="image-uploader">
        <label v-if="label" class="uploader-label">{{ label }}</label>

        <div
            class="upload-zone"
            :class="{ 'has-image': hasImage, dragging: isDragging }"
        >
            <!-- Preview si image existante -->
            <div v-if="hasImage" class="image-preview">
                <img :src="imageUrl" :alt="label" @error="handleImageError" />
                <div class="image-actions">
                    <button
                        type="button"
                        class="action-btn change"
                        @click="triggerFileInput"
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
                                d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"
                            />
                            <polyline points="17 8 12 3 7 8" />
                            <line x1="12" y1="3" x2="12" y2="15" />
                        </svg>
                        Changer
                    </button>
                    <button
                        v-if="!required"
                        type="button"
                        class="action-btn remove"
                        @click="removeImage"
                    >
                        <svg
                            width="16"
                            height="16"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                        >
                            <polyline points="3 6 5 6 21 6" />
                            <path
                                d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"
                            />
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
                <svg
                    width="48"
                    height="48"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="1.5"
                >
                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                    <circle cx="8.5" cy="8.5" r="1.5" />
                    <polyline points="21 15 16 10 5 21" />
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
                <div
                    class="progress-fill"
                    :style="{ width: progress + '%' }"
                ></div>
            </div>
            <span class="progress-text">Upload en cours...</span>
        </div>

        <!-- Erreur -->
        <p v-if="error" class="upload-error">{{ error }}</p>
    </div>
</template>

<script>
import { uploadImage } from "@/services/storageService.js";

export default {
    name: "ImageUploader",
    props: {
        modelValue: {
            type: String,
            default: "",
        },
        label: {
            type: String,
            default: "",
        },
        required: {
            type: Boolean,
            default: false,
        },
        folder: {
            type: String,
            default: "images",
        },
    },
    emits: ["update:modelValue", "uploaded"],
    data() {
        return {
            isDragging: false,
            uploading: false,
            progress: 0,
            error: "",
            imageError: false,
        };
    },
    computed: {
        hasImage() {
            return !!this.modelValue && !this.imageError;
        },
        imageUrl() {
            return this.modelValue;
        },
    },
    watch: {
        modelValue(newVal) {
            // Quand le parent change modelValue, on update imageError
            if (newVal) {
                this.imageError = false;
            }
        },
    },
    methods: {
        triggerFileInput() {
            this.$refs.fileInput.click();
        },

        async handleFileSelect(event) {
            const file = event.target.files[0];
            if (file) {
                await this.uploadFile(file);
            }
            // Reset input pour pouvoir sélectionner le même fichier
            event.target.value = "";
        },

        async handleDrop(event) {
            this.isDragging = false;
            const file = event.dataTransfer.files[0];
            if (file && file.type.startsWith("image/")) {
                await this.uploadFile(file);
            }
        },

        async uploadFile(file) {
            this.error = "";
            this.uploading = true;
            this.progress = 0;

            try {
                // Simuler la progression
                const progressInterval = setInterval(() => {
                    if (this.progress < 90) {
                        this.progress += 10;
                    }
                }, 100);

                const result = await uploadImage(file, this.folder);

                clearInterval(progressInterval);
                this.progress = 100;

                // Émettre l'URL
                this.$emit("update:modelValue", result.url);
                this.$emit("uploaded", result);

                setTimeout(() => {
                    this.uploading = false;
                    this.progress = 0;
                }, 500);
            } catch (err) {
                this.error = err.message;
                this.uploading = false;
                this.progress = 0;
            }
        },

        removeImage() {
            this.$emit("update:modelValue", "");
            this.imageError = false;
        },

        handleImageError() {
            this.imageError = true;
        },
    },
};
</script>

<style scoped>
/* ===== IMAGE UPLOADER - LIQUID GLASS ===== */
.image-uploader {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-3);
}

.uploader-label {
    font-size: var(--font-size-sm);
    font-weight: var(--font-weight-medium);
    color: var(--color-text-primary);
}

/* Upload zone - Glass card */
.upload-zone {
    position: relative;
    border: 2px dashed rgba(0, 0, 0, 0.15);
    border-radius: var(--radius-2xl);
    transition: all var(--transition-bounce);
    overflow: hidden;
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(20px);
}

.upload-zone.dragging {
    border-color: rgba(56, 189, 248, 0.6);
    background: rgba(56, 189, 248, 0.08);
    transform: scale(1.02);
    box-shadow: 0 0 30px rgba(56, 189, 248, 0.15);
}

.upload-zone.has-image {
    border-style: solid;
    border-color: rgba(0, 0, 0, 0.08);
}

/* Drop zone */
.drop-zone {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: var(--spacing-10);
    cursor: pointer;
    transition: all var(--transition-bounce);
}

.drop-zone:hover {
    background: rgba(255, 255, 255, 0.8);
    transform: translateY(-2px);
}

.drop-zone svg {
    color: var(--color-text-secondary);
    margin-bottom: var(--spacing-4);
    opacity: 0.7;
    transition: all var(--transition-bounce);
}

.drop-zone:hover svg {
    color: var(--color-primary);
    opacity: 1;
    transform: scale(1.1);
}

.drop-text {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: var(--spacing-2);
    margin: 0;
}

.drop-text .primary {
    font-weight: var(--font-weight-semibold);
    color: var(--color-primary);
}

.drop-text .secondary {
    font-size: var(--font-size-sm);
    color: var(--color-text-secondary);
}

/* Image preview */
.image-preview {
    position: relative;
}

.image-preview img {
    width: 100%;
    max-height: 220px;
    object-fit: cover;
    display: block;
}

/* Actions overlay */
.image-actions {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    display: flex;
    gap: var(--spacing-2);
    padding: var(--spacing-3);
    background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
}

.action-btn {
    display: flex;
    align-items: center;
    gap: var(--spacing-2);
    padding: var(--spacing-2) var(--spacing-4);
    border: none;
    border-radius: var(--radius-full);
    font-size: var(--font-size-sm);
    font-weight: var(--font-weight-medium);
    cursor: pointer;
    transition: all var(--transition-bounce);
    backdrop-filter: blur(10px);
}

.action-btn.change {
    background: rgba(255, 255, 255, 0.9);
    color: var(--color-gray-800);
}

.action-btn.change:hover {
    background: white;
    transform: translateY(-2px) scale(1.02);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
}

.action-btn.remove {
    background: rgba(239, 68, 68, 0.9);
    color: white;
}

.action-btn.remove:hover {
    background: rgba(239, 68, 68, 1);
    transform: translateY(-2px) scale(1.02);
    box-shadow: 0 8px 20px rgba(239, 68, 68, 0.3);
}

/* Progress bar */
.upload-progress {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-2);
}

.progress-bar {
    height: 6px;
    background: rgba(0, 0, 0, 0.08);
    border-radius: var(--radius-full);
    overflow: hidden;
}

.progress-fill {
    height: 100%;
    background: linear-gradient(90deg, var(--color-primary) 0%, #38bdf8 100%);
    border-radius: var(--radius-full);
    transition: width 0.3s ease;
    box-shadow: 0 0 10px rgba(56, 189, 248, 0.4);
}

.progress-text {
    font-size: var(--font-size-xs);
    color: var(--color-text-secondary);
}

.upload-error {
    color: #dc2626;
    font-size: var(--font-size-sm);
    margin: 0;
}

/* Mobile */
@media (max-width: 768px) {
    .drop-zone {
        padding: var(--spacing-8);
    }

    .drop-zone:hover {
        transform: none;
    }

    .drop-zone:active {
        background: rgba(255, 255, 255, 0.8);
    }

    .action-btn:hover {
        transform: none;
    }

    .action-btn:active {
        transform: scale(0.95);
    }
}
</style>
