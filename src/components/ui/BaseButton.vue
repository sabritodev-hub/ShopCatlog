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
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--spacing-2);
  font-family: var(--font-family-base);
  font-weight: var(--font-weight-medium);
  border-radius: var(--border-radius-lg);
  transition: all var(--transition-fast);
  cursor: pointer;
  border: none;
  text-decoration: none;
  white-space: nowrap;
}

/* Sizes */
.btn-sm {
  padding: var(--spacing-2) var(--spacing-3);
  font-size: var(--font-size-sm);
  min-height: 32px;
}

.btn-md {
  padding: var(--spacing-2) var(--spacing-4);
  font-size: var(--font-size-base);
  min-height: 40px;
}

.btn-lg {
  padding: var(--spacing-3) var(--spacing-6);
  font-size: var(--font-size-lg);
  min-height: 48px;
}

/* Variants */
.btn-primary {
  background-color: var(--color-primary);
  color: var(--color-white);
}

.btn-primary:hover:not(:disabled) {
  background-color: var(--color-primary-dark);
}

.btn-secondary {
  background-color: var(--color-secondary);
  color: var(--color-white);
}

.btn-secondary:hover:not(:disabled) {
  background-color: var(--color-secondary-dark);
}

.btn-success {
  background-color: var(--color-success);
  color: var(--color-white);
}

.btn-success:hover:not(:disabled) {
  background-color: var(--color-success-dark);
}

.btn-danger {
  background-color: var(--color-danger);
  color: var(--color-white);
}

.btn-danger:hover:not(:disabled) {
  background-color: var(--color-danger-dark);
}

.btn-warning {
  background-color: var(--color-warning);
  color: var(--color-white);
}

.btn-warning:hover:not(:disabled) {
  background-color: var(--color-warning-dark);
}

.btn-outline {
  background-color: transparent;
  color: var(--color-primary);
  border: var(--border-width-thin) solid var(--color-primary);
}

.btn-outline:hover:not(:disabled) {
  background-color: var(--color-primary-bg);
}

.btn-ghost {
  background-color: transparent;
  color: var(--color-text-secondary);
}

.btn-ghost:hover:not(:disabled) {
  background-color: var(--color-gray-100);
  color: var(--color-text-primary);
}

/* States */
.btn-disabled,
.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-full-width {
  width: 100%;
}

.btn-loading {
  position: relative;
  color: transparent;
}

/* Spinner */
.btn-spinner {
  position: absolute;
  width: 16px;
  height: 16px;
  border: 2px solid transparent;
  border-top-color: currentColor;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

.btn-loading .btn-spinner {
  color: var(--color-white);
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* Icon */
.btn-icon {
  display: flex;
  align-items: center;
}

.btn-icon-only {
  padding: var(--spacing-2);
}

.btn-icon-only.btn-sm {
  width: 32px;
  height: 32px;
}

.btn-icon-only.btn-md {
  width: 40px;
  height: 40px;
}

.btn-icon-only.btn-lg {
  width: 48px;
  height: 48px;
}
</style>
