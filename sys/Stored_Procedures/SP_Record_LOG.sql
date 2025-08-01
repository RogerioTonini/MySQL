CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Record_LOG`(
    IN v_data             VARCHAR(50),
    IN v_NomeTabela       VARCHAR(50),
    IN v_NomeColuna       VARCHAR(50),
    IN v_TipoTamExistente VARCHAR(50),
    IN v_TipoTamSugerido  VARCHAR(50),
    IN v_Mensagem         VARCHAR(255)
)
BEGIN
	SET @v_NomeTabela       = v_NomeTabela;
    SET @v_NomeColuna       = v_NomeColuna;
    SET @v_TipoTamExistente = v_TipoTamExistente;
    SET @v_TipoTamSugerido  = v_TipoTamSugerido;
    SET @v_Mensagem         = v_Mensagem;
    
    SET @sql = CONCAT(
        'INSERT INTO `', v_data, '`.T_Alteracoes_LOG ',
        '( DATA_HORA, NOME_TABELA, NOME_COLUNA, TP_TAM_EXISTENTE, TP_TAM_SUGERIDO, MENSAGEM )', 
        'VALUES ( NOW(), ?, ?, ?, ?, ? )' );

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @v_NomeTabela, @v_NomeColuna, @v_TipoTamExistente, @v_TipoTamSugerido, @v_Mensagem;
    DEALLOCATE PREPARE stmt;
END