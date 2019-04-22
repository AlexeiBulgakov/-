pragma solidity >= 0.4.0 < 0.6.0;
import "./DataTypes.sol";
import "./Skills.sol";
import "./ULog.sol";


contract GLog {
    
    mapping ( address => address[] ) private _gs_users;
    
    mapping ( address => G.GInfo[] ) private _gs_infos;
    
    ULog _user;
    
    
    constructor(address user) public { _user = ULog(user); }
    
    
    function DecomposeI (G.GInfo memory info) private pure returns(string memory, string memory, string memory, string memory) {
        return (Skills.DateToStr(info.dt.yyyy, info.dt.mm, info.dt.dd, info.dt.hh, info.dt.m, info.dt.s), info.group_name, info.project_name, info.project_description);
    }
    
    
    function GetI (address o_add, uint256 i) private view returns(string memory, string memory, string memory, string memory) {
        return DecomposeI( _gs_infos[o_add][i] );
    }
    
    
    function Check(address o_add) public view returns(bool) {
        if (_gs_infos[o_add].length > 0) return true;
        else return false;
    }
    
    
    function AddUser(address o_add, address user_add) public {
        require(!Check(o_add), "Error ( GLog->AddUser ): group by address (arg1) is't exist!");
        require(!_user.Check(user_add), "Error ( GLog->AddUser ): user by address (arg2) is't exist!");
        _gs_users[o_add].push(user_add);
    }
    
    function AddInfo (address o_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, string memory name, string memory project_name, string memory project_descr) public {
        require(!Check(o_add), "Error ( GLog->AddInfo ): group by address (arg1) is't exist!");
        _gs_infos[o_add].push(G.GInfo(DT.DateTime(yyyy, mm, dd, hh, m, s), name, project_name, project_descr));
    }
    
    function AddGroup (address o_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, string memory name, string memory project_name, string memory project_descr) public {
        require(Check(o_add), "Error ( GLog->AddGroup ): group by address (arg1) is currently exist!");
         _gs_infos[o_add].push(G.GInfo(DT.DateTime(yyyy, mm, dd, hh, m, s), name, project_name, project_descr));
    }
    
    
    function GetUserInOrg(address o_add, uint256 i) public view returns(address) {
        require(Check(o_add), "Error ( GLog->GetUsersIbOrg ): group by address (arg1) is't exist!");
        require( i < _gs_infos[o_add].length, "Error ( GLog->GetUsersIbOrg ): out of range (arg2)!");
        return  _gs_users[o_add][i];
    }
    
     function GetLastUserInGroup(address o_add) public view returns(address) {
        require(Check(o_add), "Error ( GLog->GetLastUserInGroup ): group by address (arg1) is't exist!");
        return  _gs_users[o_add][_gs_infos[o_add].length - 1];
    }
    
    function GetGroup (address o_add, uint256 i) public view returns(string memory, string memory, string memory, string memory) {
        require(Check(o_add), "Error ( GLog->GetGroup ): group by address (arg1) is't exist!");
        require( i < _gs_users[o_add].length, "Error ( GLog->GetGroup ): out of range (arg2)!");
        return GetI(o_add, i);
    }
    
    function GetLastGroup (address o_add) public view returns(string memory, string memory, string memory, string memory) {
        require(Check(o_add), "Error ( GLog->GetLastGroup ): group by address (arg1) is't exist!");
        return GetI(o_add, _gs_infos[o_add].length - 1);
    }
    
}//GLog

