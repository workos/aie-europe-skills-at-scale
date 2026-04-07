interface Env {
  SKILLS: KVNamespace;
  CLEAR_SECRET: string;
  MAX_SKILL_SIZE: string;
}

interface SkillEntry {
  id: string;
  name: string;
  timestamp: string;
  size: number;
}

function generateId(): string {
  return Date.now().toString(36) + Math.random().toString(36).slice(2, 6);
}

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    },
  });
}

function error(message: string, status: number): Response {
  return json({ error: message }, status);
}

async function handleShare(request: Request, env: Env): Promise<Response> {
  // Rate limit: 10s per IP
  const ip = request.headers.get("CF-Connecting-IP") || "unknown";
  const rateKey = `ratelimit:${ip}`;
  const existing = await env.SKILLS.get(rateKey);
  if (existing) {
    return error("Too many requests. Wait a minute and try again.", 429);
  }
  await env.SKILLS.put(rateKey, "1", { expirationTtl: 60 });

  // Parse multipart form
  const formData = await request.formData();
  const name = formData.get("name");
  const skillFile = formData.get("skill");

  if (!name || typeof name !== "string" || !name.trim()) {
    return error("Missing 'name' field", 400);
  }

  let skill: string;
  if (skillFile instanceof File) {
    skill = await skillFile.text();
  } else if (typeof skillFile === "string") {
    skill = skillFile;
  } else {
    return error("Missing 'skill' field", 400);
  }

  const maxSize = parseInt(env.MAX_SKILL_SIZE || "10240");
  if (skill.length > maxSize) {
    return error(`Skill too large (${skill.length} bytes, max ${maxSize})`, 413);
  }

  // Store the skill
  const id = generateId();
  const timestamp = new Date().toISOString();
  const entry: SkillEntry = { id, name: name.trim(), timestamp, size: skill.length };

  await env.SKILLS.put(`skill:${id}`, skill);

  // Update index
  const indexRaw = await env.SKILLS.get("_index");
  const index: SkillEntry[] = indexRaw ? JSON.parse(indexRaw) : [];
  index.push(entry);
  await env.SKILLS.put("_index", JSON.stringify(index));

  return json({ id, name: name.trim(), timestamp, message: "Skill shared!" }, 201);
}

async function handleList(env: Env): Promise<Response> {
  const indexRaw = await env.SKILLS.get("_index");
  const index: SkillEntry[] = indexRaw ? JSON.parse(indexRaw) : [];
  return json({ skills: index, count: index.length });
}

async function handleFetch(id: string, env: Env): Promise<Response> {
  const skill = await env.SKILLS.get(`skill:${id}`);
  if (!skill) {
    return error("Skill not found", 404);
  }

  // Find metadata from index
  const indexRaw = await env.SKILLS.get("_index");
  const index: SkillEntry[] = indexRaw ? JSON.parse(indexRaw) : [];
  const entry = index.find((e) => e.id === id);

  return json({
    id,
    name: entry?.name || "unknown",
    timestamp: entry?.timestamp || "",
    skill,
  });
}

async function handleClear(request: Request, env: Env): Promise<Response> {
  const secret = request.headers.get("X-Clear-Secret");
  if (secret !== env.CLEAR_SECRET) {
    return error("Invalid secret", 403);
  }

  const indexRaw = await env.SKILLS.get("_index");
  const index: SkillEntry[] = indexRaw ? JSON.parse(indexRaw) : [];

  // Delete all skill entries and the index
  await Promise.all(index.map((e) => env.SKILLS.delete(`skill:${e.id}`)));
  await env.SKILLS.delete("_index");

  return json({ message: `Cleared ${index.length} submission(s)` });
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;
    const method = request.method;

    // CORS preflight
    if (method === "OPTIONS") {
      return new Response(null, {
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST, DELETE, OPTIONS",
          "Access-Control-Allow-Headers": "Content-Type, X-Clear-Secret",
        },
      });
    }

    // POST /share
    if (method === "POST" && path === "/share") {
      return handleShare(request, env);
    }

    // GET /skills
    if (method === "GET" && path === "/skills") {
      return handleList(env);
    }

    // GET /skills/:id
    if (method === "GET" && path.startsWith("/skills/")) {
      const id = path.slice("/skills/".length);
      if (!id) return error("Missing skill ID", 400);
      return handleFetch(id, env);
    }

    // DELETE /skills
    if (method === "DELETE" && path === "/skills") {
      return handleClear(request, env);
    }

    return error("Not found", 404);
  },
};
