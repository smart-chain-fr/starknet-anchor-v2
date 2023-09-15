// mod factory;
// mod anchoring;

// #[cfg(test)]
// mod tests {
//    use snforge_std::{ declare, ContractClassTrait, start_prank, stop_prank };

//     use core::traits::PanicDestruct;
//     use core::option::OptionTrait;
//    use starknet::ContractAddress;
//    use factory;

    
//     use factory_anchor::factory::FactoryTraitDispatcherTrait;
//     use super::factory;

//    use array::ArrayTrait;
//     use traits::Into;
//     use traits::TryInto;
//     use core::result::ResultTrait;
//     use starknet::syscalls::deploy_syscall;


//    use test::test_utils::assert_eq;


    // #[test]
    // #[available_gas(1000000)]
    // fn success_initial_state() {
    //     let admin: felt252 = 0x021b328153b45744778795f5c8edd9211da72fca894ef91ea389c479a31f1449;
    //     let class_hash = 0x2bcad2faa9adef1787dca061d108ab3e0eb4d4916fdc4642517c4102003b21c;

    //     // Prepare deployment parameters
    //     let mut calldata_array = ArrayTrait::new();
    //     calldata_array.append(admin);
    //     calldata_array.append(class_hash);

    //     // First declare and deploy a contract
    //     let contract = declare('Factory');
    //     let contract_address = contract.deploy(@calldata_array).unwrap();
        
    //     // Create a Dispatcher object that will allow interacting with the deployed contract
    //     let dispatcher = factory::FactoryTraitDispatcher { contract_address: contract_address };

    //     let current_admin = dispatcher.get_admin();
    //     let initial_admin : ContractAddress = admin.try_into().unwrap();
    //     assert_eq(@current_admin, @initial_admin , 'Wrong_admin');
    // }


//     #[test]
//     #[available_gas(1000000)]
//     #[should_panic(expected: ('NOT_ADMIN_CALLER', ))]
//     fn failure_change_admin_because_not_admin() {
//         let admin: felt252 = 0x021b328153b45744778795f5c8edd9211da72fca894ef91ea389c479a31f1449;
//         let class_hash = 0x2bcad2faa9adef1787dca061d108ab3e0eb4d4916fdc4642517c4102003b21c;

//         // Prepare deployment parameters
//         let mut calldata_array = ArrayTrait::new();
//         calldata_array.append(admin);
//         calldata_array.append(class_hash);

//         // First declare and deploy a contract
//         let contract = declare('Factory');
//         let contract_address = contract.deploy(@calldata_array).unwrap();
        
//         // Create a Dispatcher object that will allow interacting with the deployed contract
//         let dispatcher = factory::FactoryTraitDispatcher { contract_address: contract_address };

//         let new_admin: felt252 = 0x02ce9c6303529f79e5bfbd09f9cf52421df68a962177977b8a8cc2074b84c097;
//         dispatcher.changeAdmin(new_admin.try_into().unwrap())
//     }

//     #[test]
//     #[available_gas(1000000)]
//     fn success_change_admin() {
//         let admin: felt252 = 0x021b328153b45744778795f5c8edd9211da72fca894ef91ea389c479a31f1449;
//         let class_hash = 0x2bcad2faa9adef1787dca061d108ab3e0eb4d4916fdc4642517c4102003b21c;

//         // Prepare deployment parameters
//         let mut calldata_array = ArrayTrait::new();
//         calldata_array.append(admin);
//         calldata_array.append(class_hash);

//         // First declare and deploy a contract
//         let contract = declare('Factory');
//         let contract_address = contract.deploy(@calldata_array).unwrap();
        
//         // Create a Dispatcher object that will allow interacting with the deployed contract
//         let dispatcher = factory::FactoryTraitDispatcher { contract_address: contract_address };

//         let new_admin: felt252 = 0x02ce9c6303529f79e5bfbd09f9cf52421df68a962177977b8a8cc2074b84c097;
//         start_prank(contract_address, admin.try_into().unwrap());
//         dispatcher.changeAdmin(new_admin.try_into().unwrap());
//         stop_prank(contract_address);

//         let proposed_admin = dispatcher.get_proposed_admin();
//         let expected_proposed_admin : ContractAddress = new_admin.try_into().unwrap();
//         assert_eq(@proposed_admin, @expected_proposed_admin , 'Wrong_propose_admin');
//     }


