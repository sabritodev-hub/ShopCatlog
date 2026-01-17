<template>
  <div :class="selectWrapperClasses">
    <label v-if="label" :for="selectId" class="select-label">
      {{ label }}
      <span v-if="required" class="select-required">*</span>
    </label>
    
    <div class="select-container">
      <select
        :id="selectId"
        :value="modelValue"
        :disabled="disabled"
        :required="required"
        :class="selectClasses"
        @change="$emit('update:modelValue', $event.target.value)"
      >
        <option v-if="placeholder" value="" disabled>{{ placeholder }}</option>
        <option
          v-for="option in normalizedOptions"
          :key="option.value"
          :value="option.value"
        >
          {{ option.label }}
        </option>
      </select>
      
      <span class="select-arrow">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <polyline points="6 9 12 15 18 9"></polyline>
        </svg>
      </span>
    </div>
    
    <p v-if="error" class="select-error">{{ error }}</p>
    <p v-else-if="hint" class="select-hint">{{ hint }}</p>
  </div>
</template>

<script>
let selectCounter = 0

export default {
  name: 'BaseSelect',
  props: {
    modelValue: {
      type: [String, Number],
      default: ''
    },
    options: {
      type: Array,
      required: true
    },
    label: {
      type: String,
      default: ''
    },
    placeholder: {
      type: String,
      default: 'Sélectionner...'
    },
    hint: {
      type: String,
      default: ''
    },
    error: {
      type: String,
      default: ''
    },
    disabled: {
      type: Boolean,
      default: false
    },
    required: {
      type: Boolean,
      default: false
    },
    size: {
      type: String,
      default: 'md',
      validator: (value) => ['sm', 'md', 'lg'].includes(value)
    },
    fullWidth: {
      type: Boolean,
      default: true
    }
  },
  emits: ['update:modelValue'],
  data() {
    return {
      selectId: `select-${++selectCounter}`
    }
  },
  computed: {
    selectWrapperClasses() {
      return [
        'select-wrapper',
        {
          'select-wrapper-full-width': this.fullWidth,
          'select-wrapper-error': this.error,
          'select-wrapper-disabled': this.disabled
        }
      ]
    },
    selectClasses() {
      return [
        'select-field',
        `select-${this.size}`,
        {
          'select-error-state': this.error
        }
      ]
    },
    normalizedOptions() {
      return this.options.map(option => {
        if (typeof option === 'object') {
          return option
        }
        return { value: option, label: option }
      })
    }
  }
}
</script>

<style scoped>
.select-wrapper {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-1);
}

.select-wrapper-full-width {
  width: 100%;
}

.select-label {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--color-text-primary);
}

.select-required {
  color: var(--color-danger);
  margin-left: var(--spacing-1);
}

.select-container {
  position: relative;
}

.select-field {
  width: 100%;
  border: var(--border-width-thin) solid var(--color-border-default);
  border-radius: var(--border-radius-lg);
  background-color: var(--color-white);
  color: var(--color-text-primary);
  cursor: pointer;
  appearance: none;
  padding-right: var(--spacing-10);
  transition: all var(--transition-fast);
}

.select-field:focus {
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px var(--color-primary-bg);
}

/* Sizes */
.select-sm {
  padding: var(--spacing-2) var(--spacing-3);
  font-size: var(--font-size-sm);
}

.select-md {
  padding: var(--spacing-2) var(--spacing-4);
  font-size: var(--font-size-base);
}

.select-lg {
  padding: var(--spacing-3) var(--spacing-4);
  font-size: var(--font-size-lg);
}

/* Arrow */
.select-arrow {
  position: absolute;
  right: var(--spacing-3);
  top: 50%;
  transform: translateY(-50%);
  color: var(--color-text-muted);
  pointer-events: none;
}

/* Error state */
.select-error-state {
  border-color: var(--color-danger);
}

.select-error-state:focus {
  border-color: var(--color-danger);
  box-shadow: 0 0 0 3px var(--color-danger-bg);
}

.select-error {
  font-size: var(--font-size-sm);
  color: var(--color-danger);
}

.select-hint {
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
}

/* Disabled state */
.select-wrapper-disabled .select-field {
  background-color: var(--color-gray-100);
  cursor: not-allowed;
  opacity: 0.7;
}
</style>
