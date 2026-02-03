<template>
  <div class="variante-selector">
    <div
      v-for="(valeurs, type) in variantesGroupees"
      :key="type"
      class="variante-group"
    >
      <label class="variante-label">{{ type }}</label>

      <div class="variante-options">
        <button
          v-for="item in valeurs"
          :key="item.id"
          :class="[
            'variante-option',
            { active: isVarianteSelected(type, item.id) }
          ]"
          @click="selectVariante(type, item)"
        >
          <img
            v-if="item.image_url"
            :src="item.image_url"
            :alt="item.valeur"
            class="option-image"
          />
          <span class="option-text">{{ item.valeur }}</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'VarianteSelector',
  props: {
    variantesGroupees: {
      type: Object,
      required: true,
      default: () => ({})
    },
    selectedVariantes: {
      type: Object,
      default: () => ({})
    }
  },
  emits: ['update:selectedVariantes', 'variante-selected'],
  methods: {
    selectVariante(type, item) {
      const updatedVariantes = {
        ...this.selectedVariantes,
        [type]: item
      }
      this.$emit('update:selectedVariantes', updatedVariantes)
      this.$emit('variante-selected', { type, item })
    },
    isVarianteSelected(type, itemId) {
      return this.selectedVariantes[type]?.id === itemId
    }
  }
}
</script>

<style scoped>
.variante-selector {
  display: flex;
  flex-direction: column;
  gap: 24px;
  padding: 20px 0;
}

.variante-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.variante-label {
  font-size: 14px;
  font-weight: 600;
  color: #111827;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.variante-options {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.variante-option {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px 16px;
  background: #ffffff;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  cursor: pointer;
  transition: all 200ms ease;
  font-size: 14px;
  font-weight: 500;
  color: #374151;
  min-width: 80px;
}

.variante-option:hover {
  border-color: #6366f1;
  background: #f3f4f6;
  transform: translateY(-2px);
}

.variante-option.active {
  background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
  border-color: #6366f1;
  color: white;
  box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
}

.option-image {
  width: 48px;
  height: 48px;
  object-fit: cover;
  border-radius: 8px;
}

.option-text {
  text-align: center;
}

@media (max-width: 768px) {
  .variante-selector {
    gap: 16px;
  }

  .variante-option {
    flex: 1;
    min-width: 70px;
    padding: 10px 12px;
    font-size: 13px;
  }

  .option-image {
    width: 40px;
    height: 40px;
  }
}
</style>
