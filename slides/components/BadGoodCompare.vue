<script setup>
import { ref, onMounted } from 'vue'

const showBad = ref(false)
const showGood = ref(false)
const goodLines = ref([])
const showVerdict = ref(false)

const badOutput = "Your codebase looks pretty good overall. Consider adding more tests and updating documentation."

const goodOutputLines = [
  { label: 'Health score', value: '4/10', color: 'text-red-600' },
  { label: 'God file', value: 'handler.ts — 2,847 lines, handles auth, routing, AND database queries', color: 'text-gray-800' },
  { label: 'Stale TODOs', value: '14 TODO comments, oldest from March 2023', color: 'text-gray-800' },
  { label: 'README drift', value: 'References yarn start but lockfile is pnpm-lock.yaml', color: 'text-gray-800' },
  { label: 'Bus factor', value: 'src/auth/ — only 1 contributor in 6 months', color: 'text-gray-800' },
]

onMounted(() => {
  setTimeout(() => { showBad.value = true }, 400)
  setTimeout(() => { showGood.value = true }, 1600)

  goodOutputLines.forEach((line, i) => {
    setTimeout(() => {
      goodLines.value.push(line)
    }, 2200 + i * 500)
  })

  setTimeout(() => { showVerdict.value = true }, 2200 + goodOutputLines.length * 500 + 400)
})
</script>

<template>
  <div class="grid grid-cols-2 gap-6 h-full">
    <!-- Bad side -->
    <div
      class="rounded-xl border-2 p-5 transition-all duration-700 flex flex-col"
      :class="showBad
        ? 'border-gray-300 bg-gray-50 opacity-100 translate-y-0'
        : 'border-transparent bg-transparent opacity-0 translate-y-4'"
    >
      <div class="flex items-center gap-2 mb-3">
        <span class="h-2.5 w-2.5 rounded-full bg-gray-400" />
        <span class="text-xs font-mono font-semibold text-gray-500 uppercase tracking-wider">Without a skill</span>
      </div>

      <div class="font-mono text-xs text-gray-400 mb-3 bg-gray-100 rounded-lg p-3 border border-gray-200">
        # Repo Health Check<br/>
        Look at this repository and tell me how it's doing.<br/>
        Be helpful and thorough.
      </div>

      <div class="flex-1 flex items-start">
        <p class="text-sm text-gray-500 italic leading-relaxed">
          "{{ badOutput }}"
        </p>
      </div>

      <div
        class="mt-3 text-xs font-semibold text-gray-400 uppercase tracking-wider transition-all duration-500"
        :class="showVerdict ? 'opacity-100' : 'opacity-0'"
      >
        Generic. No evidence. Useless.
      </div>
    </div>

    <!-- Good side -->
    <div
      class="rounded-xl border-2 p-5 transition-all duration-700 flex flex-col"
      :class="showGood
        ? 'border-[#6363F1]/40 bg-[#6363F1]/[0.03] opacity-100 translate-y-0'
        : 'border-transparent bg-transparent opacity-0 translate-y-4'"
    >
      <div class="flex items-center gap-2 mb-3">
        <span class="h-2.5 w-2.5 rounded-full bg-[#6363F1] animate-pulse" />
        <span class="text-xs font-mono font-semibold text-[#6363F1] uppercase tracking-wider">With a skill</span>
      </div>

      <div class="font-mono text-xs text-gray-400 mb-3 bg-white rounded-lg p-3 border border-[#6363F1]/20">
        ~30 lines of markdown: description, scripts, constraints
      </div>

      <div class="flex-1 space-y-2">
        <div
          v-for="(line, i) in goodLines"
          :key="i"
          class="flex gap-2 text-sm transition-all duration-500"
          :class="'translate-y-0 opacity-100'"
        >
          <span class="font-semibold text-[#6363F1] whitespace-nowrap text-xs mt-0.5">{{ line.label }}:</span>
          <span :class="line.color" class="text-xs leading-relaxed">{{ line.value }}</span>
        </div>
      </div>

      <div
        class="mt-3 text-xs font-semibold text-[#6363F1] uppercase tracking-wider transition-all duration-500"
        :class="showVerdict ? 'opacity-100' : 'opacity-0'"
      >
        Specific. Evidence-backed. Actionable.
      </div>
    </div>
  </div>
</template>
