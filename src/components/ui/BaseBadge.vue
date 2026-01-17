<template>
  <span :class="badgeClasses">
    <slot></slot>
  </span>
</template>

<script>
export default {
  name: 'BaseBadge',
  props: {
    variant: {
      type: String,
      default: 'default',
      validator: (value) => ['default', 'primary', 'secondary', 'success', 'warning', 'danger', 'info'].includes(value)
    },
    size: {
      type: String,
      default: 'md',
      validator: (value) => ['sm', 'md', 'lg'].includes(value)
    },
    rounded: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    badgeClasses() {
      return [
        'badge',
        `badge-${this.variant}`,
        `badge-${this.size}`,
        {
          'badge-rounded': this.rounded
        }
      ]
    }
  }
}
</script>

<style scoped>
.badge {
  display: inline-flex;
  align-items: center;
  font-weight: var(--font-weight-medium);
  border-radius: var(--border-radius-md);
}

/* Sizes */
.badge-sm {
  padding: var(--spacing-1) var(--spacing-2);
  font-size: var(--font-size-xs);
}

.badge-md {
  padding: var(--spacing-1) var(--spacing-3);
  font-size: var(--font-size-sm);
}

.badge-lg {
  padding: var(--spacing-2) var(--spacing-4);
  font-size: var(--font-size-base);
}

/* Variants */
.badge-default {
  background-color: var(--color-gray-100);
  color: var(--color-text-secondary);
}

.badge-primary {
  background-color: var(--color-primary-bg);
  color: var(--color-primary-dark);
}

.badge-secondary {
  background-color: var(--color-secondary-bg);
  color: var(--color-secondary-dark);
}

.badge-success {
  background-color: var(--color-success-bg);
  color: var(--color-success-dark);
}

.badge-warning {
  background-color: var(--color-warning-bg);
  color: var(--color-warning-dark);
}

.badge-danger {
  background-color: var(--color-danger-bg);
  color: var(--color-danger-dark);
}

.badge-info {
  background-color: var(--color-info-bg);
  color: var(--color-info-dark);
}

/* Rounded */
.badge-rounded {
  border-radius: var(--border-radius-full);
}
</style>
