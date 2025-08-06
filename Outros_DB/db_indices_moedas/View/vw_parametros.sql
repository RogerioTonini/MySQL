CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `db_indices_moedas`.`vw_parametros` AS
    SELECT 
        `db_indices_moedas`.`t_parametros`.`NUM_INDEX` AS `NUM_INDEX`,
        `db_indices_moedas`.`t_parametros`.`DataInicio_txt` AS `DataInicio_txt`,
        `db_indices_moedas`.`t_parametros`.`ExtensaoArquivos` AS `ExtensaoArquivos`,
        `db_indices_moedas`.`t_parametros`.`Idioma` AS `Idioma`,
        `db_indices_moedas`.`t_parametros`.`DataInicio` AS `DataInicio`,
        `db_indices_moedas`.`t_parametros`.`QtdeRegistros` AS `QtdeRegistros`,
        `db_indices_moedas`.`t_parametros`.`URL_Padrao` AS `URL_Padrao`
    FROM
        `db_indices_moedas`.`t_parametros`
    LIMIT 1