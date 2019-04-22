pragma solidity >= 0.4.0 < 0.6.0;
import "./DataTypes.sol";
import "./Skills.sol";
import "./OLog.sol";
import "./GLog.sol";

contract ULog {
    
    mapping ( address => int32 ) private _users_K;      //users's pay coefficient
    
    mapping ( address => int32 ) private _users_B;      //uses's balance
    
    mapping ( address => address[] ) private _users_w;  //users's owners
     
    mapping ( address => address[] ) private _users_g;  //users's groups
    
    mapping ( address => address[] ) private _users_o;  //users's organizations
    
    mapping ( address => U.UserT[] ) private _users_t;  //users's types
    
    mapping ( address => U.UserA[] ) private _users_a;  //users's actions
    
    mapping ( address => U.UserI[] ) private _users_i;  //users's informations
    
    OLog _org;
    
    GLog _group;
    
    
    constructor(address org_add, address group_add) public {
        _org = OLog(org_add);
        _group = GLog(group_add);
    }
    
    
    function CT (address u_add) private view returns(bool) {
        if (_users_t[u_add].length != 0) return true;
        else return false;
    }
    
    function CA (address u_add) private view returns(bool) {
        if (_users_a[u_add].length != 0) return true;
        else return false;
    }
    
    function CI (address u_add) private view returns(bool) {
        if (_users_i[u_add].length != 0) return true;
        else return false;
    }
    
    
    function DecomposeT (U.UserT memory typ) private pure returns (string memory, U.UserTyps) {
        return (Skills.DateToStr(typ.dt.yyyy, typ.dt.mm, typ.dt.dd, typ.dt.hh, typ.dt.m, typ.dt.s), typ.typ);
    }
    
    function DecomposeA (U.UserA memory act) private pure returns (string memory, U.UserActs) {
        return (Skills.DateToStr(act.dt.yyyy, act.dt.mm, act.dt.dd, act.dt.hh, act.dt.m, act.dt.s), act.act);
    }
    
    function DecomposeI (U.UserI memory inf) private pure returns (string memory, string memory) {
        return (inf.login, inf.description);
    }
    
    
    function GetT (address u_add, uint256 i) private view returns (string memory, U.UserTyps) {
        return DecomposeT(_users_t[u_add][i]);
    }
    
    function GetA (address u_add, uint256 i) private view returns (string memory, U.UserActs) {
        return DecomposeA(_users_a[u_add][i]);
    }
    
    function GetI (address u_add, uint256 i) private view returns (string memory, string memory) {
        return DecomposeI(_users_i[u_add][i]);
    }
    
    
    
    function Check (address u_add) public view returns(bool) {
        if (CT(u_add) && CA(u_add) && CI(u_add)) return true;
        else return false;
    }
    
    function CheckUserOwner (address u_add, address u_add_owner) public view returns(bool) {
        require(Check(u_add), "Error ( ULog->CheckUserOwner ): user by address (arg1) is't exist!");
        for (uint256 i = 0; i < _users_w[u_add].length; ++i)
            if (u_add_owner == _users_w[u_add][i])
                return true;
        return false;
    }
    
    
    function SetKeff (address u_add, address owner_add, int32 K) public {
        require(Check(u_add), "Error ( ULog->SetKeff ): user by address (arg1) is't exist!");
        require(Check(owner_add), "Error ( ULog->SetKeff ): owner by address (arg2) is't exist!");
        require(CheckUserOwner(u_add, owner_add), "Error ( ULog->SetKeff ): owner by address (arg2) is't owner fot user (arg1)!");
        _users_K[u_add] = K;
    }
    
    function SetBalance (address u_add, address owner_add, int32 B) public {
        require(Check(u_add), "Error ( ULog->SetBalance ): user by address (arg1) is't exist!");
        require(Check(owner_add), "Error ( ULog->SetBalance ): owner by address (arg2) is't exist!");
        require(CheckUserOwner(u_add, owner_add), "Error ( ULog->SetBalance ): owner by address (arg2) is't owner fot user (arg1)!");
        _users_B[u_add] = B;
    }
    
    
    function AddOwner (address u_add, address owner_add) public {
        require(Check(u_add), "Error ( ULog->AddOwner ): user by address (arg1) is't exist!");
        require(Check(owner_add), "Error ( ULog->AddOwner ): owner by address (arg2) is't exist!");
        (,U.UserTyps donor_type) = GetT(u_add, _users_t[u_add].length - 1);
        (,U.UserTyps recep_type) = GetT(owner_add, _users_t[owner_add].length - 1);
        require(donor_type >= recep_type, "Error ( ULog-AddOwner ): can't the owner assigne becouse the type-user of recipient user-accaunt (arg2) have less privilegies!");
        _users_w[u_add].push(owner_add);
    }
    
    function AddGroup (address u_add, address g_add) public {
        require(Check(u_add), "Error ( ULog->AddGroup ): user by address (arg1) is't exist!");
        require(_group.Check(g_add), "Error ( ULog->AddGroup ): group by address (arg2) is't exist!");
        _users_g[u_add].push(g_add);
    }
    
    function AddOrg (address u_add, address o_add) public returns(bool, string memory) {
        require(Check(u_add), "Error ( ULog->AddOrg ): user by address (arg1) is't exist!");
        require(_org.Check(o_add), "Error ( ULog->AddOrg ): organizations by address (arg2) is't exist!");
        _users_o[u_add].push(o_add);
    }
    
    function AddType (address u_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, U.UserTyps typ) public {
        require(Check(u_add), "Error ( ULog->AddType ): user by address (arg1) is't exist!");
        _users_t[u_add].push( U.UserT( DT.DateTime(yyyy, mm, dd, hh, m, s), typ) );
    }
    
    function AddAction (address u_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, U.UserActs act) public {
        require(Check(u_add), "Error ( ULog->AddAction ): user by address (arg1) is't exist!");
        _users_a[u_add].push( U.UserA( DT.DateTime(yyyy, mm, dd, hh, m, s), act) );
    }
    
    function AddInfo (address u_add, string memory login, string memory description) public {
        require(Check(u_add), "Error ( ULog->AddInfo ): user by address (arg1) is't exist!");
        _users_i[u_add].push( U.UserI( login, description) );
    }
    
    function AddUser (address u_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, U.UserTyps typ, string memory login, string memory description) public {
        require(!Check(u_add), "Error ( ULog->AddUser ): user by address (arg1) is currently exist!");
        _users_t[u_add].push( U.UserT( DT.DateTime(yyyy, mm, dd, hh, m, s), typ) );
        _users_a[u_add].push( U.UserA( DT.DateTime(yyyy, mm, dd, hh, m, s), U.UserActs.creation) );
        _users_i[u_add].push( U.UserI( login, description) );
        _users_w[u_add].push( u_add );
        _users_B[u_add] = 100;
        _users_K[u_add] = 1;
    }
    
    
    function GetKeff (address u_add) public view returns(int32) {
        require(Check(u_add), "Error ( ULog->GetKeff ): user by address (arg1) is't exist!");
        return _users_K[u_add];
    }
    
    function GetBalance (address u_add) public view returns(int32) {
        require(Check(u_add), "Error ( ULog->GetBalance ): user by address (arg1) is't exist!");
        return _users_B[u_add];
    }
    
    
    function GetOwnerCount(address u_add) public view returns(uint256) {
        require(Check(u_add), "Error ( ULog->GetOwnerCount ): user by address (arg1) is't exist!");
        return _users_w[u_add].length;
    }
    
    function GetGroupCount(address u_add) public view returns(uint256) {
       require(Check(u_add), "Error ( ULog->GetGroupCount ): user by address (arg1) is't exist!");
        return _users_g[u_add].length;
    }
    
    function GetOrgCount(address u_add) public view returns(uint256) {
        require(Check(u_add), "Error ( ULog->GetOrgCount ): user by address (arg1) is't exist!");
        return _users_o[u_add].length;
    }
    
    
    function GetOwner(address u_add, uint256 i) public view returns(address) {
        require(Check(u_add), "Error ( ULog->GetOwner ): user by address (arg1) is't exist!");
        require(i < _users_w[u_add].length, "Error ( ULog->GetOwner ): out of range (arg2)!");
        return _users_w[u_add][i];
    }
    
    function GetGroup(address u_add, uint256 i) public view returns(address) {
        require(Check(u_add), "Error ( ULog->GetGroup ): user by address (arg1) is't exist!");
        require(i < _users_g[u_add].length, "Error ( ULog->GetGroup ): out of range (arg2)!");
        return _users_g[u_add][i];
    }
    
    function GetOrg(address u_add, uint256 i) public view returns(address) {
        require(Check(u_add), "Error ( ULog->GetOrg ): user by address (arg1) is't exist!");
        require(i < _users_o[u_add].length, "Error ( ULog->GetOrg ): out of range (arg2)!!");
        return _users_o[u_add][i];
    }
    
    function GetType (address u_add, uint256 i) public view returns(string memory, U.UserTyps) {
        require(Check(u_add), "Error ( ULog->GetType ): user by address (arg1) is't exist!");
        require(i < _users_t[u_add].length, "Error ( ULog->GetType ): out of range (arg2)!");
        return GetT(u_add, i);
    }
    
    function GetLastType (address u_add) public view returns(string memory, U.UserTyps) {
        require(Check(u_add), "Error ( ULog->GetLastType ): user by address (arg1) is't exist!");
        return GetT(u_add, _users_t[u_add].length - 1);
    }
    
    function GetAction (address u_add, uint256 i) public view returns(string memory, U.UserActs) {
        require(Check(u_add), "Error ( ULog->GetAction ): user by address (arg1) is't exist!");
        require(i < _users_a[u_add].length, "Error ( ULog->GetAction ): out of range (arg2)!");
        return GetA(u_add, i);
    }
    
    function GetLastAction (address u_add) public view returns(string memory, U.UserActs) {
        require(Check(u_add), "Error ( ULog->GetLastAction ): user by address (arg1) is't exist!");
        return GetA(u_add, _users_a[u_add].length - 1);
    }
    
    function GetInfo (address u_add, uint256 i) public view returns(string memory, string memory) {
        require(Check(u_add), "Error ( ULog->GetInfo ): user by address (arg1) is't exist!");
        require(i < _users_i[u_add].length, "Error ( ULog->GetInfo ): out of range (arg2)!");
        return GetI(u_add, i);
    }
    
    function GetLastInfo (address u_add) public view returns(string memory, string memory) {
        require(Check(u_add), "Error ( ULog->GetLastInfo ): user by address (arg1) is't exist!");
        return GetI(u_add, _users_i[u_add].length - 1);
    }
    
}//ULog
