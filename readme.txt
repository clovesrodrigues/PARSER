Parser é um repositório dedicado ao estudo, implementação e experimentação de técnicas de parsing aplicadas ao processamento de linguagens formais e naturais. O projeto explora desde abordagens clássicas — como parsers LL, LR e recursivos descendentes — até métodos mais avançados utilizados em compiladores, interpretadores e análise semântica.

O objetivo é servir como um laboratório prático para compreender como estruturas sintáticas são analisadas, transformadas e interpretadas, incluindo a construção de árvores sintáticas (AST), tokenização, análise léxica e estratégias de tratamento de erros.

O repositório pode incluir exemplos em diferentes linguagens, testes comparativos entre técnicas, e aplicações reais como interpretação de expressões, validação de gramáticas e integração com ferramentas de processamento de linguagem natural.

---

TECNICAS AVANÇADAS DE PARSING USANDO UDPipe + ONNX PARA ENCONTRAR CONTEXTOS DE ÁRVORES DE SINTAGMAS (C++ + wxWidgets)

1) Arquitetura híbrida recomendada
- Camada linguística (UDPipe): tokenização, lematização, PoS tags e dependências sintáticas em formato CoNLL-U.
- Camada neural (ONNX Runtime): classificação de contexto sintagmático (ex.: NP, VP, PP em janelas locais).
- Camada de orquestração (C++): fusão de features simbólicas + embeddings neurais.
- Camada visual (wxWidgets): inspeção interativa de árvore, dependências e score por nó.

2) Estratégia de parsing em duas passagens
- Passagem 1 (simbólica): use UDPipe para gerar estrutura base (head/deprel/upos/feats).
- Passagem 2 (neural): para cada candidato de sintagma, extraia contexto linear e de dependência e envie ao modelo ONNX.
- Reescore estrutural: combine score do classificador com heurísticas linguísticas (concordância morfológica, distância de head, fronteiras de pontuação).

3) Features avançadas para contexto de sintagmas
- Janela lexical: tokens t-3..t+3 com lemmas + subwords.
- Caminho na árvore de dependência: sequência de relações entre nó atual e ancestral de referência.
- Padrões morfossintáticos: (DET ADJ NOUN), (AUX VERB), etc.
- Features de fronteira: início/fim de oração, vírgula, conjunções coordenativas/subordinativas.
- Profundidade e fator de ramificação: úteis para detectar sintagmas aninhados.

4) Técnicas de inferência com ONNX Runtime em C++
- Pré-alocar tensores para batch dinâmico e reduzir alocação por sentença.
- Usar INT8/FP16 (quando disponível) para reduzir latência.
- Pipeline assíncrono: thread de inferência separada do thread de UI (wxWidgets).
- Cache por hash de sentença para cenários de edição incremental.

5) Encontrando “contextos de árvore de sintagmas” na prática
- Defina unidade de contexto: nó-alvo + irmãos + ancestral até profundidade N.
- Gere “subárvores candidatas” por regras (ex.: head nominal com dependentes amod/det/nmod).
- Classifique cada subárvore com ONNX e retenha top-k por confiança.
- Faça pós-processamento com constraints linguísticas para remover conflitos de sobreposição.

6) Integração com wxWidgets
- Modelo de dados: mantenha estrutura imutável da análise e snapshots para undo/redo.
- UI:
  - wxTreeCtrl para árvore sintática/dependência.
  - wxStyledTextCtrl para texto com spans coloridos por classe sintagmática.
  - Painel lateral com probabilidades, features e explicações.
- Eventos:
  - OnTextChanged -> debounce -> UDPipe -> ONNX -> atualizar árvore.
  - OnNodeSelected -> destacar caminho de dependência e contexto usado no classificador.

7) Métricas e validação
- Span-F1 para fronteiras de sintagma.
- UAS/LAS (dependências) para monitorar qualidade da base UDPipe.
- Latência P50/P95 por sentença na aplicação desktop.
- Avaliação por domínio (jurídico, técnico, conversacional) para robustez.

8) Boas práticas de engenharia
- Separar módulos: nlp_udpipe/, nlp_onnx/, parser_fusion/, ui_wx/.
- API estável de features (versionar schema de entrada ONNX).
- Log estruturado com amostras de erro para análise offline.
- Testes: unitários (extração de features), integração (pipeline completo), regressão (corpus fixo).

9) Exemplo de fluxo de execução
- Usuário digita texto na interface wxWidgets.
- Sistema gera análise UDPipe e lista candidatos de sintagma.
- ONNX classifica contexto de cada candidato.
- Módulo de fusão aplica regras e consolida árvore final.
- UI renderiza árvore com confiança e explicabilidade por nó.

10) Resultado esperado
Essa abordagem híbrida melhora a detecção de contextos sintagmáticos complexos, especialmente em sentenças longas, coordenações e estruturas ambíguas, mantendo desempenho adequado para uso interativo em aplicações C++ com wxWidgets.
