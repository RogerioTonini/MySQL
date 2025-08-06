CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `db_indices_moedas`.`vw_url_bcb_moedas` AS
    SELECT 
        `db_indices_moedas`.`t_consultas`.`Complemento_URL` AS `Complemento_URL`,
        `db_indices_moedas`.`t_consultas`.`Colunas` AS `Colunas`
    FROM
        `db_indices_moedas`.`t_consultas`
    WHERE
        (`db_indices_moedas`.`t_consultas`.`NUM_INDEX` = 1)