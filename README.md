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
        <!-- -->
        <body>
            <tr>
                <td align="left">
                    <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Functions/fx_DB_Exist.sql">fx_DB_Exist </a> 
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
                <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Functions/fx_IDX_Exist.sql">fx_IDX_Exist </a>
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
                <td>
                    <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Functions/fx_SQL_Valid.sql">fx_SQL_Valid </a>
                </td>
                <td align="left"> Verificar se uma tabela existe em um banco de dados. </td>
            </tr>
            <tr>
                <td>
                    <a href="https://github.com/RogerioTonini/MySQL/blob/main/sys/Functions/fx_TB_Exist.sql">fx_TB_Exist </a>
                </td>
                <td align="left"> Validar o comando SQL dinâmico. </td>
            </tr>
        </body>
    </table>
</html>