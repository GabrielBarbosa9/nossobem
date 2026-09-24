# Plano — Treinos Esther e Gabe

## Objetivo da primeira versão
Criar um aplicativo privado para Gabriel e Esther planejarem a semana, acompanharem treinos e refeições e receberem sugestões personalizadas de musculação por inteligência artificial.

## Experiência principal
- Acesso restrito às duas contas autorizadas, com e-mail/senha e Google.
- Painel inicial com resumo da semana, próximos treinos, constância e refeições recentes.
- Calendário semanal para criar, editar e consultar atividades.
- Modalidades livres, incluindo musculação, futebol, corrida, bicicleta e outras.
- Check-in por pessoa: confirmado, realizado ou ausência com motivo obrigatório.
- Área de refeições em formato de mural compartilhado, com foto, data, tipo da refeição e comentário.
- Perfis completos com nome, foto, metas, nível, restrições, equipamentos disponíveis e preferências.
- Geração de treino de musculação por IA, revisável antes de salvar no calendário.

## Entregas

### 1. Base visual e navegação
- Substituir a tela vazia por uma interface inspirada no NextFit, adaptada para uso pessoal do casal.
- Criar navegação para Início, Semana, Refeições e Perfil.
- Preparar versões confortáveis para celular e computador.
- Aplicar identidade visual esportiva, clara e objetiva, com estados visuais acessíveis.

### 2. Contas, perfis e segurança
- Ativar o Lovable Cloud para contas, dados e armazenamento de fotos.
- Criar acesso por e-mail/senha e Google.
- Restringir o uso às duas contas autorizadas; novos cadastros não entram automaticamente.
- Criar perfis completos e privados para Gabriel e Esther.
- Proteger todas as informações para que somente os dois usuários possam consultar ou alterar dados.
- Incluir saída segura e recuperação de senha.

### 3. Planejamento semanal e check-ins
- Criar calendário semanal com troca de semana e destaque do dia atual.
- Permitir cadastrar atividade com modalidade, título, horário, duração, observações e participantes.
- Permitir editar e remover atividades.
- Registrar o status de cada pessoa separadamente.
- Exigir motivo quando alguém marcar que não poderá comparecer.
- Mostrar resumo semanal de planejados, realizados e ausências.

### 4. Refeições compartilhadas
- Criar mural cronológico de refeições dos dois usuários.
- Permitir enviar foto, identificar refeição, adicionar comentário e horário.
- Permitir editar e excluir apenas o próprio registro.
- Exibir filtros simples por pessoa, tipo e período.
- Armazenar imagens com acesso privado.

### 5. Geração inteligente de musculação
- Criar formulário com objetivo, nível, duração, músculos desejados, limitações e equipamentos.
- Gerar uma ficha estruturada com exercícios, séries, repetições, descanso e orientações.
- Mostrar o resultado para revisão; nada será salvo automaticamente.
- Permitir ajustar o treino e adicioná-lo a um dia do calendário.
- Usar as informações do perfil para personalizar a sugestão, sem apresentar recomendações médicas.
- Exibir erros claros e preservar as escolhas do usuário caso a geração falhe.

### 6. Validação da primeira versão
- Testar os acessos de Gabriel e Esther e bloquear qualquer outra conta.
- Testar criação, edição, exclusão e troca de semanas nos treinos.
- Testar check-ins independentes e motivo de ausência.
- Testar envio e visualização privada das fotos de refeições.
- Testar geração por IA e inclusão do resultado no calendário.
- Revisar visualmente em celular e computador, incluindo estados vazios, carregamento e erro.

## Estrutura dos dados
- **Perfis:** dados pessoais, objetivos e preferências de treino.
- **Usuários autorizados:** lista fechada das duas contas permitidas.
- **Atividades:** modalidade, agenda e detalhes gerais.
- **Participantes e check-ins:** estado individual e motivo de ausência.
- **Refeições:** autor, foto, tipo, horário e comentário.
- **Treinos gerados:** parâmetros, ficha estruturada e vínculo opcional com uma atividade.

Todas as tabelas terão regras de acesso privadas. Funções administrativas serão verificadas no servidor, nunca apenas na tela.

## Detalhes técnicos
- Aplicação em React, TypeScript e TanStack Start, mantendo a estrutura atual do projeto.
- Lovable Cloud para banco de dados, autenticação e armazenamento.
- Lovable AI para geração de fichas, chamada apenas no servidor e com resposta estruturada.
- Componentes reutilizáveis para calendário, atividade, check-in, refeição e formulário de treino.
- Metadados próprios da aplicação em todas as páginas públicas.

## Fora desta primeira versão
- Chat/mensagens entre usuários.
- Notificações por e-mail ou dentro do app.
- Busca global avançada.
- Integração com relógios, academias ou aplicativos externos.
- Planos alimentares ou aconselhamento médico automatizado.

Esses itens poderão ser adicionados em marcos posteriores, após a rotina principal estar validada.
