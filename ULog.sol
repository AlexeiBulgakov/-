pragma solidity >= 0.4.0 < 0.6.0;
import "./DataTypes.sol";
import "./Skills.sol";

contract ULog {
    
    mapping ( address => int32 ) private _users_K; //users's pay coefficient
    
    mapping ( address => int32 ) private _users_B; //uses's balance
    
    mapping ( address => address[] ) private _users_w; //users's owners
     
    mapping ( address => address[] ) private _users_g; //users's groups
    
    mapping ( address => address[] ) private _users_o; //users's organizations
    
    mapping ( address => U.UserT[] ) private _users_t; //users's types
    
    mapping ( address => U.UserA[] ) private _users_a; //users's actions
    
    mapping ( address => U.UserI[] ) private _users_i; //users's informations
    
    
    function CT (address u_add) private view returns(bool) { if (_users_t[u_add].length != 0) { return true; } else {return false; } }
    
    function CA (address u_add) private view returns(bool) { if (_users_a[u_add].length != 0) { return true; } else {return false; } }
    
    function CI (address u_add) private view returns(bool) { if (_users_i[u_add].length != 0) { return true; } else {return false; } }
    
    function CU (address u_add) private view returns(bool) { if (CT(u_add) && CA(u_add) && CI(u_add)) { return true; } else { return false; } }
    
    function CW (address u_add, address u_add_owner) private view returns(bool) {
        for (uint256 i = 0; i < _users_w[u_add].length; ++i) { if (u_add_owner == _users_w[u_add][i]) { return true; } }
        return false;
    }
    
    function DecomposeT (U.UserT memory typ) private pure returns (bool, string memory, U.UserTyps) {
        return (true, Skills.DateToStr(typ.dt.yyyy, typ.dt.mm, typ.dt.dd, typ.dt.hh, typ.dt.m, typ.dt.s), typ.typ);
    }
    
    function DecomposeA (U.UserA memory act) private pure returns (bool, string memory, U.UserActs) {
        return (true, Skills.DateToStr(act.dt.yyyy, act.dt.mm, act.dt.dd, act.dt.hh, act.dt.m, act.dt.s), act.act);
    }
    
    function DecomposeI (U.UserI memory inf) private pure returns (bool, string memory, string memory) {
        return (true, inf.login, inf.description);
    }
    
    function GetT (address u_add, uint256 i) private view returns (bool, string memory, U.UserTyps) {
        return DecomposeT(_users_t[u_add][i]);
    }
    
    function GetA (address u_add, uint256 i) private view returns (bool, string memory, U.UserActs) {
        return DecomposeA(_users_a[u_add][i]);
    }
    
    function GetI (address u_add, uint256 i) private view returns (bool, string memory, string memory) {
        return DecomposeI(_users_i[u_add][i]);
    }
    
    
    
    function Check (address u_add) public view returns(bool, string memory) {
        if (!CT(u_add)) { return (false, "Message ( ULog->Check ): user is't exist!"); }
        if (!CA(u_add)) { return (false, "Error ( ULog->Check ): user is exist in only types-log!"); }
        if (!CI(u_add)) { return (false, "Warning ( ULog->Check ): user is't exist in informations-log!"); }
        return (true, "Message ( ULog->Check ): user is exist in the RAN!");
    }
    
    function CheckOwner (address u_add, address u_add_owner) public view returns(bool, string memory, bool) {
        if (!CU(u_add))                 { return (false, "Warning ( ULog->CheckOwner ): user-accaunt (arg1) not exist!", false); }
        if (!CU(u_add_owner))           { return (false, "Warning ( ULog->CheckOwner ): owner-accaunt (arg2) not exist!", false); }
        if (!CW(u_add, u_add_owner))    { return (true, "Message ( ULog->CheckOwner ): is't owner for user!", false); }
        else                            { return (true, "Message ( ULog->CheckOwner ): is owner for user!", true); }
    }
    
    function SetKeff (address u_add, address u_add_owner, int32 K) public returns(bool, string memory) {
        if (!CW(u_add, u_add_owner)) { return (false, "Warning ( ULog->SetK ): can't set the K-coefficient becouse the owner (arg2) is't owner in realy for user-accaunt (arg1)!"); }
        _users_K[u_add] = K;
        return (true, "Message ( ULog->SetK ): succsessfully set!");
    }
    
    function SetBalance (address u_add, address u_add_owner, int32 B) public returns(bool, string memory) {
        if (!CW(u_add, u_add_owner)) { return (false, "Warning ( ULog->SetB ): can't set the balance becouse the owner (arg2) is't owner in realy for user-accaunt (arg1)!"); }
        _users_B[u_add] = B;
        return (true, "Message ( ULog->SetB ): succsessfully set!");
    }
    
    function AddOwner (address u_add, address u_add_owner) public returns(bool, string memory) {
        if (!CU(u_add))                 { return (false, "Warning ( ULog->AddO ): not exist the donor user-accaunt (arg1)!"); }
        if (!CU(u_add_owner))           { return (false, "Warning ( ULog->AddO ): not exist the recipient user-accaunt (arg2)!"); }
        (,,U.UserTyps donor_type) = GetT(u_add, _users_t[u_add].length - 1);
        (,,U.UserTyps recep_type) = GetT(u_add_owner, _users_t[u_add_owner].length - 1);
        if (donor_type < recep_type)    { return (false, "Warning ( ULog-AddO ): can't the owner assigne becouse the type-user of recipient user-accaunt (arg2) have less privilegies!"); }
        _users_w[u_add].push(u_add_owner);
        return (true, "Message ( ULog-AddOwner ): succsessfully added!");
    }
    
    function AddGroup (address u_add, address g_add) public returns(bool, string memory) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->AddG ): not exist the user-accaunt (arg1)!"); }
        _users_g[u_add].push(g_add);
        return (true, "Message ( ULog-AddG ): succsessfully added!");
    }
    
    function AddOrg (address u_add, address o_add) public returns(bool, string memory) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->AddO ): not exist the user-accaunt (arg1)!"); }
        _users_o[u_add].push(o_add);
        return (true, "Message ( ULog-AddO ): succsessfully added!");
    }
    
    function AddType (address u_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, U.UserTyps typ) public returns(bool, string memory) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->AddI ): not exist the user-accaunt (arg1)!"); }
        _users_t[u_add].push( U.UserT( DT.DateTime(yyyy, mm, dd, hh, m, s), typ) );
        return (true, "Message ( ULog-AddI ): succsessfully added!");
    }
    
    function AddAction (address u_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, U.UserActs act) public returns(bool, string memory) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->AddI ): not exist the user-accaunt (arg1)!"); }
        _users_a[u_add].push( U.UserA( DT.DateTime(yyyy, mm, dd, hh, m, s), act) );
        return (true, "Message ( ULog-AddI ): succsessfully added!");
    }
    
    function AddInfo (address u_add, string memory login, string memory description) public returns(bool, string memory) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->AddI ): not exist the user-accaunt (arg1)!"); }
        _users_i[u_add].push( U.UserI( login, description) );
        return (true, "Message ( ULog-AddI ): succsessfully added!");
    }
    
    function AddUser (address u_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, U.UserTyps typ, string memory login, string memory description) public returns(bool, string memory) {
        if(CU(u_add)) { return (false, "Error ( ULog->AddU ): additional user-accaunt is currently exist!"); }
        _users_t[u_add].push( U.UserT( DT.DateTime(yyyy, mm, dd, hh, m, s), typ) );
        _users_a[u_add].push( U.UserA( DT.DateTime(yyyy, mm, dd, hh, m, s), U.UserActs.creation) );
        _users_i[u_add].push( U.UserI( login, description) );
        _users_B[u_add] = 100;
        _users_K[u_add] = 1;
        return (true, "Message ( ULog->AddU ): succsessfully added!");
    }
    
    
    function GetKeff (address u_add) public view returns(bool, string memory, int32) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->GetKeff ): user-accaunt is't exist!", 0); }
        return (true, "Message ( ULog->GetKeff ): succsessfully geted!", _users_K[u_add]);
    }
    
    function GetBalance (address u_add) public view returns(bool, string memory, int32) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->GetBalance ): user-accaunt is't exist!", 0); }
        return (true, "Message ( ULog->GetBalance ): succsessfully geted!", _users_B[u_add]);
    }
    
    function GetOwnerCount(address u_add) public view returns(bool, string memory, uint256) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->GetOwnerCount ): user-accaunt is't exist!", 0); }
        return (true, "Message ( ULog->GetOwnerCount ): succsessfully geted!", _users_w[u_add].length);
    }
    
    function GetOwner(address u_add, uint256 i) public view returns(bool, string memory, address) {
        if (!CU(u_add))                     { return (false, "Warning ( ULog->GetOwner ): user-accaunt is't exist!", address(0)); }
        if (i >= _users_w[u_add].length)    { return (false, "Warning ( ULog->GetOwner ): out of range by i (arg2)!", address(0)); }
        return (true, "Message ( ULog->GetOwner ): succsessfully geted!", _users_w[u_add][i]);
    }
    
    function GetGroupCount(address u_add) public view returns(bool, string memory, uint256) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->GetGroupCount ): user-accaunt is't exist!", 0); }
        return (true, "Message ( ULog->GetGroupCount ): succsessfully geted!", _users_g[u_add].length);
    }
    
    function GetGroup(address u_add, uint256 i) public view returns(bool, string memory, address) {
        if (!CU(u_add))                     { return (false, "Warning ( ULog->GetGroup ): user-accaunt is't exist!", address(0)); }
        if (i >= _users_w[u_add].length)    { return (false, "Warning ( ULog->GetGroup ): out of range by i (arg2)!", address(0)); }
        return (true, "Message ( ULog->GetGroup ): succsessfully geted!", _users_g[u_add][i]);
    }
    
    function GetOrgCount(address u_add) public view returns(bool, string memory, uint256) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->GetOrgCount ): user-accaunt is't exist!", 0); }
        return (true, "Message ( ULog->GetOrgCount ): succsessfully geted!", _users_o[u_add].length);
    }
    
    function GetOrg(address u_add, uint256 i) public view returns(bool, string memory, address) {
        if (!CU(u_add))                     { return (false, "Warning ( ULog->GetOrg ): user-accaunt is't exist!", address(0)); }
        if (i >= _users_w[u_add].length)    { return (false, "Warning ( ULog->GetOrg ): out of range by i (arg2)!", address(0)); }
        return (true, "Message ( ULog->GetOrg ): succsessfully geted!", _users_o[u_add][i]);
    }
    
    function GetType (address u_add, uint256 i) public view returns(bool, string memory, string memory, U.UserTyps) {
        if (!CU(u_add))                     { return (false, "Warning ( ULog->GetType ): user-accaunt is't exist!", '', U.UserTyps.not_info); }
        if (i >= _users_t[u_add].length)    { return (false, "Warning ( ULog->GetType ): out of range by i (arg2)!", '', U.UserTyps.not_info); }
        (,string memory data, U.UserTyps typ) = GetT(u_add, i);
        return (true, "Message ( ULog->GetType ): succsessfully geted!", data, typ);
    }
    
    function GetLastType (address u_add) public view returns(bool, string memory, string memory, U.UserTyps) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->GetType ): user-accaunt is't exist!", '', U.UserTyps.not_info); }
        (,string memory data, U.UserTyps typ) = GetT(u_add, _users_t[u_add].length - 1);
        return (true, "Message ( ULog->GetType ): succsessfully geted!", data, typ);
    }
    
    function GetAction (address u_add, uint256 i) public view returns(bool, string memory, string memory, U.UserActs) {
        if (!CU(u_add))                     { return (false, "Warning ( ULog->GetAction ): user-accaunt is't exist!", '', U.UserActs.not_info); }
        if (i >= _users_a[u_add].length)    { return (false, "Warning ( ULog->GetAction ): out of range by i (arg2)!", '', U.UserActs.not_info); }
        (,string memory data, U.UserActs act) = GetA(u_add, i);
        return (true, "Message ( ULog->GetAction ): succsessfully geted!", data, act);
    }
    
    function GetLastAction (address u_add) public view returns(bool, string memory, string memory, U.UserActs) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->GetAction ): user-accaunt is't exist!", '', U.UserActs.not_info); }
        (,string memory data, U.UserActs act) = GetA(u_add, _users_a[u_add].length - 1);
        return (true, "Message ( ULog->GetAction ): succsessfully geted!", data, act);
    }
    
    function GetInfo (address u_add, uint256 i) public view returns(bool, string memory, string memory, string memory) {
        if (!CU(u_add))                     { return (false, "Warning ( ULog->GetInfo ): user-accaunt is't exist!", '', ''); }
        if (i >= _users_i[u_add].length)    { return (false, "Warning ( ULog->GetInfo ): out of range by i (arg2)!", '', ''); }
        (,string memory login, string memory description) = GetI(u_add, i);
        return (true, "Message ( ULog->GetInfo ): succsessfully geted!", login, description);
    }
    
    function GetLastInfo (address u_add) public view returns(bool, string memory, string memory, string memory) {
        if (!CU(u_add)) { return (false, "Warning ( ULog->GetInfo ): user-accaunt is't exist!", '', ''); }
        (,string memory login, string memory description) = GetI(u_add, _users_i[u_add].length - 1);
        return (true, "Message ( ULog->GetInfo ): succsessfully geted!", login, description);
    }
    
}//ULog
