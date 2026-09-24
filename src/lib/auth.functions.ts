import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";

const allowedEmailSchema = z.object({
  email: z.string().trim().toLowerCase().email(),
});

export const checkAuthorizedEmail = createServerFn({ method: "POST" })
  .inputValidator((data) => allowedEmailSchema.parse(data))
  .handler(async ({ data }) => {
    const { supabaseAdmin } = await import("@/integrations/supabase/client.server");
    const { data: authorizedUser, error } = await supabaseAdmin
      .from("authorized_users")
      .select("email")
      .eq("email", data.email)
      .maybeSingle();

    if (error) throw new Error("Não foi possível verificar este e-mail agora.");
    return { authorized: Boolean(authorizedUser) };
  });