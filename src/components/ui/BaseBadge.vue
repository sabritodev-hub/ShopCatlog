<template>
    <span :class="badgeClasses">
        <slot></slot>
    </span>
</template>

<script>
export default {
    name: "BaseBadge",
    props: {
        variant: {
            type: String,
            default: "default",
            validator: (value) =>
                [
                    "default",
                    "primary",
                    "secondary",
                    "success",
                    "warning",
                    "danger",
                    "info",
                ].includes(value),
        },
        size: {
            type: String,
            default: "md",
            validator: (value) => ["sm", "md", "lg"].includes(value),
        },
        rounded: {
            type: Boolean,
            default: false,
        },
    },
    computed: {
        badgeClasses() {
            return [
                "badge",
                `badge-${this.variant}`,
                `badge-${this.size}`,
                {
                    "badge-rounded": this.rounded,
                },
            ];
        },
    },
};
</script>

<style scoped>
/* ===== MODERN BADGE 2026 ===== */
.badge {
    display: inline-flex;
    align-items: center;
    font-weight: var(--font-weight-medium);
    border-radius: var(--radius-md);
    transition: all var(--transition-fast);
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

/* Variants - Modern minimalistes */
.badge-default {
    background: #f3f4f6;
    color: var(--color-text-primary);
}

.badge-primary {
    background: var(--color-primary-bg);
    color: var(--color-primary);
}

.badge-secondary {
    background: var(--color-secondary-bg);
    color: var(--color-secondary);
}

.badge-success {
    background: var(--color-success-bg);
    color: var(--color-success);
}

.badge-warning {
    background: var(--color-warning-bg);
    color: var(--color-warning);
}

.badge-danger {
    background: var(--color-danger-bg);
    color: var(--color-danger);
}

.badge-info {
    background: var(--color-info-bg);
    color: var(--color-info);
}

/* Rounded */
.badge-rounded {
    border-radius: var(--radius-full);
}
</style>
