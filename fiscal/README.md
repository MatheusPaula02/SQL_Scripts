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


