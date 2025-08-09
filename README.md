<!DOCTYPE html>
<html>

## Funções, Stored Procedures criadas para MySQL
<table border="1" style="width:100%">
    <thead>
        <tr>
            <td align="center">Função/Stored Procedure</td>
            <td align="center">Objetivo</td>
            <td align="center">Parâmetros</td>
        </tr>
    </thead>
    <body>
        <tr>
            <td align="left">
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Stored_Procedures/SP_Create_DB.sql">SP_Create_DB </a> 
            </td>
            <td align="left"> Cria um banco de Dados </td>
            <td align="left">
                <p>v_Database - Nome do DB</p>
            </td>
        </tr>
        <!-- -->
        <tr>
            <td align="left">
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Stored_Procedures/SP_Create_DB_Tables.sql">SP_Create_DB_Tables </a> 
            </td>
            <td align="left"> Cria as tabelas de um banco de dados </td>
            <td align="left">
                <p>v_Database - Nome do DB</p>
            </td>
        </tr>
        <!-- -->
        <tr>
            <td align="left">
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Stored_Procedures/SP_Create_TB_Calendario.sql">SP_Create_TB_Calendario </a> 
            </td>
            <td align="left"> Popula os dados da tabela t_calendario </td>
            <td align="left">
                <p>v_Database - Nome do DB</p>
            </td>
        </tr>
        <!-- -->
        <tr>
            <td align="left">
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Stored_Procedures/SP_Create_TB_Feriados.sql">SP_Create_TB_Feriados </a> 
            </td>
            <td align="left"> Popula a tabela t_feriados com todos os feriados mundiais, Nacionais e os prinicipais dos principais munícipios do Brasil </td>
            <td align="left">
                <p>v_Database - Nome do DB</p>
            </td>
        </tr>
        <!-- -->
        <tr>
            <td align="left">
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Stored_Procedures/SP_Drop_Indexes.sql">SP_Drop_Indexes </a> 
            </td>
            <td align="left"> Apaga todos os índices diferentes de [PRIMARY] das tabelas </td>
            <td align="left">
                <p>v_Database - Nome do DB</p>
            </td>
        </tr>
        <!-- -->
        <tr>
            <td align="left">
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Stored_Procedures/SP_Drop_Table.sql">SP_Drop_Table </a> 
            </td>
            <td align="left"> Apaga uma tabela em específico </td>
            <td align="left">
                <p>v_Database - Nome do DB</p>
            </td>
        </tr>
        <!-- -->
        <tr>
            <td align="left">
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Stored_Procedures/SP_Drop_Table_Indexes.sql">SP_Drop_Table_Indexes </a> 
            </td>
            <td align="left"> Apaga uma tabela em específico e seu índice [PRIMARY] </td>
            <td align="left">
                <p>v_Database - Nome do DB</p>
            </td>
        </tr>
        <!-- -->
        <tr>
            <td align="left">
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Stored_Procedures/SP_Record_LOG.sql">SP_Record_LOG </a> 
            </td>
            <td align="left"> Grava todas as alterações efetuadas na estrutura/gravação de dados nas tabelas </td>
            <td align="left">
                <p>v_Database - Nome do DB</p>
            </td>
        </tr>
        <!-- -->
        <tr>
            <td align="left">
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Stored_Procedures/SP_SQL_Exec.sql">SP_SQL_Exec </a> 
            </td>
            <td align="left"> Executa o comando SQL dinâmico em qualquer SP </td>
            <td align="left">
                <p>v_Database - Nome do DB</p>
            </td>
        </tr>
        <!-- -->
        <tr>
            <td align="left">
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Functions/fx_DB_Exist.sql">fx_DB_Exist </a> 
            </td>
            <td align="left"> Verificar se o DB existe existe </td>
            <td align="left">
                <p>v_Database - Nome do DB</p>
            </td>
        </tr>
        <!-- -->
        <tr>
        <td align="left">
            <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Functions/fx_IDX_Exist.sql">fx_IDX_Exist </a>
        </td>
            <td align="left"> Contar a quantidade de índices existentes. </td>
            <td align="left">
                <p>v_Database - Nome do DB</p>
                <p>v_Table    - Nome da Tabela</p>
                <p>v_idx_Name - Nome do arquivo do índice</p>
            </td>
        </tr>
        <!-- -->
        <tr>
            <td>
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Functions/fx_SQL_Valid.sql">fx_SQL_Valid </a>
            </td>
            <td align="left"> Validar o comando SQL dinâmico. </td>
            <td align="left">
                <p>v_command - Comando SQL</p>
            </td>
        </tr>
        <tr>
            <td>
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Functions/fx_TB_Exist.sql">fx_TB_Exist </a>
            </td>
            <td align="left">Verificar se uma tabela existe em um banco de dados. </td>
            <td align="left">
                <p>v_Database - Nome do DB</p>
                <p>v_Table    - Nome da Tabela</p>
            </td>
        </tr>
    </body>
</table>
</html>