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





 

