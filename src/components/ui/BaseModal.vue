<template>
    <Teleport to="body">
        <Transition name="modal">
            <div
                v-if="modelValue"
                class="modal-overlay"
                @click.self="handleOverlayClick"
            >
                <div :class="modalClasses" role="dialog" aria-modal="true">
                    <!-- Header -->
                    <div v-if="$slots.header || title" class="modal-header">
                        <slot name="header">
                            <h2 class="modal-title">{{ title }}</h2>
                        </slot>
                        <button
                            v-if="showClose"
                            class="modal-close"
                            @click="close"
                            aria-label="Fermer"
                        >
                            <svg
                                width="24"
                                height="24"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="2"
                            >
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>

                    <!-- Body -->
                    <div class="modal-body">
                        <slot></slot>
                    </div>

                    <!-- Footer -->
                    <div v-if="$slots.footer" class="modal-footer">
                        <slot name="footer"></slot>
                    </div>
                </div>
            </div>
        </Transition>
    </Teleport>
</template>

<script>
export default {
    name: "BaseModal",
    props: {
        modelValue: {
            type: Boolean,
            default: false,
        },
        title: {
            type: String,
            default: "",
        },
        size: {
            type: String,
            default: "md",
            validator: (value) =>
                ["sm", "md", "lg", "xl", "full"].includes(value),
        },
        showClose: {
            type: Boolean,
            default: true,
        },
        closeOnOverlay: {
            type: Boolean,
            default: true,
        },
        closeOnEscape: {
            type: Boolean,
            default: true,
        },
    },
    emits: ["update:modelValue", "close"],
    computed: {
        modalClasses() {
            return ["modal", `modal-${this.size}`];
        },
    },
    watch: {
        modelValue(newValue) {
            if (newValue) {
                document.body.style.overflow = "hidden";
                document.addEventListener("keydown", this.handleEscape);
            } else {
                document.body.style.overflow = "";
                document.removeEventListener("keydown", this.handleEscape);
            }
        },
    },
    beforeUnmount() {
        document.body.style.overflow = "";
        document.removeEventListener("keydown", this.handleEscape);
    },
    methods: {
        close() {
            this.$emit("update:modelValue", false);
            this.$emit("close");
        },
        handleOverlayClick() {
            if (this.closeOnOverlay) {
                this.close();
            }
        },
        handleEscape(event) {
            if (event.key === "Escape" && this.closeOnEscape) {
                this.close();
            }
        },
    },
};
</script>

<style scoped>
/* ===== MODERN MODAL 2026 ===== */
.modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.4);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: var(--spacing-4);
    z-index: var(--z-index-modal);
}

.modal {
    position: relative;
    background: #ffffff;
    border-radius: var(--radius-lg);
    border: 1px solid #e5e7eb;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
    display: flex;
    flex-direction: column;
    max-height: 90vh;
    overflow: hidden;
}

/* Sizes */
.modal-sm {
    width: 100%;
    max-width: 420px;
}

.modal-md {
    width: 100%;
    max-width: 560px;
}

.modal-lg {
    width: 100%;
    max-width: 760px;
}

.modal-xl {
    width: 100%;
    max-width: 1000px;
}

.modal-full {
    width: calc(100% - var(--spacing-8));
    height: calc(100% - var(--spacing-8));
    max-width: none;
    max-height: none;
}

/* Header */
.modal-header {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: var(--spacing-5) var(--spacing-6);
    border-bottom: 1px solid #e5e7eb;
    z-index: 1;
}

.modal-title {
    font-size: var(--font-size-xl);
    font-weight: var(--font-weight-semibold);
    color: var(--color-text-primary);
    margin: 0;
}

.modal-close {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 36px;
    height: 36px;
    border-radius: var(--radius-md);
    color: var(--color-text-secondary);
    transition: all var(--transition-fast);
    background: transparent;
    border: 1px solid #e5e7eb;
}

.modal-close:hover {
    background: #f3f4f6;
    color: var(--color-text-primary);
    transform: scale(1.05);
}

.modal-close:active {
    transform: scale(0.95);
}

/* Body */
.modal-body {
    position: relative;
    padding: var(--spacing-6);
    overflow-y: auto;
    flex: 1;
    z-index: 1;
    color: var(--color-text-primary);
}

/* Footer */
.modal-footer {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: var(--spacing-3);
    padding: var(--spacing-5) var(--spacing-6);
    border-top: 1px solid #e5e7eb;
    z-index: 1;
    background: #f9fafb;
}

/* Transition fluide */
.modal-enter-active,
.modal-leave-active {
    transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.modal-enter-active .modal,
.modal-leave-active .modal {
    transition:
        transform 0.4s cubic-bezier(0.4, 0, 0.2, 1),
        opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
    opacity: 0;
}

.modal-enter-from .modal {
    transform: scale(0.95) translateY(10px);
    opacity: 0;
}

.modal-leave-to .modal {
    transform: scale(0.95) translateY(10px);
    opacity: 0;
}

/* Mobile */
@media (max-width: 640px) {
    .modal {
        border-radius: var(--radius-lg);
        max-height: 85vh;
    }

    .modal-header,
    .modal-body,
    .modal-footer {
        padding-left: var(--spacing-4);
        padding-right: var(--spacing-4);
    }
}

/* Préférence mouvement réduit */
@media (prefers-reduced-motion: reduce) {
    .modal-enter-active .modal,
    .modal-leave-active .modal {
        transition: opacity 0.2s ease;
    }

    .modal-enter-from .modal,
    .modal-leave-to .modal {
        transform: none;
    }
}
</style>
