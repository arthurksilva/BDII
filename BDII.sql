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


 

