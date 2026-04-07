<script setup>
import { ref, onMounted } from 'vue'

const activeIndex = ref(-1)
const showFile = ref(false)
const showInsight = ref(false)

const contexts = [
  {
    tool: 'Claude Code / Codex / Cursor',
    icon: '⌨️',
    path: '.claude/skills/repo-roast/SKILL.md',
    status: 'Scripts execute directly',
    statusIcon: '⚡',
    color: '#6363F1',
    detail: 'Full script execution — evidence-driven analysis',
  },
  {
    tool: 'Claude Desktop / Web',
    icon: '💬',
    path: 'Same SKILL.md',
    status: 'Paste context in',
    statusIcon: '📋',
    color: '#0ea5e9',
    detail: 'No scripts, but constraints + structure still shape output',
  },
  {
    tool: 'Agent SDK / Pi / CI',
    icon: '🤖',
    path: 'Same SKILL.md',
    status: 'Programmatic invocation',
    statusIcon: '🔧',
    color: '#10b981',
    detail: 'Skills as the brains of agents, pipelines, and products',
  },
]

onMounted(() => {
  setTimeout(() => { showFile.value = true }, 300)
  contexts.forEach((_, i) => {
    setTimeout(() => { activeIndex.value = i }, 900 + i * 1200)
  })
  setTimeout(() => { showInsight.value = true }, 900 + contexts.length * 1200 + 500)
})
</script>

<template>
  <div class="flex flex-col h-full gap-4">
    <!-- Skill file indicator -->
    <div
      class="flex items-center justify-center gap-3 py-2 transition-all duration-500"
      :class="showFile ? 'opacity-100' : 'opacity-0'"
    >
      <div class="h-px flex-1 bg-gray-200" />
      <div class="flex items-center gap-2 px-4 py-1.5 rounded-full bg-gray-100 border border-gray-200">
        <span class="text-xs">📄</span>
        <span class="font-mono text-xs text-gray-600 font-semibold">SKILL.md</span>
        <span class="text-[10px] text-gray-400">— one file</span>
      </div>
      <div class="h-px flex-1 bg-gray-200" />
    </div>

    <!-- Three contexts -->
    <div class="grid grid-cols-3 gap-4 flex-1">
      <div
        v-for="(ctx, i) in contexts"
        :key="i"
        class="rounded-xl border-2 p-4 flex flex-col transition-all duration-700"
        :class="i <= activeIndex ? 'translate-y-0' : 'translate-y-6'"
        :style="{
          borderColor: i <= activeIndex ? ctx.color + '60' : '#e5e7eb',
          backgroundColor: i <= activeIndex ? ctx.color + '05' : 'white',
          opacity: i <= activeIndex ? 1 : 0.2,
        }"
      >
        <!-- Header -->
        <div class="flex items-center gap-2 mb-3">
          <span class="text-lg">{{ ctx.icon }}</span>
          <span class="text-xs font-bold" :style="{ color: i <= activeIndex ? ctx.color : '#9ca3af' }">
            {{ ctx.tool }}
          </span>
        </div>

        <!-- Path -->
        <div class="font-mono text-[10px] text-gray-400 mb-3 bg-white/60 rounded px-2 py-1">
          {{ ctx.path }}
        </div>

        <!-- Status -->
        <div
          class="flex items-center gap-1.5 mb-2 transition-all duration-500"
          :class="i <= activeIndex ? 'opacity-100' : 'opacity-0'"
        >
          <span
            class="h-2 w-2 rounded-full"
            :class="i === activeIndex ? 'animate-pulse' : ''"
            :style="{ backgroundColor: ctx.color }"
          />
          <span class="text-xs font-semibold" :style="{ color: ctx.color }">
            {{ ctx.statusIcon }} {{ ctx.status }}
          </span>
        </div>

        <!-- Detail -->
        <p
          class="text-[11px] text-gray-500 leading-relaxed mt-auto transition-all duration-500"
          :class="i <= activeIndex ? 'opacity-100' : 'opacity-0'"
        >
          {{ ctx.detail }}
        </p>
      </div>
    </div>

    <!-- Insight bar -->
    <div
      class="text-center py-2 transition-all duration-500"
      :class="showInsight ? 'opacity-100' : 'opacity-0'"
    >
      <span class="text-xs font-semibold text-[#6363F1]">
        Skills are the portable unit of knowledge. The runtime is interchangeable.
      </span>
    </div>
  </div>
</template>
