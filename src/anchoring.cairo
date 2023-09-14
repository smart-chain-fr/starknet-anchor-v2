use array::ArrayTrait;

#[starknet::interface]
trait AnchorTrait<T> {
    /// @dev Function that anchor a message
    fn anchor(ref self: T, message: felt252);
    /// @dev Function that retrieves all anchored timestamps
    fn get_anchored_timestamps(self: @T) -> Array::<u64>;
    /// @dev Function that retrieves all anchored messages 
    fn get_anchored_values(self: @T) -> Array::<felt252>;
    /// @dev Function that retrieves the timestamps of a given anchored message 
    fn get_anchored_timestamp(self: @T, message: felt252) -> u64;
}

#[starknet::contract]
mod Anchoring {
    use starknet::get_caller_address;
    use starknet::get_block_timestamp;
    use starknet::ContractAddress;
    use array::ArrayTrait;

    // Storage variable used to store the anchored value
    #[storage]
    struct Storage {
        whitelisted: ContractAddress, // The address of the whitelisted contract
        size_index: u128, // size of the array
        message_values: LegacyMap<u128, felt252>, // index, message
        message_timestamp: LegacyMap<felt252, u64> // message, timestamp
    }

    // Function used to initialize the contract
    #[constructor]
    fn constructor(ref self: ContractState, _whitelisted: ContractAddress) {
        self.whitelisted.write(_whitelisted);
        self.size_index.write(0);
    }

    #[external(v0)]
    impl AnchorImpl of super::AnchorTrait<ContractState> {
        // Function used to anchor a new value
        fn anchor(ref self: ContractState, message: felt252) {
            assert(!(self.message_timestamp.read(message) > 0), 'already_anchored');
            assert(get_caller_address() == self.whitelisted.read(), 'not_whitelisted_caller');
            self.message_values.write(self.size_index.read(), message);
            self.message_timestamp.write(message, get_block_timestamp());
            self.size_index.write(self.size_index.read() + 1);
        }

        fn get_anchored_timestamps(self: @ContractState) -> Array::<u64> {
            let mut values = ArrayTrait::new();
            self.construct_anchored_timestamps_array(values, 0_u128, self.size_index.read())
        }

        fn get_anchored_values(self: @ContractState) -> Array::<felt252> {
            let mut values = ArrayTrait::new();
            self.construct_anchored_values_array(values, 0_u128, self.size_index.read())
        }

        fn get_anchored_timestamp(self: @ContractState, message: felt252) -> u64 {
            self.message_timestamp.read(message)
        }
    }

    /// @dev Internal Functions implementation for the Anchoring contract
    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        /// @dev Construct an array with all message timestamps
        fn construct_anchored_timestamps_array(
            self: @ContractState, mut values: Array::<u64>, index: u128, last_index: u128
        ) -> Array::<u64> {
            if index < last_index {
                let message = self.message_values.read(index);
                values.append(self.message_timestamp.read(message));
                self.construct_anchored_timestamps_array(values, index + 1, last_index)
            } else {
                values
            }
        }
        /// @dev Construct an array with all anchored messages
        fn construct_anchored_values_array(
            self: @ContractState, mut values: Array::<felt252>, index: u128, last_index: u128
        ) -> Array::<felt252> {
            if index < last_index {
                values.append(self.message_values.read(index));
                self.construct_anchored_values_array(values, index + 1, last_index)
            } else {
                values
            }
        }
    }
}
