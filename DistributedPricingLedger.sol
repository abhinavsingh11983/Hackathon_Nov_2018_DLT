pragma solidity ^0.4.24;


contract WorkbenchBase {
    event WorkbenchContractCreated(string applicationName, string workflowName, address originatingAddress);
    event WorkbenchContractUpdated(string applicationName, string workflowName, string action, address originatingAddress);

    string internal ApplicationName;
    string internal WorkflowName;

    function WorkbenchBase(string applicationName, string workflowName) internal {
        ApplicationName = applicationName;
        WorkflowName = workflowName;
    }

    function ContractCreated() internal {
        WorkbenchContractCreated(ApplicationName, WorkflowName, msg.sender);
    }

    function ContractUpdated(string action) internal {
        WorkbenchContractUpdated(ApplicationName, WorkflowName, action, msg.sender);
    }
}

contract DistributedPricingLedger is WorkbenchBase('DistributedPricingLedger', 'DistributedPricingLedger'){
    
        enum StateType {Open,Close}
		StateType  public State;
		address public  Admin;
        address public  Member;
        string public product;
        string public location;
		uint public AveragePrice;
        uint[] private numberOfTransaction;
        uint[] private bidprice;
        uint[] private askprice;
    

    
    //constructor
    constructor(string _product,string _location) public
    {
        Admin = msg.sender;
        State = StateType.Open;
        product=_product;
        location=_location;
        // call ContractCreated() to create an instance of this workflow. 
		// THis will create the contract
        ContractCreated();
    }
    
 function enterbid(string _product,string _location,uint _NumberOfTransaction,uint _bidprice,uint _askprice) public{
     //

         numberOfTransaction.push( _NumberOfTransaction);
         
         bidprice.push(_bidprice) ;
         askprice.push(_askprice); 
     
         ContractUpdated('enterbid');
 }   
 
 
 function calculatePrice() public {
     uint total=0;
     for(uint y=0;y<bidprice.length;y++){
         total=total+bidprice[y];
     }
     for(uint x=0;x<askprice.length;x++){
         total=total+askprice[x];
     }
     State = StateType.Close;
     //
	 AveragePrice=(total/(2*bidprice.length));
     ContractUpdated('calculatePrice');
 }
 
 
 
}