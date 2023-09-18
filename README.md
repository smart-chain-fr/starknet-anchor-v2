# starknet-anchor-v2
Anchor contracts (written in cairo v2.2.0)

## Compile and tests

Compile smart contracts with command `scarb build` (it generates compiled files in the directory `target/dev`).

Launch tests with `scrab test` or directly with Starknet-foundry `snforge`

If you get the following error,  
```
error: Plugin diagnostic: The 'contract' attribute was deprecated, please use `starknet::contract` instead.
 --> lib.cairo:1:1
#[contract]
^*********^
```
you need to remove node_modules with `make clean` because a module contains a deprecated smart contract example.


## Deployments

The repository provides scripts written in TypeScript for deploying smart contracts. 

It relies on the Starknet-js library which can be installed with `make install`.

Before deploying an instance of a Factory contract , one must declare (only once) the class contract of Anchoring and Factory.
`make declare-anchoring`
`make declare-factory`

Once class contract have been declared, an instance can be produced by deploying the factory contract.
`make deploy-factory`

Once the Factory contract has been deployed, the instance is available for producing a new Anchoring contract.
`make generate-anchoring`
It should produce locally a file `anchoring.ts` with the address of the anchoring smart contract.

Anchor a message
`make anchor-message MSG=itworks!`

