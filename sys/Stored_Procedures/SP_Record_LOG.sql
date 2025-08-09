CREATE DEFINER=`root`@`localhost` PROCEDURE `sys`.`SP_Record_LOG`(
    IN v_Database     VARCHAR(50),
    IN  v_TableName   VARCHAR(50),
    IN v_ColumnName   VARCHAR(50),
    IN v_TipoTamAtual VARCHAR(50),
    IN v_TipoTamNovo  VARCHAR(50),
    IN v_Mensagem     VARCHAR(255)
)
BEGIN
	SET @v_TableName    := v_TableName;
    SET @v_ColumnName   := v_ColumnName;
    SET @v_TipoTamAtual := v_TipoTamAtual;
    SET @v_TipoTamNovo  := v_TipoTamNovo;
    SET @v_Mensagem     := v_Mensagem;
    
    SET @sql = concat(
        'INSERT INTO `', v_Database, '`.t_alteracoes_log ',
        '( DATA_HORA, NOME_TABELA, NOME_COLUNA, TP_TAM_ATUAL, TP_TAM_NOVO, MENSAGEM )', 
        'VALUES ( NOW(3), ?, ?, ?, ?, ? )' );

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @v_TableName, @v_ColumnName, @v_TipoTamAtual, @v_TipoTamNovo, @v_Mensagem;
    DEALLOCATE PREPARE stmt;
END