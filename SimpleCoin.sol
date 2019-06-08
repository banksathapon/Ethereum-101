
pragma solidity >=0.5.0 <0.7.0;

//Change the contract name to your token name

contract DPUXToken {
    // Name your custom token
    string public constant name = "DPU-X TOKEN";

    // Name your custom token symbol
    string public constant symbol = "DPUX";

    uint8 public constant decimals = 18;
    
    // Contract owner will be your Link account
    address public owner;

    address public treasury;

    uint256 public totalSupply;

    mapping (address => mapping (address => uint256)) private allowed;
    mapping (address => uint256) private balances;

    event Approval(address indexed tokenholder, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor() public {
        owner = msg.sender;

        // Add your wallet address here which will contain your total token supply
        treasury = address(owner);

        // Set your total token supply (default 1000)
        totalSupply = 1000 * 10**uint(decimals);

        balances[treasury] = totalSupply;
        emit Transfer(address(0), treasury, totalSupply);
    }

    function () external payable {
        revert();
    }

    function balanceOf(address _tokenholder) public view returns (uint256 balance) {
        return balances[_tokenholder];
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != msg.sender);
        require(_to != address(0));
        require(_to != address(this));
        require(balances[msg.sender] - _value <= balances[msg.sender]);
        require(balances[_to] <= balances[_to] + _value);
        require(_value <= transferableTokens(msg.sender));

        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }
    
    function transferableTokens(address holder) public view returns (uint256) {
        return balanceOf(holder);
    }
}
