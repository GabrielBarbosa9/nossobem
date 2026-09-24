import { createOpenAI } from "@ai-sdk/openai";
import { createServerFn } from "@tanstack/react-start";
import { streamText, Output } from "ai";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";

const inputSchema = z.object({ goal: z.string(), fitnessLevel: z.string(), durationMinutes: z.number(), muscleGroups: z.array(z.string()), equipment: z.array(z.string()), limitations: z.string() });
const workoutSchema = z.object({ title: z.string(), guidance: z.string(), exercises: z.array(z.object({ name: z.string(), sets: z.string(), reps: z.string(), rest: z.string(), note: z.string() })) });

export const generateWorkout = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((input: unknown) => inputSchema.parse(input))
  .handler(async ({ data, context }) => {
    const email = typeof context.claims.email === "string" ? context.claims.email.toLowerCase() : "";
    if (!["gabrieljbarbosa.contato@gmail.com", "vidasil73@gmail.com"].includes(email)) throw new Error("Esta conta não está autorizada.");
    const key = process.env["LOVABLE_API_KEY"];
    if (!key) throw new Error("A geração inteligente não está configurada.");
    const lovable = createOpenAI({ baseURL: "https://ai.gateway.lovable.dev/v1", apiKey: key, headers: { "Lovable-API-Key": key, "X-Lovable-AIG-SDK": "vercel-ai-sdk" } });
    const result = streamText({
      model: lovable.responses("openai/gpt-6-astra"), output: Output.object({ schema: workoutSchema }),
      prompt: `Crie uma ficha segura de musculação em português do Brasil. Objetivo: ${data.goal}. Nível: ${data.fitnessLevel}. Duração: ${data.durationMinutes} minutos. Grupos: ${data.muscleGroups.join(", ")}. Equipamentos: ${data.equipment.join(", ") || "peso corporal"}. Limitações: ${data.limitations || "nenhuma informada"}. Evite diagnóstico ou aconselhamento médico. Produza orientações curtas e exercícios compatíveis com o tempo.`,
      providerOptions: { openai: { forceReasoning: true, reasoningEffort: "low", reasoningSummary: "auto", store: false, include: ["reasoning.encrypted_content"] } },
    });
    return await result.output;
  });