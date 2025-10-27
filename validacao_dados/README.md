# 🧹 Correcao_Duplicidade.sql

### 🧠 Resumo
Script criado para **identificar e remover registros duplicados** em tabelas de cupons fiscais (NFCE).  
Utiliza `ROW_NUMBER()` para numerar registros repetidos e permite **visualizar antes de excluir**, garantindo segurança na correção.  
Ideal para **tratamento de duplicidades em bases sem chave única**.

---

### ⚙️ Conceitos SQL Utilizados

| Conceito | Função |
|-----------|--------|
| `DECLARE / SET` | Define variáveis de controle (datas e loja). |
| `DROP TABLE IF EXISTS` | Remove tabelas temporárias antigas. |
| `WITH (ROW_NUMBER())` | Numera registros dentro de um grupo, identificando duplicados. |
| `HAVING COUNT(*) > 1` | Filtra apenas registros repetidos. |
| `CASE WHEN` | Define condições para marcar divergências de sequência. |
| `LEFT JOIN` / `INNER JOIN` | Combina dados das tabelas principais e auxiliares. |

---

### 🧩 Tabelas Utilizadas

| Tabela | Função |
|--------|--------|
| `INFO_CUPOM` | Tabela principal com os dados dos cupons fiscais. |
| `CAPA_CUPOM` | Cabeçalho dos cupons (COO, sequência, status, data). |
| `XML_CUPOM` | Dados XML associados aos cupons (espelho eletrônico). |
| `##DUPLICADOS` | Temporária com os registros duplicados encontrados. |
| `##CODNFCE_DUPLIC` | Intermediária com códigos e divergências identificadas á partir do sequencial. |
| `##CODNFCE_DUPLIC_RN` | Temporária final com numeração (`ROW_NUMBER`) para exclusão segura. |

---

### 📌 Pontos de Importância
- Permite **verificar duplicidades antes de deletar** (uso do `SELECT` no lugar do `DELETE`).  
- O filtro `RN > 1` **mantém apenas o primeiro registro** e marca os demais para exclusão.  
- Desenvolvido para **bases SQL Server**, podendo ser adaptado facilmente para outros ambientes.  
- Indicado para **limpeza controlada** de dados fiscais duplicados em sistemas de emissão de NFCE.

---

# 🧾 Ajuste_Campos_Nulos.sql

### 🧠 Resumo
Script desenvolvido para **corrigir registros de cupons fiscais (ITENS_CUPONS)** que estão com o campo **CST_PISCOFINS nulo**, utilizando como referência a tabela **IMPOSTOS_FEDERAIS_PRODUTOS**.  
O processo é dividido em duas etapas: **validação dos registros nulos** e **atualização dos campos faltantes**.

---

### ⚙️ Conceitos SQL Utilizados

| Conceito | Função |
|-----------|--------|
| `INNER JOIN` | Relaciona produtos do cupom com a tabela de referência fiscal. |
| `WHERE IS NULL` | Filtra apenas os registros sem código de CST. |
| `UPDATE ... FROM` | Atualiza registros na tabela principal usando valores de outra tabela. |
| `AS` | Define apelidos para tabelas ou colunas, facilitando leitura e referência. |
| `BEGIN TRANSACTION` | Inicia uma transação para aplicar alterações de forma segura (teste). |
| `COMMIT` | Confirma todas as alterações feitas dentro da transação. |
| `ROLLBACK` | Cancela todas as alterações realizadas dentro da transação caso ocorra algum erro. |

---

### 🧩 Tabelas Utilizadas

| Tabela | Função |
|--------|--------|
| `ITENS_CUPONS` | Itens de cupons fiscais emitidos (detalhamento por produto). |
| `IMPOSTOS_FEDERAIS_PRODUTOS` | Base de referência com CSTs e alíquotas de saída dos produtos. |

---

### 📌 Pontos de Importância
- Primeiro, **valida** quais registros estão sem CST com um `SELECT`.  
- Depois, **atualiza** os campos nulos com os valores corretos da tabela de referência.  
- Evita inconsistências em **relatórios fiscais e SPED**.  
- Boa prática: **usar transação para testes** antes de aplicar alterações definitivas:  

```sql
BEGIN TRANSACTION;
-- UPDATE ...
COMMIT;   -- ou ROLLBACK caso necessário


