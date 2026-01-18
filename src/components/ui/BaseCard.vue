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
/* ===== LIQUID GLASS CARD ===== */
.card {
  position: relative;
  background: rgba(255, 255, 255, 0.65);
  backdrop-filter: blur(20px) saturate(120%);
  -webkit-backdrop-filter: blur(20px) saturate(120%);
  border-radius: var(--radius-2xl);
  overflow: hidden;
  transition: 
    transform var(--transition-bounce),
    box-shadow var(--transition-normal),
    background var(--transition-normal);
  border: 1px solid rgba(0, 0, 0, 0.06);
  box-shadow: var(--shadow-glass);
}

/* Reflet supérieur */
.card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 50%;
  background: linear-gradient(
    180deg,
    rgba(255, 255, 255, 0.6) 0%,
    transparent 100%
  );
  pointer-events: none;
  border-radius: var(--radius-2xl) var(--radius-2xl) 0 0;
}

/* Variants */
.card-default {
  box-shadow: var(--shadow-glass);
}

.card-outlined {
  border: 1.5px solid rgba(0, 0, 0, 0.08);
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06);
}

.card-elevated {
  background: rgba(255, 255, 255, 0.75);
  box-shadow: var(--shadow-glass-float);
}

/* Padding */
.card-padding-none .card-content {
  padding: 0;
}

.card-padding-sm .card-content {
  padding: var(--spacing-4);
}

.card-padding-md .card-content {
  padding: var(--spacing-5);
}

.card-padding-lg .card-content {
  padding: var(--spacing-6);
}

/* Hoverable - effet liquide */
.card-hoverable {
  cursor: pointer;
}

.card-hoverable:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: var(--shadow-glass-hover);
  background: rgba(255, 255, 255, 0.85);
  border-color: rgba(56, 189, 248, 0.3);
}

/* Clickable */
.card-clickable {
  cursor: pointer;
}

.card-clickable:active {
  transform: scale(0.98);
  transition: transform 0.1s ease;
}

/* Image */
.card-image {
  width: 100%;
  aspect-ratio: 16 / 10;
  overflow: hidden;
  position: relative;
}

.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform var(--transition-slow);
}

.card-hoverable:hover .card-image img {
  transform: scale(1.08);
}

/* Content */
.card-content {
  position: relative;
  display: flex;
  flex-direction: column;
  gap: var(--spacing-3);
  z-index: 1;
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
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.card-subtitle {
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
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
  padding-top: var(--spacing-4);
  border-top: 1px solid rgba(255, 255, 255, 0.15);
  margin-top: auto;
}

/* Mobile responsive */
@media (max-width: 768px) {
  .card {
    border-radius: var(--radius-xl);
  }
  
  .card::before {
    border-radius: var(--radius-xl) var(--radius-xl) 0 0;
  }
  
  /* Touch interactions */
  .card-hoverable:hover {
    transform: none;
    box-shadow: var(--shadow-glass);
    background: linear-gradient(
      135deg,
      rgba(255, 255, 255, 0.15) 0%,
      rgba(255, 255, 255, 0.08) 50%,
      rgba(147, 197, 253, 0.1) 100%
    );
  }
  
  .card-hoverable:hover .card-image img {
    transform: none;
  }
  
  .card-clickable:active {
    transform: scale(0.97);
    background: linear-gradient(
      135deg,
      rgba(255, 255, 255, 0.2) 0%,
      rgba(255, 255, 255, 0.12) 100%
    );
  }
  
  .card-title {
    font-size: var(--font-size-base);
  }
}

/* Animation d'entrée fluide */
@keyframes cardSlideIn {
  from {
    opacity: 0;
    transform: translateY(30px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.card {
  animation: cardSlideIn 0.5s var(--transition-bounce) forwards;
}

/* Préférence mouvement réduit */
@media (prefers-reduced-motion: reduce) {
  .card {
    animation: none;
    transition: opacity 0.2s ease;
  }
  
  .card-image img {
    transition: none;
  }
  
  .card-hoverable:hover {
    transform: none;
  }
}
</style>
