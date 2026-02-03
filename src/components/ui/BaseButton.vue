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
    name: "BaseButton",
    props: {
        variant: {
            type: String,
            default: "primary",
            validator: (value) =>
                [
                    "primary",
                    "secondary",
                    "success",
                    "danger",
                    "warning",
                    "outline",
                    "ghost",
                ].includes(value),
        },
        size: {
            type: String,
            default: "md",
            validator: (value) => ["sm", "md", "lg"].includes(value),
        },
        type: {
            type: String,
            default: "button",
        },
        disabled: {
            type: Boolean,
            default: false,
        },
        loading: {
            type: Boolean,
            default: false,
        },
        fullWidth: {
            type: Boolean,
            default: false,
        },
        icon: {
            type: Boolean,
            default: false,
        },
    },
    emits: ["click"],
    computed: {
        buttonClasses() {
            return [
                "btn",
                `btn-${this.variant}`,
                `btn-${this.size}`,
                {
                    "btn-full-width": this.fullWidth,
                    "btn-disabled": this.disabled,
                    "btn-loading": this.loading,
                    "btn-icon-only": this.icon && !this.$slots.default,
                },
            ];
        },
    },
};
</script>

<style scoped>
/* ===== MODERN BUTTONS 2026 ===== */
.btn {
    position: relative;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: var(--spacing-2);
    font-family: var(--font-family-base);
    font-weight: var(--font-weight-semibold);
    border-radius: var(--radius-lg);
    transition:
        transform var(--transition-fast),
        box-shadow var(--transition-fast),
        background var(--transition-fast);
    cursor: pointer;
    border: none;
    text-decoration: none;
    white-space: nowrap;
    overflow: hidden;
}

/* Sizes */
.btn-sm {
    padding: var(--spacing-2) var(--spacing-4);
    font-size: var(--font-size-sm);
    min-height: 36px;
}

.btn-md {
    padding: var(--spacing-3) var(--spacing-6);
    font-size: var(--font-size-base);
    min-height: 44px;
}

.btn-lg {
    padding: var(--spacing-4) var(--spacing-8);
    font-size: var(--font-size-lg);
    min-height: 52px;
}

/* === PRIMARY - Gradient vibrant === */
.btn-primary {
    background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
    color: var(--color-white);
    box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
}

.btn-primary:hover:not(:disabled) {
    background: linear-gradient(135deg, #818cf8 0%, #c084fc 100%);
    box-shadow: 0 8px 24px rgba(99, 102, 241, 0.4);
    transform: translateY(-2px);
}

.btn-primary:active:not(:disabled) {
    transform: translateY(0);
    box-shadow: 0 2px 8px rgba(99, 102, 241, 0.3);
}

/* === SECONDARY - Rose à Orange === */
.btn-secondary {
    background: linear-gradient(135deg, #ec4899 0%, #f97316 100%);
    color: var(--color-white);
    box-shadow: 0 4px 12px rgba(236, 72, 153, 0.3);
}

.btn-secondary:hover:not(:disabled) {
    background: linear-gradient(135deg, #f472b6 0%, #fb923c 100%);
    box-shadow: 0 8px 24px rgba(236, 72, 153, 0.4);
    transform: translateY(-2px);
}

/* === SUCCESS === */
.btn-success {
    background: linear-gradient(135deg, #10b981 0%, #34d399 100%);
    color: var(--color-white);
    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
}

.btn-success:hover:not(:disabled) {
    box-shadow: 0 8px 24px rgba(16, 185, 129, 0.4);
    transform: translateY(-2px);
}

/* === DANGER === */
.btn-danger {
    background: linear-gradient(135deg, #ef4444 0%, #f87171 100%);
    color: var(--color-white);
    box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
}

.btn-danger:hover:not(:disabled) {
    box-shadow: 0 8px 24px rgba(239, 68, 68, 0.4);
    transform: translateY(-2px);
}

/* === WARNING === */
.btn-warning {
    background: linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%);
    color: var(--color-white);
    box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
}

.btn-warning:hover:not(:disabled) {
    box-shadow: 0 8px 24px rgba(245, 158, 11, 0.4);
    transform: translateY(-2px);
}

/* === OUTLINE - Minimaliste === */
.btn-outline {
    background: transparent;
    color: var(--color-primary);
    border: 1.5px solid var(--color-primary);
}

.btn-outline:hover:not(:disabled) {
    background: var(--color-primary-bg);
    transform: translateY(-2px);
}

/* === GHOST - Très léger === */
.btn-ghost {
    background: transparent;
    color: var(--color-text-secondary);
    border: none;
}

.btn-ghost:hover:not(:disabled) {
    background: #f3f4f6;
    color: var(--color-text-primary);
    transform: translateY(-1px);
}

/* States */
.btn-disabled,
.btn:disabled {
    opacity: 0.5;
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
    width: 18px;
    height: 18px;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-top-color: white;
    border-radius: 50%;
    animation: spin 0.8s cubic-bezier(0.5, 0, 0.5, 1) infinite;
}

@keyframes spin {
    0% {
        transform: rotate(0deg);
    }
    100% {
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
    width: 36px;
    height: 36px;
    padding: 0;
}

.btn-icon-only.btn-md {
    width: 44px;
    height: 44px;
    padding: 0;
}

.btn-icon-only.btn-lg {
    width: 52px;
    height: 52px;
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
        animation: none;
        border: 2px solid rgba(255, 255, 255, 0.5);
        border-top: 2px solid white;
    }
}
</style>
