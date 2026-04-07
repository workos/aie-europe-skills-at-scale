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
  <div class="grid grid-cols-2 gap-4 max-h-[420px]">
    <!-- Bad side -->
    <div
      class="rounded-xl border-2 p-3 transition-all duration-700 flex flex-col"
      :class="showBad
        ? 'border-gray-300 bg-gray-50 opacity-100 translate-y-0'
        : 'border-transparent bg-transparent opacity-0 translate-y-4'"
    >
      <div class="flex items-center gap-2 mb-2">
        <span class="h-2 w-2 rounded-full bg-gray-400" />
        <span class="text-[10px] font-mono font-semibold text-gray-500 uppercase tracking-wider">Without a skill</span>
      </div>

      <div class="font-mono text-[11px] text-gray-400 mb-2 bg-gray-100 rounded-lg p-2 border border-gray-200 leading-snug">
        # Repo Health Check<br/>
        Look at this repository and tell me how it's doing.<br/>
        Be helpful and thorough.
      </div>

      <p class="text-xs text-gray-500 italic leading-snug">
        "{{ badOutput }}"
      </p>

      <div
        class="mt-auto pt-2 text-[10px] font-semibold text-gray-400 uppercase tracking-wider transition-all duration-500"
        :class="showVerdict ? 'opacity-100' : 'opacity-0'"
      >
        Generic. No evidence. Useless.
      </div>
    </div>

    <!-- Good side -->
    <div
      class="rounded-xl border-2 p-3 transition-all duration-700 flex flex-col"
      :class="showGood
        ? 'border-[#6363F1]/40 bg-[#6363F1]/[0.03] opacity-100 translate-y-0'
        : 'border-transparent bg-transparent opacity-0 translate-y-4'"
    >
      <div class="flex items-center gap-2 mb-2">
        <span class="h-2 w-2 rounded-full bg-[#6363F1] animate-pulse" />
        <span class="text-[10px] font-mono font-semibold text-[#6363F1] uppercase tracking-wider">With a skill</span>
      </div>

      <div class="font-mono text-[11px] text-gray-400 mb-2 bg-white rounded-lg p-2 border border-[#6363F1]/20 leading-snug">
        ~30 lines of markdown: description, scripts, constraints
      </div>

      <div class="space-y-1.5">
        <div
          v-for="(line, i) in goodLines"
          :key="i"
          class="flex gap-1.5 transition-all duration-500"
          :class="'translate-y-0 opacity-100'"
        >
          <span class="font-semibold text-[#6363F1] whitespace-nowrap text-[11px]">{{ line.label }}:</span>
          <span :class="line.color" class="text-[11px] leading-snug">{{ line.value }}</span>
        </div>
      </div>

      <div
        class="mt-auto pt-2 text-[10px] font-semibold text-[#6363F1] uppercase tracking-wider transition-all duration-500"
        :class="showVerdict ? 'opacity-100' : 'opacity-0'"
      >
        Specific. Evidence-backed. Actionable.
      </div>
    </div>
  </div>
</template>
