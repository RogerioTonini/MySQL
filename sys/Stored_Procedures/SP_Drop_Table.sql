-- Author: Rogerio Tonini
-- Data: 25/07/2025
-- Versão: 1.0
-- URL: HTTP://www.github.com/RogerioTonini
-- Objetivo: Apagar uma tabela específica de um banco de dados, se ela existir.
-- Schema: sys
-- Utilização - Parâmetros:
-- v_Database: Nome do banco de dados onde a tabela está localizada.
-- v_Table: Nome da tabela que será apagada.
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Drop_Table`(
	IN v_Database  VARCHAR(70),
	IN v_Table VARCHAR(70)
)
BEGIN
	IF fx_TB_Exist( v_Database, v_Table ) THEN 
		SET @sql := concat('DROP TABLE `', v_Database, '`.`', v_Table, '`' );
		PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		SELECT concat( 'Tabela: [ ', v_Table, ' ] apagada com sucesso!' ) AS Result;
	ELSE
		SELECT concat( 'Tabela: [ ', v_Table, ' ] NÃO existe!' ) AS Result;
	END IF; 
END