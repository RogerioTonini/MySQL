<!DOCTYPE html>
<html>

## Funções, Stored Procedures criadas para ambientes SQL Server e MySQL

### Relação das Funções:

<table border="1" style="width:100%">
  <thead>
    <tr>
        <td align="center">Função</td>
        <td align="center">Objetivo</td>
        <td align="center">Parâmetros</td>
    </tr>
  </thead>
  <body>
    <tr>
        <td align="left"> 
            <a href="https://github.com/RogerioTonini/SQL_Comandos_Diversos/blob/main/MySQL/sys/Functions/fx_DB_Exist.sql">fx_DB_Exist </a> 
        </td>
        <td align="left"> Verificar se o DB existe existe </td>
        <td align="left">
            <p>Utilização: fx_DB_Exist( v_Database )</p> 
            <p>v_Database - Nome do DB</p>
        </td>
    </tr>
    <!-- -->
    <tr>
        <td align="left">
            <a href="https://github.com/RogerioTonini/SQL_Comandos_Diversos/blob/main/MySQL/sys/Functions/fx_IDX_Exist.sql">fx_IDX_Exist </a>
        </td>
        <td align="left"> Contar a quantidade de índices existentes. </td>
        <td align="left">
            <p>Utilização: fx_IDX_Exist( v_Database )</p> 
            <p>v_Database - Nome do DB
            <p>v_Table    - Nome da Tabela
            <p>v_idx_Name - 
        </td>
    </tr>
    <!-- -->
    <tr>
        <td align="left"> 
            <a href="https://github.com/RogerioTonini/SQL_Comandos_Diversos/blob/main/MySQL/sys/Functions/fx_TB_Exist.sql">fx_TB_Exist </a> 
        </td>
        <td align="left"> Verificar se uma tabela existe em um banco de dados. </td>
    </tr>
    <!-- -->
    <tr> 
      <td align="left"> <a href="https://github.com/RogerioTonini/Ling_M"> Linguagem M</a> </td> 
      <td align="center">
          <a href="https://learn.microsoft.com/pt-br/powerquery-m/" target="_blank" rel="noreferrer">
            <img src="https://github.com/RogerioTonini/RogerioTonini/blob/main/images/powerquery.png" width="36" height="36" alt="Power Query"/>
          </a>
      <td align="left"> Funções diversas</td>
    </tr>          
    <!-- -->
    <tr> 
      <td align="left"> <a href="https://github.com/RogerioTonini/SQL_Comandos_Diversos"> MS-SQL</a> </td> 
      <td align="center">
        <a href="https://www.microsoft.com/en-us/sql-server" target="_blank" rel="noreferrer">
          <img src="https://github.com/RogerioTonini/RogerioTonini/blob/main/images/sql-server.png" width="36" height="36" alt="SQL Server"/>
        </a>
      </td>
      <td align="left"> Stored procedures diversas</td>
    </tr>
  </body>
</table>









</html>
-- Author: Rogerio Tonini
-- Data: 31/07/2025
-- Versão: 1.0
-- URL: https://github.com/RogerioTonini/SQL_Comandos_Diversos/tree/main/MySQL
-- Objetivo: Documentar todas as Funções e Stored Procedures









Relação das Stored Procedures (GENÉRICAS):
SP_Create_DB - Cria um banco de Dados.
SP_Create_DB_Tables - Cria as tabelas de um banco de dados.
SP_Create_TB_Calendario - Popula os dados da tabela t_calendario.
SP_Create_TB_Feriados - Popula a tabela t_feriados com todos os feriados mundiais, Nacionais e os prinicipais dos principais munícipios do Brasil.
SP_Drop_Indexes - Apaga todos os índices diferentes de [PRIMARY] das tabelas.
SP_Drop_Table - Apaga uma tabela em específico.
SP_Drop_Table_Indexes - Apaga uma tabela em específico e seu índice [PRIMARY].
SP_Record_LOG - Grava todas as alterações efetuadas na estrutura/gravação de dados nas tabelas.
SP_SQL_Exec - Executa o comando SQL dinâmico em qualquer SP.

Dependências:
SP_SQL_Exec -> fx_SQL_Valid

Relação das Stored Procedures (ESPECÍFICAS):
SP_TB_Indices_Moedas - Relação de todas as tabelas/colunas do DB t_indices_moedas





+--------------+-------------------------------------------------------------+
| fx_DB_Exist  | Verificar se um banco de dados existe.                      |
| fx_IDX_Exist | Contar a quantidade de índices existentes.                  |
| fx_TB_Exist  | Verificar se uma tabela existe em um banco de dados         |
| fx_SQL_Valid | Valida se um comando SQL dinâmico é válido na chamada da SP |
+--------------+-------------------------------------------------------------+