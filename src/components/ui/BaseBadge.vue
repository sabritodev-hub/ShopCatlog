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
/* ===== BASE BADGE - LIQUID GLASS ===== */
.badge {
  display: inline-flex;
  align-items: center;
  font-weight: var(--font-weight-medium);
  border-radius: var(--radius-full);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  transition: all var(--transition-bounce);
}

/* Sizes */
.badge-sm {
  padding: var(--spacing-1) var(--spacing-3);
  font-size: var(--font-size-xs);
}

.badge-md {
  padding: var(--spacing-2) var(--spacing-4);
  font-size: var(--font-size-sm);
}

.badge-lg {
  padding: var(--spacing-3) var(--spacing-5);
  font-size: var(--font-size-base);
}

/* Variants - Light glass style */
.badge-default {
  background: rgba(255, 255, 255, 0.7);
  color: var(--color-text-primary);
  border: 1px solid rgba(0, 0, 0, 0.08);
}

.badge-primary {
  background: rgba(56, 189, 248, 0.15);
  color: #0284c7;
  border: 1px solid rgba(56, 189, 248, 0.25);
}

.badge-secondary {
  background: rgba(139, 92, 246, 0.15);
  color: #7c3aed;
  border: 1px solid rgba(139, 92, 246, 0.25);
}

.badge-success {
  background: rgba(34, 197, 94, 0.15);
  color: #16a34a;
  border: 1px solid rgba(34, 197, 94, 0.25);
}

.badge-warning {
  background: rgba(245, 158, 11, 0.15);
  color: #d97706;
  border: 1px solid rgba(245, 158, 11, 0.25);
}

.badge-danger {
  background: rgba(239, 68, 68, 0.15);
  color: #dc2626;
  border: 1px solid rgba(239, 68, 68, 0.25);
}

.badge-info {
  background: rgba(6, 182, 212, 0.15);
  color: #0891b2;
  border: 1px solid rgba(6, 182, 212, 0.25);
}

/* Rounded - déjà pill par défaut, donc max rounded */
.badge-rounded {
  border-radius: var(--radius-full);
}
</style>
