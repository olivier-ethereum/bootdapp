contract Bootdapp
{
	address _owner;

	struct StRecord
	{
		address owner;
		address dapp;
		uint blockExpire;
		uint trusted;
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

	function Register(string name,address dapp)
	{
		if (LstReg[name].blockExpire>currentBlock)
			return;

		StRecord rec=LstReg[name];

		rec.owner=msg.sender;
		rec.blockExpire=currentBlock+30*24*3600/12;
		rec.trusted=0;
		rec.dapp=dapp;
	}

	function Validate(string name)
	{
		if (LstReg[name].blockExpire<currentBlock)
			return;

		if ((LstValidator[msg.sender]<1) && (msg.sender!=_owner))
			return;

		LstReg[name].trusted=1;
	}

	function SetValidatorLevel(address addrValidator,uint level)
	{
		if ((LstValidator[msg.sender]<=level) && (msg.sender!=_owner))
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
