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

