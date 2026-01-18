<template>
  <button
    :class="buttonClasses"
    :type="type"
    :disabled="disabled || loading"
    @click="$emit('click', $event)"
  >
    <span v-if="loading" class="btn-spinner"></span>
    <span v-if="icon && !loading" class="btn-icon">
      <slot name="icon"></slot>
    </span>
    <span class="btn-text">
      <slot></slot>
    </span>
  </button>
</template>

<script>
export default {
  name: 'BaseButton',
  props: {
    variant: {
      type: String,
      default: 'primary',
      validator: (value) => ['primary', 'secondary', 'success', 'danger', 'warning', 'outline', 'ghost'].includes(value)
    },
    size: {
      type: String,
      default: 'md',
      validator: (value) => ['sm', 'md', 'lg'].includes(value)
    },
    type: {
      type: String,
      default: 'button'
    },
    disabled: {
      type: Boolean,
      default: false
    },
    loading: {
      type: Boolean,
      default: false
    },
    fullWidth: {
      type: Boolean,
      default: false
    },
    icon: {
      type: Boolean,
      default: false
    }
  },
  emits: ['click'],
  computed: {
    buttonClasses() {
      return [
        'btn',
        `btn-${this.variant}`,
        `btn-${this.size}`,
        {
          'btn-full-width': this.fullWidth,
          'btn-disabled': this.disabled,
          'btn-loading': this.loading,
          'btn-icon-only': this.icon && !this.$slots.default
        }
      ]
    }
  }
}
</script>

<style scoped>
/* ===== LIQUID GLASS BUTTONS ===== */
.btn {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--spacing-2);
  font-family: var(--font-family-base);
  font-weight: var(--font-weight-semibold);
  border-radius: var(--radius-full);
  transition: 
    transform var(--transition-bounce),
    box-shadow var(--transition-normal),
    background var(--transition-normal);
  cursor: pointer;
  border: none;
  text-decoration: none;
  white-space: nowrap;
  overflow: hidden;
}

/* Reflet liquid */
.btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 50%;
  background: linear-gradient(
    180deg,
    rgba(255, 255, 255, 0.3) 0%,
    rgba(255, 255, 255, 0.05) 100%
  );
  pointer-events: none;
  border-radius: var(--radius-full) var(--radius-full) 40% 40%;
}

/* Sizes */
.btn-sm {
  padding: var(--spacing-2) var(--spacing-5);
  font-size: var(--font-size-sm);
  min-height: 38px;
}

.btn-md {
  padding: var(--spacing-3) var(--spacing-6);
  font-size: var(--font-size-base);
  min-height: 48px;
}

.btn-lg {
  padding: var(--spacing-4) var(--spacing-10);
  font-size: var(--font-size-lg);
  min-height: 56px;
}

