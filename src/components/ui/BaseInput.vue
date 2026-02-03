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
let inputCounter = 0;

export default {
    name: "BaseInput",
    props: {
        modelValue: {
            type: [String, Number],
            default: "",
        },
        type: {
            type: String,
            default: "text",
        },
        label: {
            type: String,
            default: "",
        },
        placeholder: {
            type: String,
            default: "",
        },
        hint: {
            type: String,
            default: "",
        },
        error: {
            type: String,
            default: "",
        },
        disabled: {
            type: Boolean,
            default: false,
        },
        readonly: {
            type: Boolean,
            default: false,
        },
        required: {
            type: Boolean,
            default: false,
        },
        size: {
            type: String,
            default: "md",
            validator: (value) => ["sm", "md", "lg"].includes(value),
        },
        fullWidth: {
            type: Boolean,
            default: true,
        },
        rows: {
            type: Number,
            default: 4,
        },
        min: {
            type: [Number, String],
            default: undefined,
        },
        max: {
            type: [Number, String],
            default: undefined,
        },
        step: {
            type: [Number, String],
            default: undefined,
        },
    },
    emits: ["update:modelValue", "blur", "focus"],
    data() {
        return {
            inputId: `input-${++inputCounter}`,
        };
    },
    computed: {
        inputWrapperClasses() {
            return [
                "input-wrapper",
                {
                    "input-wrapper-full-width": this.fullWidth,
                    "input-wrapper-error": this.error,
                    "input-wrapper-disabled": this.disabled,
                },
            ];
        },
        inputClasses() {
            return [
                "input-field",
                `input-${this.size}`,
                {
                    "input-error-state": this.error,
                    "input-with-prefix": this.$slots.prefix,
                    "input-with-suffix": this.$slots.suffix,
                },
            ];
        },
    },
};
</script>

<style scoped>
.input-wrapper {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-2);
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

/* ===== MODERN INPUT 2026 ===== */
.input-field {
    width: 100%;
    border: 1px solid #d1d5db;
    border-radius: var(--radius-md);
    background: #ffffff;
    color: var(--color-text-primary);
    transition:
        border-color var(--transition-fast),
        background var(--transition-fast),
        box-shadow var(--transition-fast);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
}

.input-field:hover:not(:disabled):not(:focus) {
    border-color: #9ca3af;
}

.input-field:focus {
    border-color: var(--color-primary);
    box-shadow:
        0 0 0 3px var(--color-primary-bg),
        0 2px 8px rgba(99, 102, 241, 0.2);
    outline: none;
}

.input-field::placeholder {
    color: var(--color-text-muted);
}

/* Sizes */
.input-sm {
    padding: var(--spacing-2) var(--spacing-3);
    font-size: var(--font-size-sm);
}

.input-md {
    padding: var(--spacing-2) var(--spacing-4);
    font-size: var(--font-size-base);
}

.input-lg {
    padding: var(--spacing-3) var(--spacing-5);
    font-size: var(--font-size-lg);
}

/* Error state */
.input-error-state {
    border-color: #fca5a5;
    background: #fef2f2;
}

.input-error-state:focus {
    border-color: var(--color-danger);
    box-shadow:
        0 0 0 3px rgba(239, 68, 68, 0.1),
        0 2px 8px rgba(239, 68, 68, 0.2);
}

.input-error {
    font-size: var(--font-size-sm);
    color: var(--color-danger);
}

.input-hint {
    font-size: var(--font-size-sm);
    color: var(--color-text-tertiary);
}

/* Disabled state */
.input-wrapper-disabled .input-field {
    background: #f9fafb;
    cursor: not-allowed;
    opacity: 0.6;
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
}
</style>
