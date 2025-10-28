# 🗄️ Comandos de Banco de Dados
*Essas anotações foram feita á partir do meu estudo em SQL, para começar a realizar a criação de scripts personalizados ou para correções internas em clientes.*

## 🔹 Criação e Exclusão de Bancos

### Criar Banco de Dados
```sql
CREATE DATABASE [Nome_do_Banco]
```
Cria um novo banco de dados.

### Criar Banco de Dados com Especificações
```sql
CREATE DATABASE [Nome_do_Banco]
ON (
  NAME = [Nome_do_Banco],
  FILENAME = 'C:\temp\data\Sucos_Financeiro.mdf',
  SIZE = 10,
  MAXSIZE = 50,
  FILEGROWTH = 5
)
LOG ON (
  NAME = [Nome_do_Log],
  FILENAME = 'C:\temp\data\Sucos_Financeiro.ldf',
  SIZE = 10,
  MAXSIZE = 50,
  FILEGROWTH = 5
)
```
💡 *Também é possível criar bancos de dados utilizando o assistente gráfico do SQL Server.*

### Excluir Banco de Dados
```sql
DROP DATABASE [Nome_do_Banco]
```

---

## 🔹 Tabelas

### Criar Tabela
```sql
CREATE TABLE [Nome_Tabela] (
  [ID] INT PRIMARY KEY IDENTITY(1,1),
  [Nome] VARCHAR(100),
  [Cidade] VARCHAR(150),
  [UF] CHAR(2) NOT NULL,
  [Data_Nascimento] DATE,
  [Salario] MONEY,
  [Ativo] BIT
)
```
- `PRIMARY KEY`: define chave primária.  
- `IDENTITY`: cria auto incremento.  
- `NOT NULL`: valor obrigatório.  
- `BIT`: 1 = TRUE / 0 = FALSE  

### Excluir Tabela
```sql
DROP TABLE [Nome_Tabela]
```

---

## 🔹 Inserção, Atualização e Exclusão

### Inserir Dados
```sql
INSERT INTO [Nome_Tabela] ([Col1], [Col2], [Col3])
VALUES ('Valor1', 'Valor2', 123.45)
```

### Atualizar Dados
```sql
UPDATE [Nome_Tabela]
SET [Col1] = 'NovoValor'
WHERE [Col2] = 'Filtro'
```

### Deletar Dados
```sql
DELETE FROM [Nome_Tabela]
WHERE [Col1] = 'Valor'
```

---

## 🔹 Alterações de Estrutura

### Adicionar Chave Primária
```sql
ALTER TABLE [Nome_Tabela]
ADD CONSTRAINT PK_Nome PRIMARY KEY CLUSTERED ([Coluna])
```

### Adicionar Chave Estrangeira
```sql
ALTER TABLE [Nome_Tabela]
ADD CONSTRAINT FK_Tabela
FOREIGN KEY ([Coluna]) REFERENCES Outra_Tabela([Coluna])
```

### Alterar Coluna para NOT NULL
```sql
ALTER TABLE [Nome_Tabela]
ALTER COLUMN [Coluna] VARCHAR(50) NOT NULL
```

---

## 🔹 Consultas (SELECT)

### Selecionar Todos os Registros
```sql
SELECT * FROM [Nome_Tabela]
```

### Selecionar Colunas Específicas
```sql
SELECT [Col1], [Col2] FROM [Nome_Tabela]
```

### Selecionar com Filtros
```sql
SELECT * FROM [Nome_Tabela]
WHERE [Coluna] = 'Valor'
```

### Operadores de Comparação
`<`, `>`, `<>`, `=`, `<=`, `>=`

### Filtros com Datas
```sql
SELECT * FROM [Nome_Tabela]
WHERE YEAR([Data]) = 2024
```

---

## 🔹 Filtros e Operadores Lógicos

```sql
SELECT * FROM [Tabela]
WHERE [Coluna] = 'X' OR [Coluna] = 'Y'
```

