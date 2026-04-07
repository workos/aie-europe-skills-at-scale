<script setup>
import { ref, onMounted } from 'vue'

const visibleCount = ref(0)
const expandedIndex = ref(-1)

const scripts = [
  {
    title: 'Bus factor',
    desc: 'Files only one person has ever touched',
    icon: '🚌',
    color: '#ef4444',
    cmd: 'git ls-files | while read f; do n=$(git log --format="%an" -- "$f" | sort -u | wc -l); [ "$n" -eq 1 ] && echo "$f"; done | head -15',
    sample: 'src/auth/legacy.ts — alice\nscripts/deploy-old.sh — bob\nlib/crypto.ts — alice',
  },
  {
    title: 'Commit crimes',
    desc: 'Laziest commit messages',
    icon: '🚨',
    color: '#f59e0b',
    cmd: "git log --oneline --since='6 months ago' | grep -iE '^[a-f0-9]+ (fix|wip|temp|asdf)$' | head -15",
    sample: 'a1b2c3d fix\n4e5f6a7 wip\nb8c9d0e temp\nf1a2b3c fix',
  },
  {
    title: 'Zombie branches',
    desc: 'Remote branches nobody touches',
    icon: '🧟',
    color: '#6363F1',
    cmd: "git for-each-ref --sort=committerdate --format='%(committerdate:relative) %(refname:short)' refs/remotes/ | head -15",
    sample: '8 months ago origin/feature/old-auth\n6 months ago origin/fix/legacy-bug\n4 months ago origin/experiment/v2',
  },
  {
    title: '3am commits',
    desc: 'Code written after midnight',
    icon: '🌙',
    color: '#0ea5e9',
    cmd: "git log --format='%ad %s' --date=format:'%H:%M' --since='6 months ago' | awk '$1 < \"06:00\"' | head -10",
    sample: '02:34 fix auth token refresh\n03:12 hotfix: prod down\n04:47 i think this works',
  },
  {
    title: 'README vs Reality',
    desc: 'Commands in README that may not exist',
    icon: '📖',
    color: '#10b981',
    cmd: "grep -oE '(npm|yarn|pnpm|make) [a-z-]+' README.md 2>/dev/null | sort -u",
    sample: 'npm start\nnpm run build\nyarn test\nmake deploy',
  },
]

onMounted(() => {
  scripts.forEach((_, i) => {
    setTimeout(() => { visibleCount.value = i + 1 }, 300 + i * 400)
  })
})

function toggle(i) {
  expandedIndex.value = expandedIndex.value === i ? -1 : i
}
</script>

<template>
  <div class="space-y-2">
    <div class="text-xs text-gray-400 uppercase tracking-wider font-semibold mb-2">
      Pick one. Add it to your ## Context section. Re-run.
    </div>

    <div
      v-for="(script, i) in scripts"
      :key="i"
      class="rounded-lg border transition-all duration-500 cursor-pointer overflow-hidden"
      :class="[
        i < visibleCount ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-3',
        expandedIndex === i ? 'shadow-md' : 'shadow-sm hover:shadow-md',
      ]"
      :style="{
        borderColor: expandedIndex === i ? script.color + '60' : '#e5e7eb',
        backgroundColor: expandedIndex === i ? script.color + '05' : 'white',
      }"
      @click="toggle(i)"
    >
      <!-- Header row -->
      <div class="flex items-center gap-3 px-3 py-2">
        <span class="text-base">{{ script.icon }}</span>
        <span class="text-sm font-bold" :style="{ color: script.color }">{{ script.title }}</span>
        <span class="text-xs text-gray-400">{{ script.desc }}</span>
        <span class="ml-auto text-[10px] text-gray-300">{{ expandedIndex === i ? '▼' : '▶' }}</span>
      </div>

      <!-- Expanded content -->
      <div
        class="transition-all duration-300 overflow-hidden"
        :style="{ maxHeight: expandedIndex === i ? '200px' : '0', opacity: expandedIndex === i ? 1 : 0 }"
      >
        <div class="px-3 pb-3 space-y-2">
          <div class="font-mono text-[10px] bg-gray-50 rounded p-2 border border-gray-200 text-gray-600 leading-relaxed break-all">
            !`{{ script.cmd }}`
          </div>
          <div class="text-[10px] text-gray-400 uppercase tracking-wider font-semibold">Example output:</div>
          <div class="font-mono text-[10px] text-gray-500 bg-gray-50/50 rounded p-2 whitespace-pre-line">{{ script.sample }}</div>
        </div>
      </div>
    </div>
  </div>
</template>
