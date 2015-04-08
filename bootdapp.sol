contract Bootdapp
{
	address _owner;

	struct StRecord
	{
		address owner;
		address dapp;
		uint blockExpire;
		uint trusted;
		address validator;
	}

	struct StValidator
	{
		uint level;
		address father;
	}


	mapping(address=>uint) public LstValidator;

	mapping(string=>StRecord) public LstReg;

	function Bootdapp()
	{
		_owner=msg.sender;		
	}

	function TransferOwnership(string name,address to)
	{
		StRecord rec=LstReg[name];

		if (msg.sender!=rec.owner)
			return;
		
		rec.owner=to;
	}

	function Renew(string name)
	{
		StRecord rec=LstReg[name];

		if (msg.sender!=rec.owner)
			return;
			
		rec.blockExpire=currentBlock+30*24*3600/12;
	}

	function Register(string name,address dapp)
	{
		StRecord rec=LstReg[name];
		
		if (rec.blockExpire>currentBlock)
			return;

		rec.owner=msg.sender;
		rec.blockExpire=currentBlock+30*24*3600/12;
		rec.trusted=0;
		rec.dapp=dapp;
	}

	function Validate(string name)
	{
		var record=LstReg[name];
		if (record.blockExpire<currentBlock)
			return;

		if ((LstValidator[msg.sender]<1) && (msg.sender!=_owner))
			return;

		record.trusted=1;
		record.father=msg.sender;
	}

	function SetValidatorLevel(address addrValidator,uint level)
	{
		if ((LstValidator[msg.sender].level<=level) && (msg.sender!=_owner))
			return;

		var validator=LstValidator[addrvalidator];

		if ((validator.level>=LstValidator[msg.sender].level) && (msg.sender!=_owner))
			return;

		if (level>=validator.level)
		{
			validator.father=msg.sender;	
		}

		validator.level=level;

	}
}
