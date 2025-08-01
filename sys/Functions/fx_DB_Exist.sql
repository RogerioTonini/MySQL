-- Author: Rogerio Tonini
-- Data: 25/07/2025
-- Versão: 1.0
-- URL: HTTP://www.github.com/RogerioTonini
-- Objetivo: Criar um banco de dados se não existir
-- Schema: sys
-- Utilização - Parâmetros:
-- v_Database: Nome do banco de dados onde a tabela está localizada.
CREATE DEFINER=`root`@`localhost` FUNCTION `fx_DB_Exist`(
	db_Name VARCHAR(50)
) RETURNS tinyint(1)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_existe BOOLEAN;
    
    SELECT COUNT(*) > 0
    INTO v_existe
    FROM INFORMATION_SCHEMA.SCHEMATA
    WHERE SCHEMA_NAME = db_Name;

    RETURN v_existe;
END