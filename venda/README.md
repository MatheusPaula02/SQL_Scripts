# 📄 Analise_Forma_Pagamento.sql

### 🧠 Resumo
Script desenvolvido para **analisar e detalhar formas de pagamento** associadas às vendas.  
Permite visualizar **cada pagamento separadamente**, mesmo em cupons com múltiplos cartões.  
Utiliza CTEs e funções de janela para eliminar duplicidades e associar corretamente o **nome do cartão** ao valor correspondente.

---

### ⚙️ Conceitos SQL Utilizados

| Conceito | Função |
|-----------|--------|
| `WITH` | Cria CTEs (subconsultas temporárias reutilizáveis). |
| `ROW_NUMBER()` | Gera numeração sequencial para diferenciar registros semelhantes. |
| `CASE WHEN` | Aplica lógica condicional nas colunas calculadas. |
| `ISNULL()` | Substitui valores nulos por um padrão definido. |
| `CAST()` | Converte tipos de dados (ex: `datetime` → `date`). |
| `LEFT JOIN` | Mantém registros da tabela principal mesmo sem correspondência. |
| `GROUP BY` | Agrupa resultados e remove duplicidades. |

---

### 🧩 Tabelas Utilizadas

| Tabela | Função |
|--------|--------|
| `TIPOS_PAGAMENTOS_GERAL` | Base principal dos pagamentos. |
| `NOME_CARTOES` | Nomes e administradoras dos cartões. |
| `CAPA_CUPOM` | Informações gerais do cupom (tipo, status, desconto). |
| `FORMAS_PAGAMENTO` | Cadastro de formas de pagamento (dinheiro, débito, crédito etc.). |
| `VALOR_TROCO` | Registro dos valores de troco por cupom. |
| `CLIENTES` | Dados cadastrais dos clientes. |
| `USUARIOS` | Operadores/caixas responsáveis. |
| `LOJAS` | Informações da loja (código e descrição). |

---

### 📌 Pontos de Importância
- Utiliza **duas CTEs** (`PAGAMENTOS` e `NOMECARTAO`) para controlar duplicidades.  
- O **vínculo entre RN_PGTO e ROW_NUMBER()** garante correspondência correta entre pagamento e cartão.  
- Filtra apenas **cupons válidos e não cancelados**.  
- Utiliza **identificadores delimitados `[coluna]`** para compatibilidade com o sistema de relatórios internos.  

---

