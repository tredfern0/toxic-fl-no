#!/bin/bash
cp src/suave_spec.yaml suave-geth/suave/gen/
go run suave-geth/suave/gen/main.go --write
cp src/contracts_suave.go suave-geth/core/vm/