//     #[test]
//     #[available_gas(1000000)]
//     fn success_change_and_accept_admin() {
//         let admin: felt252 = 0x021b328153b45744778795f5c8edd9211da72fca894ef91ea389c479a31f1449;
//         let class_hash = 0x2bcad2faa9adef1787dca061d108ab3e0eb4d4916fdc4642517c4102003b21c;

//         // Prepare deployment parameters
//         let mut calldata_array = ArrayTrait::new();
//         calldata_array.append(admin);
//         calldata_array.append(class_hash);

//         // First declare and deploy a contract
//         let contract = declare('Factory');
//         let contract_address = contract.deploy(@calldata_array).unwrap();
        
//         // Create a Dispatcher object that will allow interacting with the deployed contract
//         let dispatcher = factory::FactoryTraitDispatcher { contract_address: contract_address };

//         let new_admin: felt252 = 0x02ce9c6303529f79e5bfbd09f9cf52421df68a962177977b8a8cc2074b84c097;
//         start_prank(contract_address, admin.try_into().unwrap());
//         dispatcher.changeAdmin(new_admin.try_into().unwrap());
//         stop_prank(contract_address);

//         start_prank(contract_address, new_admin.try_into().unwrap());
//         dispatcher.acceptAdmin();
//         stop_prank(contract_address);

//         let current_admin = dispatcher.get_admin();
//         let expected_admin : ContractAddress = new_admin.try_into().unwrap();
//         assert_eq(@current_admin, @expected_admin , 'Wrong_admin');
//     }

//     #[test]
//     #[available_gas(1000000)]
//     #[should_panic(expected: ('NOT_PROPOSED_ADMIN_CALLER', ))]
//     fn failure_accept_admin_because_not_proposed_admin() {
//         let admin: felt252 = 0x021b328153b45744778795f5c8edd9211da72fca894ef91ea389c479a31f1449;
//         let class_hash = 0x2bcad2faa9adef1787dca061d108ab3e0eb4d4916fdc4642517c4102003b21c;

//         // Prepare deployment parameters
//         let mut calldata_array = ArrayTrait::new();
//         calldata_array.append(admin);
//         calldata_array.append(class_hash);

//         // First declare and deploy a contract
//         let contract = declare('Factory');
//         let contract_address = contract.deploy(@calldata_array).unwrap();
        
//         // Create a Dispatcher object that will allow interacting with the deployed contract
//         let dispatcher = factory::FactoryTraitDispatcher { contract_address: contract_address };

//         let new_admin: felt252 = 0x02ce9c6303529f79e5bfbd09f9cf52421df68a962177977b8a8cc2074b84c097;
//         start_prank(contract_address, admin.try_into().unwrap());
//         dispatcher.changeAdmin(new_admin.try_into().unwrap());

//         dispatcher.acceptAdmin();
//         stop_prank(contract_address);
//     }

//     #[test]
//     #[available_gas(1000000)]
//     fn success_deploy() {
//         let admin: felt252 = 0x021b328153b45744778795f5c8edd9211da72fca894ef91ea389c479a31f1449;
//         // let class_hash = 0x2bcad2faa9adef1787dca061d108ab3e0eb4d4916fdc4642517c4102003b21c;
//         let anchoring_contract_class = declare('Anchoring');
        
//         // Prepare deployment parameters
//         let mut calldata_array = ArrayTrait::new();
//         calldata_array.append(admin);
//         calldata_array.append(anchoring_contract_class.class_hash.into());

//         // First declare and deploy a contract

//         let factory_contract = declare('Factory');
//         let factory_contract_address = factory_contract.deploy(@calldata_array).unwrap();
        
//         // Create a Dispatcher object that will allow interacting with the deployed contract
//         let factory_dispatcher = factory::FactoryTraitDispatcher { contract_address: factory_contract_address };

//         let new_admin: felt252 = 0x02ce9c6303529f79e5bfbd09f9cf52421df68a962177977b8a8cc2074b84c097;
//         start_prank(factory_contract_address, admin.try_into().unwrap());
//         factory_dispatcher.deploy(new_admin.try_into().unwrap());
//         stop_prank(factory_contract_address);

//         let index = factory_dispatcher.get_owner_contract_index(new_admin.try_into().unwrap());
//         assert_eq(@index, @1, 'Wrong_number_of_contracts');

//         let last_deployed_anchor = factory_dispatcher.get_owner_contract_by_index(new_admin.try_into().unwrap(), index - 1);
        
//     }

// }