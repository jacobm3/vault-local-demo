#!/bin/bash -x

for x in $(seq -w 1 2000); do
  echo $x
  vault namespace create $x
  vault secrets enable -namespace $x -version 2 kv
done
