pragma solidity 0.8.0;

contract Transfer {
    address payable from;
    address payable to;

    constructor() {
        from = msg.sender;
    }

    event Pay(address _to, address _from, uint256 amt);

    function pay(address payable _to) public payable returns (bool) {
        to = _to;
        to.transfer(msg.value);
        emit Pay(to, from, msg.value);
        return true;
    }
}