```sql
SELECT * FROM [Tabela]
WHERE [Coluna] IN ('A', 'B', 'C')
```

```sql
SELECT * FROM [Tabela]
WHERE [Coluna] LIKE '%Texto%'
```

---

## 🔹 Agrupamento e Agregações

```sql
SELECT [Categoria], SUM([Valor]) AS Total
FROM [Vendas]
GROUP BY [Categoria]
```

```sql
SELECT [Categoria], SUM([Valor]) AS Total
FROM [Vendas]
GROUP BY [Categoria]
HAVING SUM([Valor]) > 1000
```

---

## 🔹 Condições (CASE WHEN)

```sql
SELECT
  [Produto],
  CASE
    WHEN [Preco] > 100 THEN 'Caro'
    WHEN [Preco] BETWEEN 50 AND 100 THEN 'Médio'
    ELSE 'Barato'
  END AS Classificacao
FROM [Produtos]
```

---

## 🔹 JOINs

| Tipo | Descrição |
|------|------------|
| `INNER JOIN` | Retorna registros com correspondência em ambas as tabelas |
| `LEFT JOIN` | Retorna todos os registros da tabela da esquerda |
| `RIGHT JOIN` | Retorna todos os registros da tabela da direita |
| `FULL JOIN` | Retorna todos os registros de ambas |
| `CROSS JOIN` | Combina todos os registros entre as tabelas |

Exemplo:
```sql
SELECT A.Nome, B.Cidade
FROM Clientes A
INNER JOIN Enderecos B ON A.ID = B.IDCliente
```

---

## 🔹 UNION e Subconsultas

### UNION
```sql
SELECT Nome FROM Tabela1
UNION
SELECT Nome FROM Tabela2
```

### Subconsulta
```sql
SELECT Nome
FROM Clientes
WHERE ID IN (
  SELECT IDCliente FROM Pedidos WHERE Valor > 500
)
```

---

## 🔹 Funções de String

| Função | Descrição | Exemplo |
|--------|------------|---------|
| `LTRIM` | Remove espaços à esquerda | `SELECT LTRIM('   OLA')` |
| `RTRIM` | Remove espaços à direita | `SELECT RTRIM('OLA   ')` |
| `LEFT` | Pega caracteres à esquerda | `SELECT LEFT('RUA AUGUSTA', 3)` |
| `RIGHT` | Pega caracteres à direita | `SELECT RIGHT('RUA AUGUSTA', 7)` |
| `CONCAT` | Concatena valores | `SELECT CONCAT('Olá ', 'Mundo')` |
| `SUBSTRING` | Retorna parte da string | `SELECT SUBSTRING('RUA AUGUSTA', 2, 4)` |
| `LEN` | Conta caracteres | `SELECT LEN('RUA AUGUSTA')` |
| `UPPER` | Converte em maiúsculas | `SELECT UPPER('teste')` |
| `LOWER` | Converte em minúsculas | `SELECT LOWER('TESTE')` |
| `REPLACE` | Substitui strings | `SELECT REPLACE('R. AUGUSTA', 'R.', 'RUA')` |

---

## 🔹 Funções de Data

| Função | Descrição |
|--------|------------|
| `GETDATE()` | Data e hora atuais |
| `SYSDATETIME()` | Data/hora com precisão maior |
| `DATEPART()` | Extrai parte da data |
| `DATENAME()` | Retorna nome da parte da data |
| `DAY()` / `MONTH()` / `YEAR()` | Retorna dia, mês ou ano |
| `DATEDIFF()` | Calcula diferença entre datas |
| `DATEFROMPARTS()` | Cria data a partir de partes |

---

## 🔹 Funções Matemáticas

| Função | Descrição | Exemplo |
|--------|------------|---------|
| `CEILING` | Arredonda para cima | `SELECT CEILING(12.3)` → 13 |
| `FLOOR` | Arredonda para baixo | `SELECT FLOOR(12.9)` → 12 |
| `RAND` | Número aleatório entre 0 e 1 | `SELECT RAND()` |
| `ROUND` | Arredonda com precisão | `SELECT ROUND(12.345, 2)` → 12.35 |

