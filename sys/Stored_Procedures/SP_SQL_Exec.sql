CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_SQL_Exec`(
    IN  v_command    TEXT,
    OUT v_result     BOOLEAN,
    OUT v_error_code INT,
    OUT v_error_msg  TEXT
)
proc_main: BEGIN
    DECLARE v_prepared BOOLEAN DEFAULT FALSE;		-- Variável de controle para DEALLOCATE seguro
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION		-- Handler de erro com captura dos detalhes
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_error_code = MYSQL_ERRNO,
            v_error_msg  = MESSAGE_TEXT;
        SET v_result = FALSE;
    END;

    -- Inicializa variáveis de saída
    SET v_result = FALSE;
    SET v_error_code = NULL;
    SET v_error_msg = NULL;
    
    IF NOT sys.fx_SQL_Valid(v_command) THEN		-- Validação via função externa
        SET v_error_code = 1002;
        SET v_error_msg = 'Comando SQL inválido. Verifique a sintaxe.';
        LEAVE proc_main;
    END IF;

    -- Executa comando dinâmico
    SET @sql := v_command;
	PREPARE stmt FROM @sql;
    select v_error_code, v_error_msg;
    -- SET v_prepared = TRUE;

    -- EXECUTE stmt;
    -- IF v_prepared THEN
    --    DEALLOCATE PREPARE stmt;
    -- END IF;
    
    SET v_result = TRUE;	-- Se sucesso
END proc_main