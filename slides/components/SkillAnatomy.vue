<script setup>
import { ref, onMounted, computed } from 'vue'

const activeSection = ref(-1)

const sections = [
  {
    id: 'frontmatter',
    label: 'Frontmatter',
    desc: 'How the AI finds and routes to your skill',
    color: '#6363F1',
    lines: [
      { text: '---', dim: true },
      { text: 'name: repo-roast' },
      { text: 'description: Analyzes repository health' },
      { text: '  using git scripts. Use for repo audits.' },
      { text: '---', dim: true },
    ],
  },
  {
    id: 'context',
    label: 'Context + Scripts',
    desc: 'Shell commands that inject real evidence',
    color: '#0ea5e9',
    lines: [
      { text: '## Context' },
      { text: 'Stale TODOs: !`grep -rn "TODO" . | head -20`', script: true },
      { text: 'Hotspots: !`git log --name-only | sort | uniq -c`', script: true },
      { text: 'Largest files: !`git ls-files | xargs wc -l`', script: true },
    ],
  },
  {
    id: 'constraints',
    label: 'Constraints',
    desc: 'Close off failure modes',
    color: '#f59e0b',
    lines: [
      { text: '## Constraints' },
      { text: '- Never be vague — cite specific files' },
      { text: '- Every finding needs evidence + severity' },
      { text: '- Never recommend "rewrite from scratch"' },
      { text: '- Maximum 10 findings, ordered by severity' },
    ],
  },
  {
    id: 'structure',
    label: 'Structure',
    desc: 'What the AI delivers and in what order',
    color: '#10b981',
    lines: [
      { text: '## Structure' },
      { text: '1. One-line health verdict (score /10)' },
      { text: '2. Top findings: issue, evidence, severity, fix' },
      { text: '3. One thing the repo does well' },
    ],
  },
]

onMounted(() => {
  sections.forEach((_, i) => {
    setTimeout(() => { activeSection.value = i }, 800 + i * 1400)
  })
})

const allLines = computed(() => {
  return sections.flatMap((section, sIdx) => {
    return section.lines.map(line => ({
      ...line,
      sectionIndex: sIdx,
      color: section.color,
    }))
  })
})
</script>

<template>
  <div class="grid grid-cols-5 gap-4 max-h-[400px]">
    <!-- Code view -->
    <div class="col-span-3 bg-gray-50 rounded-xl border border-gray-200 p-3 font-mono text-[11px] overflow-hidden">
      <div class="flex items-center gap-1.5 mb-2 pb-1.5 border-b border-gray-200">
        <span class="h-2.5 w-2.5 rounded-full bg-red-400" />
        <span class="h-2.5 w-2.5 rounded-full bg-amber-400" />
        <span class="h-2.5 w-2.5 rounded-full bg-green-400" />
        <span class="ml-2 text-gray-400 text-[10px]">SKILL.md</span>
      </div>

      <div class="space-y-0">
        <div
          v-for="(line, i) in allLines"
          :key="i"
          class="py-0.5 px-2 rounded transition-all duration-500 leading-relaxed"
          :class="[
            line.sectionIndex <= activeSection
              ? line.dim
                ? 'text-gray-400'
                : 'text-gray-800'
              : 'text-gray-300',
            line.sectionIndex === activeSection && !line.dim
              ? 'bg-white shadow-sm border-l-2'
              : 'border-l-2 border-transparent',
          ]"
          :style="line.sectionIndex === activeSection && !line.dim ? { borderColor: line.color } : {}"
        >
          <span v-if="line.script" class="text-sky-600">{{ line.text }}</span>
          <span v-else>{{ line.text }}</span>
        </div>
      </div>
    </div>

    <!-- Labels -->
    <div class="col-span-2 flex flex-col justify-center space-y-2">
      <div
        v-for="(section, i) in sections"
        :key="section.id"
        class="rounded-lg p-2 transition-all duration-500 border-l-3"
        :class="[
          i <= activeSection ? 'opacity-100 translate-x-0' : 'opacity-0 translate-x-4',
          i === activeSection ? 'bg-white shadow-md' : 'bg-transparent',
        ]"
        :style="{ borderLeftColor: i <= activeSection ? section.color : 'transparent' }"
      >
        <div class="flex items-center gap-2 mb-1">
          <span class="h-2 w-2 rounded-full" :style="{ backgroundColor: section.color }" />
          <span class="text-xs font-bold uppercase tracking-wider" :style="{ color: section.color }">
            {{ section.label }}
          </span>
        </div>
        <p class="text-[11px] text-gray-600 leading-snug">{{ section.desc }}</p>
      </div>
    </div>
  </div>
</template>