---

## 🔹 Conversão de Dados

```sql
SELECT CONVERT(DECIMAL(10,5), 193.57)
SELECT CAST('2025-10-27' AS DATE)
```

💡 *`CONVERT` permite aplicar estilos de formatação (101, 110, 106 etc.).*

Exemplo prático:
```sql
SELECT CONCAT(
  'O cliente ', TC.NOME, ' faturou ',
  CONVERT(VARCHAR, CONVERT(DECIMAL(15,2), SUM(INF.QUANTIDADE * INF.[PREÇO]))),
  ' no ano ', CONVERT(VARCHAR, YEAR(NF.DATA))
) AS SENTENCA
FROM [NOTAS FISCAIS] NF
INNER JOIN [ITENS NOTAS FISCAIS] INF ON NF.NUMERO = INF.NUMERO
INNER JOIN [CLIENTES] TC ON NF.CPF = TC.CPF
WHERE YEAR(DATA) = 2016
GROUP BY TC.NOME, YEAR(DATA)
```
---

## 🔹 Funções Avançadas

### 🧩 ROW_NUMBER e RANK

Essas funções são usadas para **numerar ou classificar registros** dentro de um conjunto de resultados.  
Elas são especialmente úteis em relatórios, comparações e quando combinadas com `PARTITION BY`.

#### ROW_NUMBER()
Retorna um número sequencial (1, 2, 3...) para cada linha dentro de um conjunto de resultados.

```sql
SELECT 
  [Nome_Cliente],
  [Cidade],
  ROW_NUMBER() OVER (ORDER BY [Nome_Cliente]) AS Numero_Linha
FROM [Clientes]
```
💡 *Numera as linhas de acordo com a ordem do nome do cliente.*

#### RANK()
Atribui uma classificação, mas repete o número em caso de empate e pula o próximo valor.

```sql
SELECT 
  [Produto],
  [Valor],
  RANK() OVER (ORDER BY [Valor] DESC) AS Posicao
FROM [Vendas]
```
💡 *Se dois produtos tiverem o mesmo valor, ambos terão o mesmo rank, e o próximo pula o número.*

### 🧮 PARTITION BY
Usado dentro de funções de janela (OVER) para redefinir a contagem ou classificação a cada agrupamento.

```sql
SELECT 
  [Categoria],
  [Produto],
  [Valor],
  ROW_NUMBER() OVER (PARTITION BY [Categoria] ORDER BY [Valor] DESC) AS Posicao
FROM [Vendas]
```
💡 *A numeração reinicia para cada categoria. Não se limita apenas á `ROW_NUMBER`, pode se usar `RANK` e até mesmo `SUM`.*

---

## 🔹 ISNULL e COALESCE 
Essas funções tratam valores nulos em consultas.

#### ISNULL()
Substitui valores NULL por um valor padrão.

```sql
SELECT Nome, ISNULL(Telefone, 'Não informado') AS Telefone
FROM [Clientes]
```

#### COALESCE()
Retorna o primeiro valor não nulo em uma lista.

```sql
SELECT Nome, COALESCE(Telefone, Celular, 'Sem contato') AS Contato
FROM [Clientes]
```
---

## 🔹 Transações e Controle de Dados
As transações permitem executar múltiplos comandos como uma única operação.
Se algo falhar, é possível desfazer tudo.

#### BEGIN TRANSACTION / COMMIT / ROLLBACK

```sql
BEGIN TRANSACTION

UPDATE [Contas]
SET Saldo = Saldo - 500
WHERE ClienteID = 1

UPDATE [Contas]
SET Saldo = Saldo + 500
WHERE ClienteID = 2

-- Se tudo estiver correto:
COMMIT

-- Se algo der errado:
-- ROLLBACK
```
💡 *`COMMIT` confirma as alterações, enquanto `ROLLBACK` desfaz tudo.*
