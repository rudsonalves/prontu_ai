# Prontuário médico.

- Cadastro do Paciente.
- Cadastro das sessões.
- Resumo das sessões feita por inteligência artificial. 

## Objetivo

Um profissiona de saúde precisa registrar nas sessões o estado do paciente, bem como exames e outros dados clinicos.
Deve ter uma data da sessão, a hora, e a descrição geral.
Após isso, deve ter uma forma de gerar um resumo dessas sessões por ia para facilitar o trabalho na próxima sessão.

## Cadastro de Paciente.

Deve ter, nome, peso, altura, queixa Principal, Histórico de Quadro Atual e Anamnese (que pode ser dirigida ou não).

## Cadastro das sessões

Deve ser uma sessão por paciente e deve ter.<br>
Lista de anexos para registrar exames e laudos.<br>
Um campo de texto para evolução da sessão.<br>
Além da data e hora de início.

## Resumo por IA

Cada sessão poderá ter um botão onde pode ser solicitado um resumo da sessão anterior.

# Arquitetura

Camadas: View, Estado, UseCases, Repository baseadas na featura
Ex: Pasta pra Cadastro de paciente tem subpastas: /View, /Repository e etc.

## Design Patterns

-> Repository Pattern<br>
-> S do solid: Responsabilidade única<br>
-> D do solid: Inversao de dependencia<br>
-> Abstract Factory<br>
-> Singleton<br>

## Regras Gerais

-> Gerenciamento de estados: Usar padrão command<br>
-> Injecao de dependencia: Composition Root + Provider/Singleton

### Nomeclaturas

-> Definicao de variáveis/Métodos com camelCase <br>
-> Variáveis/métodos com nomes claros  <br>
-> Variáveis e métodos nao devme ter números <br>
-> Usar tipagem sempre <br>
-> Pastas nomeadas de acordo com os arquivos que serao colocados  <br>ali dentro. Ex: pasta repository pra uma arquivo repository <br>
