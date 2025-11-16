#!/bin/bash

# Recebe o caminho do arquivo (relativo ou absoluto)
FILEPATH=$1
# Extrai apenas o nome do arquivo sem extensão
ARQ=`basename $FILEPATH|sed "s/\.cmm//"`
# Obtém o diretório do arquivo
DIR=`dirname $FILEPATH`

java Parser $FILEPATH >$DIR/$ARQ.s
# 32 bits
# as -o $ARQ.o $ARQ.s
#ld -o $ARQ   $ARQ.o

# 64 bits 
as --32 -o $DIR/$ARQ.o $DIR/$ARQ.s
ld -m elf_i386 -s -o $DIR/$ARQ   $DIR/$ARQ.o

# 👉 Executa automaticamente o binário gerado
echo "Executando $DIR/$ARQ..."
$DIR/$ARQ
