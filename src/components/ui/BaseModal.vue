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
/* ===== LIQUID GLASS MODAL ===== */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: radial-gradient(
    ellipse at center,
    rgba(0, 0, 0, 0.2) 0%,
    rgba(0, 0, 0, 0.4) 100%
  );
  display: flex;
  align-items: center;
  justify-content: center;
  padding: var(--spacing-4);
  z-index: var(--z-index-modal);
  backdrop-filter: blur(8px) saturate(120%);
  -webkit-backdrop-filter: blur(8px) saturate(120%);
}

.modal {
  position: relative;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(20px) saturate(120%);
  -webkit-backdrop-filter: blur(20px) saturate(120%);
  border-radius: var(--radius-2xl);
  border: 1px solid rgba(0, 0, 0, 0.08);
  box-shadow: 
    0 32px 80px rgba(0, 0, 0, 0.18),
    0 0 0 1px rgba(255, 255, 255, 0.5),
    inset 0 1px 0 rgba(255, 255, 255, 0.9);
  display: flex;
  flex-direction: column;
  max-height: 90vh;
  overflow: hidden;
}

/* Reflet supérieur */
.modal::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 40%;
  background: linear-gradient(
    180deg,
    rgba(255, 255, 255, 0.6) 0%,
    transparent 100%
  );
  pointer-events: none;
  border-radius: var(--radius-2xl) var(--radius-2xl) 0 0;
}

/* Sizes */
.modal-sm {
  width: 100%;
  max-width: 420px;
}

.modal-md {
  width: 100%;
  max-width: 580px;
}

.modal-lg {
  width: 100%;
  max-width: 760px;
}

.modal-xl {
  width: 100%;
  max-width: 1000px;
}

.modal-full {
  width: calc(100% - var(--spacing-8));
  height: calc(100% - var(--spacing-8));
  max-width: none;
  max-height: none;
}

/* Header */
.modal-header {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--spacing-5) var(--spacing-6);
  border-bottom: 1px solid rgba(255, 255, 255, 0.15);
  z-index: 1;
}

.modal-title {
  font-size: var(--font-size-xl);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin: 0;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.modal-close {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border-radius: var(--radius-full);
  color: var(--color-text-secondary);
  transition: all var(--transition-fast);
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.15);
}

.modal-close:hover {
  background: rgba(255, 255, 255, 0.2);
  color: var(--color-text-primary);
  transform: scale(1.05);
}

.modal-close:active {
  transform: scale(0.95);
}

/* Body */
.modal-body {
  position: relative;
  padding: var(--spacing-6);
  overflow-y: auto;
  flex: 1;
  z-index: 1;
  color: var(--color-text-primary);
}

/* Footer */
.modal-footer {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: var(--spacing-3);
  padding: var(--spacing-5) var(--spacing-6);
  border-top: 1px solid rgba(255, 255, 255, 0.15);
  z-index: 1;
}

/* Transition fluide */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.modal-enter-active .modal,
.modal-leave-active .modal {
  transition: 
    transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1),
    opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-from .modal {
  transform: scale(0.9) translateY(20px);
  opacity: 0;
}

.modal-leave-to .modal {
  transform: scale(0.95) translateY(10px);
  opacity: 0;
}

/* Mobile */
@media (max-width: 640px) {
  .modal {
    border-radius: var(--radius-xl);
    max-height: 85vh;
  }
  
  .modal::before {
    border-radius: var(--radius-xl) var(--radius-xl) 0 0;
  }
  
  .modal-header,
  .modal-body,
  .modal-footer {
    padding-left: var(--spacing-4);
    padding-right: var(--spacing-4);
  }
}

/* Préférence mouvement réduit */
@media (prefers-reduced-motion: reduce) {
  .modal-enter-active .modal,
  .modal-leave-active .modal {
    transition: opacity 0.2s ease;
  }
  
  .modal-enter-from .modal,
  .modal-leave-to .modal {
    transform: none;
  }
}
</style>