/* === PRIMARY - Bleu vibrant === */
.btn-primary {
  background: linear-gradient(135deg, #38bdf8 0%, #0ea5e9 50%, #0284c7 100%);
  color: var(--color-white);
  box-shadow: 
    0 4px 20px rgba(14, 165, 233, 0.4),
    inset 0 1px 1px rgba(255, 255, 255, 0.3);
}

.btn-primary:hover:not(:disabled) {
  background: linear-gradient(135deg, #7dd3fc 0%, #38bdf8 50%, #0ea5e9 100%);
  box-shadow: 
    0 8px 32px rgba(14, 165, 233, 0.5),
    inset 0 1px 1px rgba(255, 255, 255, 0.4);
  transform: translateY(-3px) scale(1.02);
}

.btn-primary:active:not(:disabled) {
  transform: translateY(0) scale(0.98);
  box-shadow: 0 2px 12px rgba(14, 165, 233, 0.4);
}

/* === SECONDARY === */
.btn-secondary {
  background: linear-gradient(135deg, #818cf8 0%, #6366f1 50%, #4f46e5 100%);
  color: var(--color-white);
  box-shadow: 
    0 4px 20px rgba(99, 102, 241, 0.4),
    inset 0 1px 1px rgba(255, 255, 255, 0.3);
}

.btn-secondary:hover:not(:disabled) {
  background: linear-gradient(135deg, #a5b4fc 0%, #818cf8 50%, #6366f1 100%);
  box-shadow: 0 8px 32px rgba(99, 102, 241, 0.5);
  transform: translateY(-3px) scale(1.02);
}

/* === SUCCESS === */
.btn-success {
  background: linear-gradient(135deg, #4ade80 0%, #22c55e 50%, #16a34a 100%);
  color: var(--color-white);
  box-shadow: 
    0 4px 20px rgba(34, 197, 94, 0.4),
    inset 0 1px 1px rgba(255, 255, 255, 0.3);
}

.btn-success:hover:not(:disabled) {
  box-shadow: 0 8px 32px rgba(34, 197, 94, 0.5);
  transform: translateY(-3px) scale(1.02);
}

/* === DANGER === */
.btn-danger {
  background: linear-gradient(135deg, #f87171 0%, #ef4444 50%, #dc2626 100%);
  color: var(--color-white);
  box-shadow: 
    0 4px 20px rgba(239, 68, 68, 0.4),
    inset 0 1px 1px rgba(255, 255, 255, 0.3);
}

.btn-danger:hover:not(:disabled) {
  box-shadow: 0 8px 32px rgba(239, 68, 68, 0.5);
  transform: translateY(-3px) scale(1.02);
}

/* === WARNING === */
.btn-warning {
  background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 50%, #d97706 100%);
  color: var(--color-white);
  box-shadow: 
    0 4px 20px rgba(245, 158, 11, 0.4),
    inset 0 1px 1px rgba(255, 255, 255, 0.3);
}

.btn-warning:hover:not(:disabled) {
  box-shadow: 0 8px 32px rgba(245, 158, 11, 0.5);
  transform: translateY(-3px) scale(1.02);
}

/* === OUTLINE - Glass transparent pour fond clair === */
.btn-outline {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  color: var(--color-text-primary);
  border: 1px solid rgba(0, 0, 0, 0.1);
  box-shadow: var(--shadow-glass);
}

.btn-outline:hover:not(:disabled) {
  background: rgba(255, 255, 255, 0.8);
  border-color: rgba(56, 189, 248, 0.4);
  transform: translateY(-3px) scale(1.02);
}

/* === GHOST - Très transparent === */
.btn-ghost {
  background: rgba(0, 0, 0, 0.03);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  color: var(--color-text-primary);
  border: 1px solid rgba(0, 0, 0, 0.06);
}

.btn-ghost:hover:not(:disabled) {
  background: rgba(0, 0, 0, 0.06);
  border-color: rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

/* States */
.btn-disabled,
.btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
  transform: none !important;
}

.btn-full-width {
  width: 100%;
}

.btn-loading {
  position: relative;
  color: transparent;
}

/* Spinner animé */
.btn-spinner {
  position: absolute;
  width: 20px;
  height: 20px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spinPulse 0.8s cubic-bezier(0.5, 0, 0.5, 1) infinite;
}

@keyframes spinPulse {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Icon */
.btn-icon {
  display: flex;
  align-items: center;
}

.btn-icon-only {
  padding: var(--spacing-3);
}

.btn-icon-only.btn-sm {
  width: 38px;
  height: 38px;
  padding: 0;
}

.btn-icon-only.btn-md {
  width: 48px;
  height: 48px;
  padding: 0;
}

.btn-icon-only.btn-lg {
  width: 56px;
  height: 56px;
  padding: 0;
}

/* Mobile */
@media (max-width: 768px) {
  .btn:hover:not(:disabled) {
    transform: none;
  }
  
  .btn:active:not(:disabled) {
    transform: scale(0.96);
  }
}

/* Préférence mouvement réduit */
@media (prefers-reduced-motion: reduce) {
  .btn {
    transition: opacity 0.2s ease;
  }
  
  .btn:hover:not(:disabled) {
    transform: none;
  }
  
  .btn-spinner {
    animation-duration: 1.2s;
  }
}
</style>
