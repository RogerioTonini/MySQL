-- Author: Rogerio Tonini
-- Data: 25/07/2025
-- Versão: 1.0
-- URL: HTTP://www.github.com/RogerioTonini
-- Objetivo: Apagar índices de uma tabela específica, exceto o índice PRIMARY.
-- Esta procedure tenta excluir índices de uma tabela, com até 3 tentativas para cada índice.
-- Se não houver índices além do PRIMARY, retorna uma mensagem informativa.
-- Se ocorrer um erro ao excluir um índice, tenta novamente até 3 vezes.
--
-- Schema: sys
--
-- Utilização - Parâmetros:
-- v_Database: Nome do banco de dados onde a tabela está localizada.
-- v_Table: Nome da tabela da qual os índices serão excluídos.
-- v_Result: Variável de saída que indica se a operação foi bem-sucedida (TRUE) ou não (FALSE).
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Drop_Indexes`(
    IN v_Database VARCHAR(70),
    IN v_Table    VARCHAR(70),
    OUT v_Result  BOOLEAN
)
BEGIN
    DECLARE v_success     BOOLEAN DEFAULT TRUE;
	DECLARE v_attempts    INT DEFAULT 0;
    DECLARE v_index_count INT DEFAULT 0;
    DECLARE done          INT DEFAULT FALSE;
    DECLARE v_index_name  VARCHAR(64);

	-- Cursor para índices que não sejam PRIMARY
    DECLARE cur CURSOR FOR
        SELECT DISTINCT INDEX_NAME
        FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = v_Database
          AND TABLE_NAME = v_Table
          AND INDEX_NAME <> 'PRIMARY';  

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Verifica se há índices além do PRIMARY
    SELECT COUNT(DISTINCT INDEX_NAME)
    INTO v_index_count
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = V_Database
      AND TABLE_NAME = v_Table
      AND INDEX_NAME <> 'PRIMARY';

    -- Se não há índices, exibe mensagem e retorna sucesso
    IF v_index_count = 0 THEN
        SELECT CONCAT('A tabela `', v_Database, '`.`', v_Table, '` não possui índices (exceto PRIMARY). Nada a excluir.') AS Mensagem;
        SET v_Result = TRUE;
        SIGNAL SQLSTATE '45000';
    END IF;

    OPEN cur;

    drop_loop: LOOP
        FETCH cur INTO v_index_name;
        IF done THEN
            LEAVE drop_loop;
        END IF;

        SET v_attempts = 0;

        retry_loop: WHILE v_attempts < 3 DO
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                BEGIN
                    SET v_attempts = v_attempts + 1;
                    IF v_attempts = 3 THEN
                        SET v_success = FALSE;
                        SELECT CONCAT('Erro ao excluir índice: ', v_index_name, '. Tentativas esgotadas.') AS Erro;
                    END IF;
                END;

                -- Tenta executar DROP INDEX
                SET @sql = CONCAT('DROP INDEX `', v_index_name, '` ON `', v_Database, '`.`', v_Table, '`');
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;

                -- Se chegou aqui, sucesso
                LEAVE retry_loop;
            END;
        END WHILE;
    END LOOP;

    CLOSE cur;
    SET v_Result = v_success;
END