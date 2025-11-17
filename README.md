# Trabalho de Compiladores

Integrantes: Benjamin Mattar, Bernardo Balzan, Francisco Borba e Matheus Magri

## Como compilar

1. Execute o comando:

```
make
```

## Como rodar os testes

Use o executável `run.x` apontando para o arquivo de teste desejado:

```
./run.x testes/t01.cmm
```

Para rodar todos (t01 a t08):

```
./run.x testes/t01.cmm
./run.x testes/t02.cmm
./run.x testes/t03.cmm
./run.x testes/t04.cmm
./run.x testes/t05.cmm
./run.x testes/t06.cmm
./run.x testes/t07.cmm
./run.x testes/t08.cmm
```
```
./run.x testes/tstruct.cmm
./run.x testes/tstruct2.cmm
./run.x testes/tstruct3.cmm
./run.x testes/tarray.cmm
./run.x testes/tarray2.cmm
./run.x testes/tarraystruct.cmm
./run.x testes/tmisto.cmm
```


## Observação


O script `run.x` agora executa automaticamente o binário gerado. Foi adicionada a seguinte lógica:

```
echo "Executando $DIR/$ARQ..."
$DIR/$ARQ
```

Assim, não é mais necessário rodar o binário manualmente — basta usar:

```
./run.x testes/t01.cmm
```

para executar o teste automaticamente.



