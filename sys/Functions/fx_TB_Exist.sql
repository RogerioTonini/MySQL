-- Author: Rogerio Tonini
-- Data: 25/07/2025
-- Versão: 1.0
-- URL: HTTP://www.github.com/RogerioTonini
-- Objetivo: Criar um banco de dados se não existir
-- Schema: sys
-- Utilização - Parâmetros:
-- v_Database: Nome do banco de dados onde a tabela está localizada.
-- v_Table: Nome da tabela que será verificada se existe.
CREATE DEFINER=`root`@`localhost` FUNCTION `sys`.`fx_TB_Exist`(
	v_Database  VARCHAR(50),
    v_Table VARCHAR(50)
) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE v_existe BOOLEAN;

    SELECT COUNT(*) > 0
    INTO v_existe
	FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_SCHEMA = v_Database AND TABLE_NAME = v_Table;

    RETURN v_existe;
END