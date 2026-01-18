<template>
  <div :class="inputWrapperClasses">
    <label v-if="label" :for="inputId" class="input-label">
      {{ label }}
      <span v-if="required" class="input-required">*</span>
    </label>
    
    <div class="input-container">
      <span v-if="$slots.prefix" class="input-prefix">
        <slot name="prefix"></slot>
      </span>
      
      <input
        v-if="type !== 'textarea'"
        :id="inputId"
        :type="type"
        :value="modelValue"
        :placeholder="placeholder"
        :disabled="disabled"
        :readonly="readonly"
        :required="required"
        :min="min"
        :max="max"
        :step="step"
        :class="inputClasses"
        @input="$emit('update:modelValue', $event.target.value)"
        @blur="$emit('blur', $event)"
        @focus="$emit('focus', $event)"
      />
      
      <textarea
        v-else
        :id="inputId"
        :value="modelValue"
        :placeholder="placeholder"
        :disabled="disabled"
        :readonly="readonly"
        :required="required"
        :rows="rows"
        :class="inputClasses"
        @input="$emit('update:modelValue', $event.target.value)"
        @blur="$emit('blur', $event)"
        @focus="$emit('focus', $event)"
      ></textarea>
      
      <span v-if="$slots.suffix" class="input-suffix">
        <slot name="suffix"></slot>
      </span>
    </div>
    
    <p v-if="error" class="input-error">{{ error }}</p>
    <p v-else-if="hint" class="input-hint">{{ hint }}</p>
  </div>
</template>

<script>
let inputCounter = 0

export default {
  name: 'BaseInput',
  props: {
    modelValue: {
      type: [String, Number],
      default: ''
    },
    type: {
      type: String,
      default: 'text'
    },
    label: {
      type: String,
      default: ''
    },
    placeholder: {
      type: String,
      default: ''
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
    readonly: {
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
    },
    rows: {
      type: Number,
      default: 4
    },
    min: {
      type: [Number, String],
      default: undefined
    },
    max: {
      type: [Number, String],
      default: undefined
    },
    step: {
      type: [Number, String],
      default: undefined
    }
  },
  emits: ['update:modelValue', 'blur', 'focus'],
  data() {
    return {
      inputId: `input-${++inputCounter}`
    }
  },
  computed: {
    inputWrapperClasses() {
      return [
        'input-wrapper',
        {
          'input-wrapper-full-width': this.fullWidth,
          'input-wrapper-error': this.error,
          'input-wrapper-disabled': this.disabled
        }
      ]
    },
    inputClasses() {
      return [
        'input-field',
        `input-${this.size}`,
        {
          'input-error-state': this.error,
          'input-with-prefix': this.$slots.prefix,
          'input-with-suffix': this.$slots.suffix
        }
      ]
    }
  }
}
</script>

<style scoped>
.input-wrapper {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-1);
}

.input-wrapper-full-width {
  width: 100%;
}

.input-label {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--color-text-primary);
}

.input-required {
  color: var(--color-danger);
  margin-left: var(--spacing-1);
}

.input-container {
  position: relative;
  display: flex;
  align-items: center;
}

/* ===== LIQUID GLASS INPUT ===== */
.input-field {
  width: 100%;
  border: 1px solid rgba(0, 0, 0, 0.08);
  border-radius: var(--radius-xl);
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  color: var(--color-text-primary);
  transition: 
    border-color var(--transition-fast),
    background var(--transition-fast),
    box-shadow var(--transition-fast),
    transform var(--transition-fast);
  box-shadow: 
    0 2px 8px rgba(0, 0, 0, 0.04),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);
}

.input-field:hover:not(:disabled):not(:focus) {
  border-color: rgba(0, 0, 0, 0.12);
  background: rgba(255, 255, 255, 0.8);
}

.input-field:focus {
  border-color: rgba(56, 189, 248, 0.5);
  background: rgba(255, 255, 255, 0.9);
  box-shadow: 
    0 0 0 4px rgba(56, 189, 248, 0.15),
    0 4px 16px rgba(0, 0, 0, 0.08),
    inset 0 1px 0 rgba(255, 255, 255, 0.9);
  outline: none;
}

.input-field::placeholder {
  color: var(--color-text-muted);
}

/* Sizes */
.input-sm {
  padding: var(--spacing-2) var(--spacing-4);
  font-size: var(--font-size-sm);
  border-radius: var(--radius-lg);
}

.input-md {
  padding: var(--spacing-3) var(--spacing-5);
  font-size: var(--font-size-base);
}

.input-lg {
  padding: var(--spacing-4) var(--spacing-6);
  font-size: var(--font-size-lg);
  border-radius: var(--radius-2xl);
}

/* Error state */
.input-error-state {
  border-color: rgba(239, 68, 68, 0.6);
  background: linear-gradient(
    135deg,
    rgba(239, 68, 68, 0.1) 0%,
    rgba(255, 255, 255, 0.08) 100%
  );
}

.input-error-state:focus {
  border-color: rgba(239, 68, 68, 0.8);
  box-shadow: 
    0 0 0 4px rgba(239, 68, 68, 0.15),
    0 8px 24px rgba(0, 0, 0, 0.12);
}

.input-error {
  font-size: var(--font-size-sm);
  color: var(--color-danger-light);
}

.input-hint {
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
}

/* Disabled state */
.input-wrapper-disabled .input-field {
  background: rgba(255, 255, 255, 0.05);
  cursor: not-allowed;
  opacity: 0.5;
}

/* Prefix and suffix */
.input-prefix,
.input-suffix {
  position: absolute;
  display: flex;
  align-items: center;
  color: var(--color-text-secondary);
}

.input-prefix {
  left: var(--spacing-4);
}

.input-suffix {
  right: var(--spacing-4);
}

.input-with-prefix {
  padding-left: var(--spacing-12);
}

.input-with-suffix {
  padding-right: var(--spacing-12);
}

/* Textarea */
textarea.input-field {
  resize: vertical;
  min-height: 120px;
  border-radius: var(--radius-xl);
}
</style>
