pragma solidity^0.8.4;

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Task1 is IERC20{
    uint256 private _totalTokens;
    address private _contractOwner;
     string private _name;
    string private _symbol;
    
    
    constructor(string memory tokName, string memory tokSymbol) {
        
        _contractOwner = msg.sender;
        _name = tokName;
        _symbol = tokSymbol;
        _mint(_contractOwner,5000000000000000000);
    }
    
    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256) ) 
    private _approved;
     function name() public view  
     returns (string memory) {
        return _name;
    }

    function symbol() public view 
    returns (string memory) {
        return _symbol;
    }
    function totalSupply() 
    override public view
    returns(uint256)
    {
        return(_totalTokens);
    } 
    
    function balanceOf(address _owner)
    public view override returns
    (uint256) 
    {
        return _balance[_owner];
    }
    
    function transfer(address _to, uint256 _value) 
    public override
    returns (bool success)
    {
        require(balanceOf(msg.sender)>=_value,
        "Insufficient Balance");
        require(_to!=address(0));
        _balance[msg.sender] -= _value;
        _balance[_to] += _value;
        emit Transfer(msg.sender,_to,_value);
        return true;
        
    }
    
    
    function transferFrom(address _from,
    address _to,
    uint256 _value)
    public override 
    returns (bool success) 
    //fixed
    {
     require(balanceOf(_from)>=_value,
        "Insufficient Balance");
        require(allowance(_from,msg.sender)>=_value,"not allowed");
        require(_to!=address(0),"please dont burn using this method");
         _balance[_from] -= _value;
        _balance[_to] += _value;
        emit Transfer(_from,_to,_value);
        return true;
        
    }
    
    function approve(address _spender, uint256 _value) 
    public override 
    returns (bool success)
    {
        require(balanceOf(msg.sender)>=_value,
        "Insufficient Balance");
        require(_spender!=address(0));
        _approved[msg.sender][_spender]= _value;
        emit Approval(msg.sender,_spender,_value);
        return true;
    }
    
    function allowance(address owner, address _spender) 
    public override view 
    returns (uint256 remaining)
    {
        return _approved[owner][_spender];
    }
    function _mint(address account, uint256 amount) public
    {
        require(account!=address(0));
        _totalTokens +=amount;
        _balance[account] += amount;
        emit Transfer(address(0),account,amount);
    } 
}

