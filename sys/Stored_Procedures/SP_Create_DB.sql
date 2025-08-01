-- Author: Rogerio Tonini
-- Data: 25/07/2025
-- Versão: 1.0
-- URL: HTTP://www.github.com/RogerioTonini
-- Objetivo: Criar um banco de dados se não existir
-- Schema: sys
-- Utilização - Parâmetros:
-- v_Database: Nome do banco de dados onde a tabela está localizada.
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Create_DB`(
	IN v_Database VARCHAR(50)
)
BEGIN
    IF NOT EXISTS ( SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = v_Database ) THEN
        SET @sql = CONCAT('CREATE DATABASE `', v_Database, '`');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SELECT CONCAT('Banco de dados ', v_Database, ' criado com sucesso!') AS status_msg;
    ELSE
        SELECT CONCAT('Banco de dados ', v_Database, ' já existe.') AS status_msg;
    END IF;
END