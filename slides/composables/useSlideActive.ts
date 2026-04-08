import { computed, watch } from 'vue'
import { useSlideContext } from '@slidev/client/context'

/**
 * Returns a computed boolean that is true when this slide is the current slide.
 * Also calls `onEnter` each time the slide becomes active (including re-visits).
 */
export function useSlideActive(onEnter?: () => void) {
  const { $nav, $page } = useSlideContext()
  const isActive = computed(() => $nav.value.currentPage === $page.value)

  if (onEnter) {
    watch(isActive, (active) => {
      if (active) onEnter()
    }, { immediate: true })
  }

  return isActive
}
