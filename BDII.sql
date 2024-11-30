1.
SELECT codigo, ano 
FORM aeronaves
WHERE precoTabela < 2300000

2.
SELECT fabricante, pais 
FORM aeronaves;

3.
SELECT pais,modelo,fabricante
FROM aeronaves
WHERE modelo == "A320" and 
fabricante == "Airbus";

4.
SELECT
codAeronaves as aeronave, 
pais as origem_pais_aeronave,
companhia as companhia_dona_aeronave
FROM aeronaves,transacoes
WHERE aeronaves =! "franca";

5.
SELECT 
nome as nome passageiro 
ano as ano aeronave
FROM passageiro, aeronaves
WHERE ano == 1996;


7.
SELECT CNPJCompanhia, SUM(Quantidade) AS TotalAeronaves
FROM HANGARES
GROUP BY CNPJCompanhia;


8.
SELECT A.Fabricante, A.Modelo, H.CodAeronave, COUNT(DISTINCT H.CNPJCompanhia) AS NumCompanhias
FROM AERONAVES A
JOIN HANGARES H ON A.Código = H.CodAeronave AND A.Ano = H.AnoAeronave
GROUP BY A.Fabricante, A.Modelo, H.CodAeronave
HAVING COUNT(DISTINCT H.CNPJCompanhia) > 1;

9.
SELECT Código, Ano, Fabricante, Modelo, País, PreçoTabela
FROM AERONAVES
ORDER BY PreçoTabela DESC
LIMIT 1;

10.
SELECT CodAeronave, AnoAeronave, Companhia, SUM(Preço) AS TotalPago
FROM TRANSAÇÕES
GROUP BY CodAeronave, AnoAeronave, Companhia;

11.
SELECT Código, Ano, Fabricante, Modelo, País, PreçoTabela
FROM AERONAVES
WHERE País IN ('Itália', 'Japão')
ORDER BY Código ASC, Ano ASC, PreçoTabela DESC;

12.
SELECT SUM(Preço * 0.10) AS LucroAdicional
FROM TRANSAÇÕES
WHERE Companhia = 'Aviamodelo';

13. 
SELECT Companhia, SUM(Preço) AS TotalLucro
FROM TRANSAÇÕES
GROUP BY Companhia
ORDER BY TotalLucro DESC
LIMIT 1;

14.
CREATE PROCEDURE ListarAeronavesCompanhia (IN NomeCompanhia VARCHAR(100))
BEGIN
    SELECT DISTINCT A.Fabricante, A.Modelo
    FROM AERONAVES A
    JOIN TRANSAÇÕES T ON A.Código = T.CodAeronave AND A.Ano = T.AnoAeronave
    JOIN COMPANHIAS_AEREAS C ON T.Companhia = C.CNPJ
    WHERE C.Nome = NomeCompanhia
    
    UNION
    
    SELECT DISTINCT A.Fabricante, A.Modelo
    FROM AERONAVES A
    JOIN HANGARES H ON A.Código = H.CodAeronave AND A.Ano = H.AnoAeronave
    JOIN COMPANHIAS_AEREAS C ON H.CNPJCompanhia = C.CNPJ
    WHERE C.Nome = NomeCompanhia;
END;

15.
CREATE PROCEDURE ListarCompanhiasComMaisDe50Transacoes (
    IN DataInicio DATE,
    IN DataFim DATE
)
BEGIN
    SELECT C.Nome AS CompanhiaAerea, COUNT(T.Companhia) AS TotalTransacoes
    FROM TRANSAÇÕES T
    JOIN COMPANHIAS_AEREAS C ON T.Companhia = C.CNPJ
    WHERE T.Data BETWEEN DataInicio AND DataFim
    GROUP BY C.Nome
    HAVING COUNT(T.Companhia) > 50;
END;


16.
CREATE PROCEDURE ListarCompradoresAeronaves (
    IN PaisAeronave VARCHAR(50),
    IN FabricanteAeronave VARCHAR(50)
)
BEGIN
    SELECT DISTINCT P.Nome, P.Sobrenome
    FROM PASSAGEIROS P
    JOIN TRANSAÇÕES T ON P.Passaporte = T.Comprador
    JOIN AERONAVES A ON T.CodAeronave = A.Código AND T.AnoAeronave = A.Ano
    WHERE A.País = PaisAeronave AND A.Fabricante = FabricanteAeronave;
END;

18.
DELIMITER //

CREATE TRIGGER LimitarComprasAnuais
BEFORE INSERT ON TRANSAÇÕES
FOR EACH ROW
BEGIN
    DECLARE ComprasAno INT;

   
    SELECT COUNT(*)
    INTO ComprasAno
    FROM TRANSAÇÕES
    WHERE Comprador = NEW.Comprador
      AND YEAR(Data) = YEAR(NEW.Data);

    
    IF ComprasAno >= 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O passageiro não pode comprar mais de 10 aeronaves em um único ano.';
    END IF;
END;

19.
DELIMITER //

CREATE TRIGGER VerificarPrecoTabela
BEFORE INSERT OR UPDATE ON AERONAVES
FOR EACH ROW
BEGIN
    DECLARE PrecoAnterior DECIMAL(10, 2);

    
    SELECT MAX(PrecoTabela)
    INTO PrecoAnterior
    FROM AERONAVES
    WHERE Modelo = NEW.Modelo
      AND Ano < NEW.Ano;

    
    IF PrecoAnterior IS NOT NULL AND NEW.PreçoTabela < PrecoAnterior THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O preço de tabela não pode ser menor que o de anos anteriores para o mesmo modelo.';
    END IF;
END;

20.
CREATE TRIGGER ValidarPrecoTransacao
BEFORE INSERT ON TRANSAÇÕES
FOR EACH ROW
BEGIN
    DECLARE PrecoTabela DECIMAL(10, 2);

   
    SELECT PrecoTabela
    INTO PrecoTabela
    FROM AERONAVES
    WHERE Código = NEW.CodAeronave AND Ano = NEW.AnoAeronave;

   
    IF PrecoTabela IS NOT NULL AND NEW.Preço < (PrecoTabela * 0.85) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O preço da transação não pode ser menor que 85% do preço de tabela da aeronave.';
    END IF;
END;

21. 
CREATE TRIGGER BloquearCompraSantosFrancesa
BEFORE INSERT ON TRANSAÇÕES
FOR EACH ROW
BEGIN
    DECLARE SobrenomeComprador VARCHAR(100);
    DECLARE NacionalidadeAeronave VARCHAR(50);

   
    SELECT Sobrenome
    INTO SobrenomeComprador
    FROM PASSAGEIROS
    WHERE Passaporte = NEW.Comprador;

    
    SELECT País
    INTO NacionalidadeAeronave
    FROM AERONAVES
    WHERE Código = NEW.CodAeronave AND Ano = NEW.AnoAeronave;

   
    IF SobrenomeComprador = 'Santos' AND NacionalidadeAeronave = 'França' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pessoas com sobrenome "Santos" não podem comprar aeronaves de nacionalidade francesa.';
    END IF;
END;

22.
CREATE TRIGGER AjustarDataTransacao
BEFORE INSERT ON TRANSAÇÕES
FOR EACH ROW
BEGIN
    DECLARE DataMaisRecente DATE;

    SELECT MAX(Data)
    INTO DataMaisRecente
    FROM TRANSAÇÕES;

    IF DataMaisRecente IS NOT NULL AND NEW.Data < DataMaisRecente THEN
        SET NEW.Data = DataMaisRecente;
    END IF;
END;









