pragma solidity >=0.5.0 <0.7.0;
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/ERC20.sol";


interface stablecoin {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract perk {
    // The keyword "public" makes variables
    // accessible from other contracts
    address public provider;
    address public account;     //account stable coin 
    address public adr;        //address of stable coin 
    uint valideperiode;
    
    struct Voucher {
        uint valu; // the value of the voucher
        address merchant;
        uint beginat;   // the time the voucher issued
    }
    
    
     Voucher[] public Vouchers; 
     
    struct employee {
        address name;
	  string title:
        address company;     // the company of the employee
        Voucher[]  wallet;
        uint total;
        uint totalexpired;
        
    } 
    
    struct company {
       address name;
	 string title
       employee[] employees;
        uint total;
        uint totalexpired;
        
    }
    
    
    
    
    struct merchant {
        address name;
        string title;
        uint valu;
        uint total;
    }
    
    mapping (address => company) public companies;
    mapping (address => merchant) public merchants;
    mapping (address => employee) public employees;
    
    
    // Constructor code is only run when the contract
    // is created

    constructor(address _adr) public {
        provider  = msg.sender;
        account = msg.sender;
        adr = _adr;
        valideperiode = 90 days;
    }

    
                                //     functions of companies
    
    function companyregister(address  _token, string _title) public  returns(bool){
        company memory cm;                            //_token is the address of the stable coin.
        cm.name=_token;
        cm.total=0;
	  cm.title=_title;
        cm.totalexpired;
        companies[msg.sender]=cm;
        return true;
        
    }
    // a company can register an employee
     function companyregisteremployee(address  _employee, string _title) public  returns(bool){
       employee memory emp;                            
        emp.name=_employee;
	  em.title=_title
        emp.total=0;    // no need itis 0 at the creation 
        emp.totalexpired=0;
        emp.company=msg.sender;
        employees[_employee]=emp;
        return true;
        
    }
    
    
    function sendvoucher(address  _employee, uint _amount, address _merchant) public payable  returns(bool){
        stablecoin c = stablecoin(adr);
        if (c.balanceOf(companies[msg.sender].name) >=_amount) {
          Voucher memory vou;
          vou.valu=_amount;
          vou.merchant=_merchant;
          vou.beginat=now;
          c.transferFrom(companies[msg.sender].name, account, _amount) ;
          employees[_employee].wallet.push(vou);
          employees[_employee].total+=_amount;
          return true;
        }
        return false;
    }  
    
    //compay get back expired vouchers  
    // for optimization we can write a function to test if there are expired vouchers 
     function getexpired() public payable  returns(bool){
        // the company will check employees for expired token
         employee[] memory employees;   
         Voucher[] memory vouchers;
         uint total;
         uint totalparemp;
         total=0;
         
        employees=companies[msg.sender].employees;   
        
      for(uint cindex=0; cindex<employees.length; cindex++){
            vouchers=employees[cindex].wallet;
            totalparemp=0;
            for(uint vindex=0; vindex<vouchers.length; vindex++){
                if (vouchers[vindex].valu!=0 && (now-vouchers[vindex].beginat)> valideperiode  ) {
                    total+=vouchers[vindex].valu;
                    totalparemp+=vouchers[vindex].valu;
                    vouchers[vindex].valu=0;
                    
                }
            }
            employees[cindex].totalexpired+=totalparemp;
        }
       if (total!=0) {
            stablecoin c = stablecoin(adr);
            c.transferFrom( account, companies[msg.sender].name, total) ;
            companies[msg.sender].totalexpired+=total;
            return true;
       }        
        return false;
    }  
    
    
    //functions of employees

   function available(uint _amount, address _merchat) public payable  returns(bool) {  //to check if there is ennough funds for that merchant
      Voucher[] memory vouchers;  
	vouchers=employees[msg.sender].wallet;
      totalparemp=0;
            for(uint vindex=0; vindex<vouchers.length; vindex++){
                if (vouchers[vindex].valu!=0 && (vouchers[vindex].merchant== _merchant  ) && (now-vouchers[vindex].beginat)> valideperiode) {
                    totalparemp+=vouchers[vindex].valu;
                    if (_amount<= totalparemp) return true:
                    
                }
            }

        return false;
    }
    
   function buy(uint _amount, address _merchant) public payable  returns(bool) {
   Voucher[] memory vouchers;  
   if (available(_amount, _merchant)){
	   vouchers=employees[msg.sender].wallet;
	   totalparemp=_amount;
            for(uint vindex=0; vindex<vouchers.length; vindex++){
                if (vouchers[vindex].valu!=0 && (vouchers[vindex].merchant== _merchant  ) && (now-vouchers[vindex].beginat)> valideperiode) {
                    if (totalparemp<=vouchers[vindex].valu){
				vouchers[vindex].valu-=totalparemp;
                        stablecoin c = stablecoin(adr);
                        c.transferFrom( account, _merchant, _amount) ;
				merchant[_merchant].total+=_amount;
				employees[msg.sender].wallet=vouchers;
				return trues;


			 }
                    else {
				 totalparemp-=vouchers[vindex].valu;
				vouchers[vindex].valu=0;
                   

			}
                    
                }
            }

    }
	     

        return false;

        
    }
    
    // functions of merchants
    
    function registermerchant(address _token, string _title) public returns (bool) {
        merchant memory mer;                            //_token is the address of the stable coin.
        mer.name=_token;
	  mer.title=_title;
        mer.valu=0;
        merchants[msg.sender]=mer;
        return true;
    }
    
    function cashvoucher() public payable returns (bool) {
         stablecoin c = stablecoin(adr);
        c.transferFrom( account, merchants[msg.sender].name, merchants[msg.sender].valu) ;
        merchants[msg.sender].total+=merchants[msg.sender].valu;
        merchants[msg.sender].valu=0;
        return true;
    }
    
    
    
}