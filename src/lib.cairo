mod factory;
mod anchoring;

#[cfg(test)]
mod tests {
    use core::option::OptionTrait;
use starknet::ContractAddress;
    
    use factory_anchor::factory::FactoryTraitDispatcherTrait;
    use super::factory;

    use array::ArrayTrait;
    use traits::Into;
    // use array::ArrayTrait;
    use core::result::ResultTrait;
    // use core::traits::Into;
    // use option::OptionTrait;
    use starknet::syscalls::deploy_syscall;
    use traits::TryInto;

    use test::test_utils::assert_eq;



    #[test]
    #[available_gas(1000000)]
    fn it_works() {
        let admin: felt252 = 0x021b328153b45744778795f5c8edd9211da72fca894ef91ea389c479a31f1449;
        let class_hash = 0x2bcad2faa9adef1787dca061d108ab3e0eb4d4916fdc4642517c4102003b21c;

        let mut calldata_array = ArrayTrait::new();
        calldata_array.append(admin);
        calldata_array.append(class_hash);

        let (address0, _error) = deploy_syscall(
            factory::Factory::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata_array.span(), false
        ).unwrap();
        let mut contract0 = factory::FactoryTraitDispatcher { contract_address: address0 };

        let current_admin = contract0.get_admin();
        let initial_admin : ContractAddress = admin.try_into().unwrap();
        assert_eq(@current_admin, @initial_admin , 'Wrong_admin');
    }
}
