import { createFileRoute, Link } from "@tanstack/react-router";
import { ArrowRight, CalendarDays, Dumbbell, Salad } from "lucide-react";
import { Button } from "@/components/ui/button";

// No head() here: the home route inherits title/description/og/twitter from
// __root.tsx, and ships no og:image so serve-time hosting can inject the
// project's social preview (explicit og:image or latest screenshot).
export const Route = createFileRoute("/")({
  head: () => ({ meta: [{ title: "Esther & Gabriel | Treinos e refeições" }, { name: "description", content: "Planejamento privado de treinos, check-ins e refeições para Esther e Gabriel." }, { property: "og:title", content: "Esther & Gabriel | Treinos e refeições" }, { property: "og:description", content: "Planejamento privado de treinos, check-ins e refeições." }, { property: "og:type", content: "website" }, { name: "twitter:card", content: "summary_large_image" }] }),
  component: Index,
});

// IMPORTANT: Replace this placeholder. See ./README.md for routing conventions.
function Index() {
  return <main className="min-h-screen bg-background"><nav className="mx-auto flex max-w-6xl items-center justify-between px-5 py-6"><div className="flex items-center gap-3 font-bold"><span className="grid size-10 place-items-center rounded-md bg-primary text-primary-foreground"><Dumbbell /></span>ESTHER & GABRIEL</div><Button asChild><Link to="/auth" search={{ denied: undefined }}>Entrar <ArrowRight /></Link></Button></nav><section className="mx-auto grid max-w-6xl gap-12 px-5 pb-20 pt-16 lg:grid-cols-[1.15fr_.85fr] lg:pt-28"><div><p className="text-sm font-semibold uppercase text-primary">Projeto grande dia</p><h1 className="mt-4 max-w-3xl text-5xl font-bold leading-[1.04] md:text-7xl">Mais fortes, juntos, até o casamento.</h1><p className="mt-7 max-w-xl text-lg leading-8 text-muted-foreground">Um espaço privado para transformar intenção em constância: planejar a semana, cumprir os treinos e compartilhar cada refeição.</p><Button asChild size="lg" className="mt-9"><Link to="/auth" search={{ denied: undefined }}>Acessar nosso painel <ArrowRight /></Link></Button></div><div className="grid content-end gap-3"><Feature icon={<CalendarDays />} title="Semana organizada" text="Treinos, horários e presença dos dois em uma visão."/><Feature icon={<Dumbbell />} title="Treinos inteligentes" text="Fichas personalizadas para objetivos e equipamentos disponíveis."/><Feature icon={<Salad />} title="Constância à mesa" text="Registros visuais para acompanhar refeições lado a lado."/></div></section></main>;
}
function Feature({ icon, title, text }: { icon: React.ReactNode; title: string; text: string }) { return <div className="flex gap-4 border-t py-5"><span className="text-primary">{icon}</span><div><h2 className="font-semibold">{title}</h2><p className="mt-1 text-sm text-muted-foreground">{text}</p></div></div>; }
