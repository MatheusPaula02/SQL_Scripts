# 🧾 Consolidacao_ICMS_Entradas_Saidas.sql

### 🧠 Resumo
Script desenvolvido para **consolidar valores de ICMS** de notas fiscais de **entrada e saída**, abrangendo diferentes modelos de documentos (NF, NFC-e, SAT).  
Considera regras parametrizadas conforme o **SPED (EFD_GERARD100 e EFD_GERARD500)**, garantindo consistência fiscal e compatibilidade com relatórios internos.

O processo engloba:
- **BLOCO 1:** Saídas (NF, NFC-e, SAT) com cálculo detalhado do valor do SPED, base ICMS, valor do imposto, isentos e outros.
- **BLOCO 2:** Entradas (NF) com cálculo do valor do SPED e base ICMS considerando parâmetros de geração e CST/ST.

---

### ⚙️ Conceitos SQL Utilizados

| Conceito | Função |
|-----------|--------|
| `INNER JOIN` | Relaciona tabelas de itens com as capas de documentos e CFOP. |
| `LEFT JOIN` | Mantém registros mesmo sem correspondência na tabela de parâmetros. |
| `CASE WHEN` | Aplica regras condicionais para cálculo de valores fiscais. |
| `ISNULL` | Substitui valores nulos por zero ou valor padrão. |
| `CAST(... AS NUMERIC)` | Define precisão de valores monetários. |
| `SUM` | Soma os valores por agrupamento. |
| `GROUP BY` | Consolida os dados por tipo, loja, período, CFOP, CST e tipo de apuração. |
| `UNION ALL` | Combina saídas e entradas em um único conjunto de resultados. |

---

### 🧩 Tabelas Utilizadas

| Tabela | Função |
|--------|--------|
| `ITENS_NF_SAIDA` | Detalhamento dos itens das notas fiscais de saída. |
| `CAPA_NF_SAIDA` | Cabeçalho das notas fiscais de saída. |
| `ITENS_CUPOM` | Itens de cupons NFC-e ou SAT. |
| `CAPA_CUPOM_NFCE` / `CAPA_CUPOM_SAT` | Cabeçalho de cupons NFC-e e SAT. |
| `PARAMETROS_GERADOR_SPED` / `PARAMETRO_PONTO_DE_VENDA` | Parâmetros para geração de valores SPED e CST. |
| `TRIBUTACAO_ALIQUOTAS` | Informações sobre tributação e alíquotas dos produtos. |
| `CFOP` | Tabela de códigos fiscais de operação. |
| `ITENS_NF_ENTRADA` / `CAPA_NF_ENTRADA` | Detalhamento e cabeçalho das notas fiscais de entrada. |

---

### 📌 Pontos de Importância
- Consolida **todas as entradas e saídas** em um único resultado, respeitando regras de cálculo do SPED.  
- Considera **parametrizações específicas de clientes** (zerar valores, manter CST/ST, bonificações).  
- Utiliza **alias com colchetes** `[nome_coluna]` para compatibilidade com sistemas de relatório internos.  
- Limita o período a **últimos 8 meses** para otimização e performance.  
- Boa prática: **verificar resultados com SELECT antes de usar em exportação** para SPED.

---

# 📊 Analise_Inconsistencia_Fiscal.sql

### 🧠 Resumo
Script utilizado para **identificar divergências fiscais em cupons de venda (PDV, NFCE e SAT)**, apontando:
- Quebras de sequência
- Duplicidades
- Cancelamentos incorretos
- Falta de registros entre tabelas

---

### ⚙️ Conceitos SQL Utilizados

| Conceito | Função |
|-----------|--------|
| `CTE (WITH RECURSIVE)` | Gera sequência contínua de cupons para detectar quebras. |
| `UNION ALL` | Consolida resultados de diferentes verificações (NFCE, SAT, PDV). |
| `HAVING COUNT(*) > 1` | Identifica duplicidades de registros. |
| `OPTION (MAXRECURSION 0)` | Evita truncamento de recursões em grandes volumes. |
| `DROP TABLE IF EXISTS` | Garante limpeza das tabelas temporárias antes da execução. |
| `DECLARE / SET` |	Define parâmetros dinâmicos de entrada, como loja, data e flags de execução. |
| `SELECT ... INTO ##TEMP` |  Cria tabelas temporárias globais para armazenar resultados intermediários. |
| `ISNULL()` |	Substitui valores nulos em cálculos, evitando resultados incorretos. |
| `CASE WHEN` |	Aplica lógica condicional para classificar divergências (ex: cancelado incorretamente). |
| `LEFT JOIN` |	Mantém todos os registros principais, permitindo detectar ausências ou quebras. |

---

### 🧩 Tabelas Utilizadas

| Tabela | Função |
|--------|--------|
| `CAPA_CUPOM` | Capa dos cupons fiscais, contendo totais e status de cancelamento. |
| `ITENS_CUPOM` | Itens individuais dos cupons (produtos vendidos). |
| `INFO_CUPOM_NFCE` | Registro das notas fiscais eletrônicas. |
| `INFO_CUPOM_SAT` | Registro dos cupons SAT. |

---

### 📌 Pontos de Importância
- Identifica **falhas críticas** de comunicação entre sistemas PDV e fiscais..  
- ConsUsa **CTEs** e tabelas temporárias para eficiência e clareza na análise.  
- Pode ser incorporado em **rotinas automáticas** de auditoria fiscal e conciliadores de vendas para **agilizar processos de correção interna**.  

