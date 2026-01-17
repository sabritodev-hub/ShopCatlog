<template>
  <Teleport to="body">
    <Transition name="modal">
      <div v-if="modelValue" class="modal-overlay" @click.self="handleOverlayClick">
        <div :class="modalClasses" role="dialog" aria-modal="true">
          <!-- Header -->
          <div v-if="$slots.header || title" class="modal-header">
            <slot name="header">
              <h2 class="modal-title">{{ title }}</h2>
            </slot>
            <button
              v-if="showClose"
              class="modal-close"
              @click="close"
              aria-label="Fermer"
            >
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            </button>
          </div>
          
          <!-- Body -->
          <div class="modal-body">
            <slot></slot>
          </div>
          
          <!-- Footer -->
          <div v-if="$slots.footer" class="modal-footer">
            <slot name="footer"></slot>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script>
export default {
  name: 'BaseModal',
  props: {
    modelValue: {
      type: Boolean,
      default: false
    },
    title: {
      type: String,
      default: ''
    },
    size: {
      type: String,
      default: 'md',
      validator: (value) => ['sm', 'md', 'lg', 'xl', 'full'].includes(value)
    },
    showClose: {
      type: Boolean,
      default: true
    },
    closeOnOverlay: {
      type: Boolean,
      default: true
    },
    closeOnEscape: {
      type: Boolean,
      default: true
    }
  },
  emits: ['update:modelValue', 'close'],
  computed: {
    modalClasses() {
      return [
        'modal',
        `modal-${this.size}`
      ]
    }
  },
  watch: {
    modelValue(newValue) {
      if (newValue) {
        document.body.style.overflow = 'hidden'
        document.addEventListener('keydown', this.handleEscape)
      } else {
        document.body.style.overflow = ''
        document.removeEventListener('keydown', this.handleEscape)
      }
    }
  },
  beforeUnmount() {
    document.body.style.overflow = ''
    document.removeEventListener('keydown', this.handleEscape)
  },
  methods: {
    close() {
      this.$emit('update:modelValue', false)
      this.$emit('close')
    },
    handleOverlayClick() {
      if (this.closeOnOverlay) {
        this.close()
      }
    },
    handleEscape(event) {
      if (event.key === 'Escape' && this.closeOnEscape) {
        this.close()
      }
    }
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  inset: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: var(--spacing-4);
  z-index: var(--z-index-modal);
  backdrop-filter: blur(2px);
}

.modal {
  background-color: var(--color-white);
  border-radius: var(--border-radius-xl);
  box-shadow: var(--shadow-2xl);
  display: flex;
  flex-direction: column;
  max-height: 90vh;
  overflow: hidden;
}

/* Sizes */
.modal-sm {
  width: 100%;
  max-width: 400px;
}

.modal-md {
  width: 100%;
  max-width: 560px;
}

.modal-lg {
  width: 100%;
  max-width: 720px;
}

.modal-xl {
  width: 100%;
  max-width: 960px;
}

.modal-full {
  width: calc(100% - var(--spacing-8));
  height: calc(100% - var(--spacing-8));
  max-width: none;
  max-height: none;
}

/* Header */
.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--spacing-4) var(--spacing-6);
  border-bottom: var(--border-width-thin) solid var(--color-border-light);
}

.modal-title {
  font-size: var(--font-size-xl);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin: 0;
}

.modal-close {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: var(--border-radius-md);
  color: var(--color-text-muted);
  transition: all var(--transition-fast);
}

.modal-close:hover {
  background-color: var(--color-gray-100);
  color: var(--color-text-primary);
}

/* Body */
.modal-body {
  padding: var(--spacing-6);
  overflow-y: auto;
  flex: 1;
}

/* Footer */
.modal-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: var(--spacing-3);
  padding: var(--spacing-4) var(--spacing-6);
  border-top: var(--border-width-thin) solid var(--color-border-light);
}

/* Transition */
.modal-enter-active,
.modal-leave-active {
  transition: opacity var(--transition-normal);
}

.modal-enter-active .modal,
.modal-leave-active .modal {
  transition: transform var(--transition-normal), opacity var(--transition-normal);
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-from .modal,
.modal-leave-to .modal {
  transform: scale(0.95);
  opacity: 0;
}
</style>
