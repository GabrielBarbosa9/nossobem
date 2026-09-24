import { createFileRoute, Outlet, redirect } from "@tanstack/react-router";
import { supabase } from "@/integrations/supabase/client";

export const Route = createFileRoute("/_authenticated")({
  ssr: false,
  beforeLoad: async () => {
    const { data, error } = await supabase.auth.getUser();
    if (error || !data.user) throw redirect({ to: "/auth", search: {} });
    const { data: allowed } = await supabase.rpc("is_authorized_user");
    if (!allowed) throw redirect({ to: "/auth", search: { denied: "1" } });
    return { user: data.user };
  },
  component: () => <Outlet />,
});