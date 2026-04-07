<script setup>
import { ref, onMounted } from 'vue'

const activePhase = ref(-1)

const tree = [
  { name: 'my-skill/', indent: 0, icon: '📁', phase: -1 },
  { name: 'SKILL.md', indent: 1, icon: '📄', note: 'entry point + phase routing', phase: -1, always: true },
  { name: 'phases/', indent: 1, icon: '📁', phase: -1 },
  { name: 'gather.md', indent: 2, icon: '📄', note: 'loaded in phase 1', phase: 0 },
  { name: 'categorize.md', indent: 2, icon: '📄', note: 'loaded in phase 2', phase: 1 },
  { name: 'recommend.md', indent: 2, icon: '📄', note: 'loaded in phase 3', phase: 2 },
  { name: 'scripts/', indent: 1, icon: '📁', phase: -1 },
  { name: 'quick-scan.sh', indent: 2, icon: '⚡', note: 'runs in phase 1', phase: 0 },
  { name: 'deep-analysis.sh', indent: 2, icon: '⚡', note: 'runs if phase 1 warrants it', phase: 1 },
]

const phases = [
  { label: 'Phase 1: Gather', desc: 'Run scripts, collect raw data', color: '#0ea5e9' },
  { label: 'Phase 2: Categorize', desc: 'Classify findings, score severity', color: '#6363F1' },
  { label: 'Phase 3: Recommend', desc: 'Prioritized actions, final report', color: '#10b981' },
]

const showTree = ref(false)
const showPhases = ref(false)

onMounted(() => {
  setTimeout(() => { showTree.value = true }, 300)
  setTimeout(() => { showPhases.value = true }, 1000)
  phases.forEach((_, i) => {
    setTimeout(() => { activePhase.value = i }, 1800 + i * 1800)
  })
})

function getPhaseColor(phase) {
  if (phase < 0) return null
  return phases[phase]?.color
}

function isActive(item) {
  if (item.always) return true
  if (item.phase < 0) return activePhase.value >= 0
  return item.phase <= activePhase.value
}

function isHighlighted(item) {
  return item.phase >= 0 && item.phase === activePhase.value
}
</script>

<template>
  <div class="grid grid-cols-2 gap-6 max-h-[400px]">
    <!-- Tree view -->
    <div
      class="bg-gray-50 rounded-xl border border-gray-200 p-3 font-mono text-xs transition-all duration-700"
      :class="showTree ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'"
    >
      <div class="text-xs text-gray-400 uppercase tracking-wider font-semibold mb-3">Skill folder structure</div>

      <div class="space-y-1">
        <div
          v-for="(item, i) in tree"
          :key="i"
          class="flex items-center gap-2 py-1 px-2 rounded transition-all duration-500"
          :style="{
            paddingLeft: `${item.indent * 20 + 8}px`,
            backgroundColor: isHighlighted(item) ? getPhaseColor(item.phase) + '10' : 'transparent',
            borderLeft: isHighlighted(item) ? `3px solid ${getPhaseColor(item.phase)}` : '3px solid transparent',
          }"
          :class="isActive(item) ? 'opacity-100' : 'opacity-30'"
        >
          <span class="text-xs">{{ item.icon }}</span>
          <span
            class="font-medium"
            :class="isHighlighted(item) ? 'text-gray-900' : 'text-gray-600'"
          >{{ item.name }}</span>
          <span
            v-if="item.note && isActive(item)"
            class="text-[10px] ml-auto transition-opacity duration-300"
            :style="{ color: getPhaseColor(item.phase) || '#9ca3af' }"
          >{{ item.note }}</span>
        </div>
      </div>
    </div>

    <!-- Phase indicators -->
    <div
      class="flex flex-col justify-center space-y-2 transition-all duration-700"
      :class="showPhases ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'"
    >
      <div class="text-xs text-gray-400 uppercase tracking-wider font-semibold mb-1">Progressive disclosure</div>

      <div
        v-for="(phase, i) in phases"
        :key="i"
        class="rounded-lg p-2.5 border-2 transition-all duration-500"
        :class="i <= activePhase ? 'translate-x-0' : 'translate-x-4'"
        :style="{
          borderColor: i <= activePhase ? phase.color : '#e5e7eb',
          backgroundColor: i === activePhase ? phase.color + '08' : 'white',
          opacity: i <= activePhase ? 1 : 0.3,
        }"
      >
        <div class="flex items-center gap-2 mb-1">
          <span
            class="h-3 w-3 rounded-full transition-all duration-300"
            :style="{ backgroundColor: i <= activePhase ? phase.color : '#d1d5db' }"
            :class="i === activePhase ? 'animate-pulse' : ''"
          />
          <span class="text-sm font-bold" :style="{ color: i <= activePhase ? phase.color : '#9ca3af' }">
            {{ phase.label }}
          </span>
        </div>
        <p class="text-xs text-gray-500 ml-5">{{ phase.desc }}</p>
        <div
          v-if="i < phases.length - 1"
          class="ml-[7px] mt-1 h-2 border-l-2 border-dashed transition-colors duration-300"
          :style="{ borderColor: i < activePhase ? phase.color + '40' : '#e5e7eb' }"
        />
      </div>

      <div
        class="mt-1 p-2 rounded-lg bg-amber-50 border border-amber-200 text-[11px] text-amber-800 transition-all duration-500"
        :class="activePhase >= 2 ? 'opacity-100' : 'opacity-0'"
      >
        <span class="font-semibold">Key insight:</span> Each phase loads different files. The model only sees what that phase needs — not the whole skill at once.
      </div>
    </div>
  </div>
</template>
