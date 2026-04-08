<script setup>
import { ref, onMounted } from 'vue'

const activeCondition = ref(-1)

const tree = [
  { name: 'repo-roast/', indent: 0, icon: '📁', condition: -1 },
  { name: 'SKILL.md', indent: 1, icon: '📄', note: 'entry point — always loaded', condition: -1, always: true },
  { name: 'references/', indent: 1, icon: '📁', condition: -1 },
  { name: 'scoring-rubric.md', indent: 2, icon: '📄', note: 'loaded when scoring findings', condition: 0 },
  { name: 'git-scripts.md', indent: 2, icon: '⚡', note: 'loaded when gathering evidence', condition: 1 },
  { name: 'recommendation-templates.md', indent: 2, icon: '📄', note: 'loaded when writing recommendations', condition: 2 },
]

const conditions = [
  {
    label: 'Scoring findings?',
    action: 'Load scoring-rubric.md',
    desc: 'Severity criteria, evidence thresholds',
    color: '#0ea5e9',
  },
  {
    label: 'Gathering evidence?',
    action: 'Load git-scripts.md',
    desc: 'Shell commands for repo analysis',
    color: '#6363F1',
  },
  {
    label: 'Writing recommendations?',
    action: 'Load recommendation-templates.md',
    desc: 'Output format, prioritization rules',
    color: '#10b981',
  },
]

const showTree = ref(false)
const showConditions = ref(false)

onMounted(() => {
  setTimeout(() => { showTree.value = true }, 300)
  setTimeout(() => { showConditions.value = true }, 1000)
  conditions.forEach((_, i) => {
    setTimeout(() => { activeCondition.value = i }, 1800 + i * 2000)
  })
})

function getColor(condition) {
  if (condition < 0) return null
  return conditions[condition]?.color
}

function isActive(item) {
  if (item.always) return true
  if (item.condition < 0) return activeCondition.value >= 0
  return item.condition <= activeCondition.value
}

function isHighlighted(item) {
  return item.condition >= 0 && item.condition === activeCondition.value
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
            backgroundColor: isHighlighted(item) ? getColor(item.condition) + '10' : 'transparent',
            borderLeft: isHighlighted(item) ? `3px solid ${getColor(item.condition)}` : '3px solid transparent',
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
            :style="{ color: getColor(item.condition) || '#9ca3af' }"
          >{{ item.note }}</span>
        </div>
      </div>
    </div>

    <!-- Condition indicators -->
    <div
      class="flex flex-col justify-center space-y-2 transition-all duration-700"
      :class="showConditions ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'"
    >
      <div class="text-xs text-gray-400 uppercase tracking-wider font-semibold mb-1">Conditional loading</div>

      <div
        v-for="(cond, i) in conditions"
        :key="i"
        class="rounded-lg p-2.5 border-2 transition-all duration-500"
        :class="i <= activeCondition ? 'translate-x-0' : 'translate-x-4'"
        :style="{
          borderColor: i <= activeCondition ? cond.color : '#e5e7eb',
          backgroundColor: i === activeCondition ? cond.color + '08' : 'white',
          opacity: i <= activeCondition ? 1 : 0.3,
        }"
      >
        <div class="flex items-center gap-2 mb-1">
          <span
            class="h-3 w-3 rounded-full transition-all duration-300"
            :style="{ backgroundColor: i <= activeCondition ? cond.color : '#d1d5db' }"
            :class="i === activeCondition ? 'animate-pulse' : ''"
          />
          <span class="text-sm font-bold" :style="{ color: i <= activeCondition ? cond.color : '#9ca3af' }">
            {{ cond.label }}
          </span>
        </div>
        <p class="text-xs ml-5">
          <span class="font-semibold" :style="{ color: i <= activeCondition ? cond.color : '#9ca3af' }">→ {{ cond.action }}</span>
          <span class="text-gray-500 ml-1">{{ cond.desc }}</span>
        </p>
      </div>

      <div
        class="mt-1 p-2 rounded-lg bg-amber-50 border border-amber-200 text-[11px] text-amber-800 transition-all duration-500"
        :class="activeCondition >= 2 ? 'opacity-100' : 'opacity-0'"
      >
        <span class="font-semibold">Key:</span> External files are real gates. The model only loads what the task needs — not everything at once.
      </div>
    </div>
  </div>
</template>
