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

 

