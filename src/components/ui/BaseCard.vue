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
    name: "BaseCard",
    props: {
        title: {
            type: String,
            default: "",
        },
        subtitle: {
            type: String,
            default: "",
        },
        image: {
            type: String,
            default: "",
        },
        imageAlt: {
            type: String,
            default: "",
        },
        variant: {
            type: String,
            default: "default",
            validator: (value) =>
                ["default", "outlined", "elevated"].includes(value),
        },
        padding: {
            type: String,
            default: "md",
            validator: (value) => ["none", "sm", "md", "lg"].includes(value),
        },
        hoverable: {
            type: Boolean,
            default: false,
        },
        clickable: {
            type: Boolean,
            default: false,
        },
    },
    computed: {
        cardClasses() {
            return [
                "card",
                `card-${this.variant}`,
                `card-padding-${this.padding}`,
                {
                    "card-hoverable": this.hoverable,
                    "card-clickable": this.clickable,
                },
            ];
        },
    },
};
</script>

<style scoped>
/* ===== MODERN CARD 2026 ===== */
.card {
    position: relative;
    background: #ffffff;
    border-radius: var(--radius-lg);
    overflow: hidden;
    transition:
        transform var(--transition-fast),
        box-shadow var(--transition-fast),
        background var(--transition-fast);
    border: 1px solid #e5e7eb;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

/* Variants */
.card-default {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.card-outlined {
    border: 1.5px solid #e5e7eb;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.card-elevated {
    background: #ffffff;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
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

/* Hoverable - Effet d'élévation moderne */
.card-hoverable {
    cursor: pointer;
}

.card-hoverable:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12);
    border-color: #d1d5db;
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
    transform: scale(1.05);
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
    border-top: 1px solid #e5e7eb;
    margin-top: auto;
}

/* Mobile responsive */
@media (max-width: 768px) {
    .card {
        border-radius: var(--radius-lg);
    }

    .card-hoverable:hover {
        transform: none;
    }

    .card-hoverable:hover .card-image img {
        transform: none;
    }

    .card-clickable:active {
        transform: scale(0.96);
    }

    .card-title {
        font-size: var(--font-size-base);
    }
}

/* Préférence mouvement réduit */
@media (prefers-reduced-motion: reduce) {
    .card {
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
