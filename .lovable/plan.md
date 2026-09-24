# Plano: IMC, hidratação e data do treino gerado

## Objetivo
Adicionar acompanhamento corporal e de hidratação ao app, além de permitir que o treino gerado seja agendado na data e no horário escolhidos.

## Entregas

### 1. Peso, altura e IMC no perfil
- Adicionar ao perfil os campos **peso atual (kg)** e **altura (cm)**.
- Validar valores plausíveis e permitir casas decimais no peso.
- Calcular automaticamente o IMC com a fórmula `peso / altura²`.
- Exibir o valor e sua faixa de referência no perfil, deixando claro que é apenas um indicador geral e não uma avaliação médica.
- Cada pessoa poderá alterar somente as próprias medidas; ambos continuam podendo visualizar os perfis compartilhados.

### 2. Registro de água
- Criar registros individuais de ingestão com **quantidade livre em ml**, data e horário.
- Incluir no painel um bloco de hidratação com total consumido no dia, campo para informar a quantidade e ação rápida para registrar.
- Mostrar os lançamentos do dia e permitir que cada pessoa exclua apenas os próprios registros.
- Manter os dados privados para Gabriel e Esther, seguindo as mesmas regras de acesso do restante do app.

### 3. Agendamento do treino gerado
- Adicionar um seletor obrigatório de **data e horário** ao fluxo de geração de musculação.
- Preservar a escolha enquanto a ficha é gerada ou ajustada.
- Substituir “Adicionar amanhã” por uma ação de agendamento que salva o treino exatamente no momento escolhido.
- Exibir o treino imediatamente na semana correspondente do calendário.

### 4. Validação
- Testar atualização de peso e altura, cálculo do IMC e valores incompletos.
- Testar criação, soma diária e exclusão de registros de água.
- Testar geração e salvamento de treino em diferentes datas e horários.
- Conferir as telas em celular e computador e validar as regras de privacidade.

## Detalhes técnicos
- Ampliar `profiles` com peso e altura opcionais.
- Criar `water_intakes` com usuário, quantidade em ml e momento do consumo, incluindo permissões explícitas e políticas por usuário/casal.
- Calcular o IMC na interface a partir das medidas salvas, sem persistir um valor duplicado.
- Usar o horário local escolhido e convertê-lo para o formato armazenado pelo calendário.
