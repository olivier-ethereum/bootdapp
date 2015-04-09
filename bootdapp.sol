// By Olivier, for ethereum
// If you don't understand a bit, and get lost here by random events :
// Language is Solidity, paradigm is Ethereum, and you have to take a look at what it is, because it is the next revolution

contract Bootdapp
{
	struct StRecord
	{
		address owner;
		address dapp;
		uint blockExpire;
		bool trusted;
		address validator;
		bytes32 name;
	}

	struct StValidator
	{
		uint level;
		address father;
	}


	mapping(address=>StValidator) public LstValidator;

	mapping(bytes32=>StRecord) public LstReg;

	function Bootdapp()
	{
		LstValidator[msg.sender].level=100;
	}

	function Register(bytes32 name,address dapp)
	{
		var rec=LstReg[name];
		
		if (rec!=StRecord(0))
			return;

		if (rec.blockExpire>block.number)
			return;

		rec.owner=msg.sender;
		rec.blockExpire=block.number+30*24*3600/12;
		rec.trusted=0;
		rec.dapp=dapp;
		rec.name=name;
	}

	function Renew(bytes32 name)
	{
		StRecord rec=LstReg[name];

		if (msg.sender!=rec.owner)
			return;
			
		rec.blockExpire=block.number+30*24*3600/12;
	}

	function TransferOwnership(bytes32 name,address to)
	{
		StRecord rec=LstReg[name];
		if (rec==StRecord(0))
			return;

		if (msg.sender!=rec.owner)
			return;
		
		rec.owner=to;
	}

	function Validate(bytes32 name)
	{
		var validatorFrom=LstValidator[msg.sender];

		if (validatorFrom==StValidator(0))
			return;

		if (validatorFrom.level<1)
			return;

		var record=LstReg[name];
		if (record.blockExpire<block.number)
			return;

		record.trusted=1;
		record.validator=msg.sender;
	}

	function SetValidatorLevel(address addrValidator,uint level)
	{
		var validatorFrom=LstValidator[msg.sender];

		if (validatorFrom==StValidator(0))
			return;

		if (validatorFrom.level<=level) 
			return;

		var validatorTo=LstValidator[addrValidator];

		if (validatorTo.level>=validatorFrom.level)
			return;

		if (level>=validatorTo.level)
		{
			validatorTo.father=msg.sender;	
		}

		validatorTo.level=level;
	}
}
