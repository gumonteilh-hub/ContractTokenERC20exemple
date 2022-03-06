// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AccessControl {
    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);
    mapping(bytes32 => mapping(address => bool)) public roles;

    bool private allowAutoGrantRole = true;

    bytes32 internal constant OWNER = keccak256(abi.encodePacked("OWNER"));
    bytes32 internal constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    bytes32 internal constant USER = keccak256(abi.encodePacked("USER"));

    modifier onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "not authorized");
        _;
    }

    constructor() {
        _grantRole(OWNER, msg.sender);
    }

    function _grantRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
    }

    function grantRole(bytes32 _role, address _account)
        external
        onlyRole(ADMIN)
    {
        _grantRole(_role, _account);
    }

    // this function is not supposed to exist but I created it to allow to test the application
    function autoGrantAdminRole() external {
        require(
            allowAutoGrantRole,
            "The owner of this contract doesn't allow auto granting ADMIN role"
        );

        _grantRole(ADMIN, msg.sender);
    }

    function setAllowAutoGrantRole(bool _allowAutoGrantRole)
        external
        onlyRole(OWNER)
    {
        allowAutoGrantRole = _allowAutoGrantRole;
    }
}

contract Guigui is ERC20, AccessControl {
    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _grantRole(OWNER, msg.sender);
        _grantRole(ADMIN, msg.sender);
    }


    function mintFaucet() external onlyRole(ADMIN) {
      require(balanceOf(msg.sender) == 0);
      _mint(msg.sender, 100);
    }
}
