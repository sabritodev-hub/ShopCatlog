<template>
  <div :class="cardClasses">
    <div v-if="$slots.image || image" class="card-image">
      <slot name="image">
        <img :src="image" :alt="imageAlt" />
      </slot>
    </div>
    
    <div class="card-content">
      <div v-if="$slots.header || title" class="card-header">
        <slot name="header">
          <h3 class="card-title">{{ title }}</h3>
          <p v-if="subtitle" class="card-subtitle">{{ subtitle }}</p>
        </slot>
      </div>
      
      <div v-if="$slots.default" class="card-body">
        <slot></slot>
      </div>
      
      <div v-if="$slots.footer" class="card-footer">
        <slot name="footer"></slot>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BaseCard',
  props: {
    title: {
      type: String,
      default: ''
    },
    subtitle: {
      type: String,
      default: ''
    },
    image: {
      type: String,
      default: ''
    },
    imageAlt: {
      type: String,
      default: ''
    },
    variant: {
      type: String,
      default: 'default',
      validator: (value) => ['default', 'outlined', 'elevated'].includes(value)
    },
    padding: {
      type: String,
      default: 'md',
      validator: (value) => ['none', 'sm', 'md', 'lg'].includes(value)
    },
    hoverable: {
      type: Boolean,
      default: false
    },
    clickable: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    cardClasses() {
      return [
        'card',
        `card-${this.variant}`,
        `card-padding-${this.padding}`,
        {
          'card-hoverable': this.hoverable,
          'card-clickable': this.clickable
        }
      ]
    }
  }
}
</script>

<style scoped>
.card {
  background-color: var(--color-white);
  border-radius: var(--border-radius-xl);
  overflow: hidden;
  transition: all var(--transition-normal);
}

/* Variants */
.card-default {
  border: var(--border-width-thin) solid var(--color-border-light);
}

.card-outlined {
  border: var(--border-width-default) solid var(--color-border-default);
}

.card-elevated {
  border: none;
  box-shadow: var(--shadow-md);
}

/* Padding */
.card-padding-none .card-content {
  padding: 0;
}

.card-padding-sm .card-content {
  padding: var(--spacing-3);
}

.card-padding-md .card-content {
  padding: var(--spacing-4);
}

.card-padding-lg .card-content {
  padding: var(--spacing-6);
}

/* Hoverable */
.card-hoverable:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-2px);
}

/* Clickable */
.card-clickable {
  cursor: pointer;
}

/* Image */
.card-image {
  width: 100%;
  aspect-ratio: 16 / 10;
  overflow: hidden;
}

.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform var(--transition-normal);
}

.card-hoverable:hover .card-image img {
  transform: scale(1.05);
}

/* Content */
.card-content {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-3);
}

/* Header */
.card-header {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-1);
}

.card-title {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin: 0;
}

.card-subtitle {
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
  margin: 0;
}

/* Body */
.card-body {
  color: var(--color-text-secondary);
}

/* Footer */
.card-footer {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
  padding-top: var(--spacing-3);
  border-top: var(--border-width-thin) solid var(--color-border-light);
}
</style>
