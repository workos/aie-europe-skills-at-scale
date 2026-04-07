<script setup>
defineProps({
  maxHeight: { type: String, default: '420px' },
})
</script>

<template>
  <div
    class="overflow-y-auto pr-1"
    :style="{ maxHeight }"
  >
    <slot />
  </div>
</template>

<style scoped>
div::-webkit-scrollbar {
  width: 4px;
}
div::-webkit-scrollbar-track {
  background: transparent;
}
div::-webkit-scrollbar-thumb {
  background: #d1d5db;
  border-radius: 2px;
}
</style>
