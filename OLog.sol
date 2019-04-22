pragma solidity >= 0.4.0 < 0.6.0;
import "./DataTypes.sol";
import "./Skills.sol";
import "./ULog.sol";


contract OLog {
    
    mapping ( address => address[] ) private _os_users;
    
    mapping ( address => O.OInfo[] ) private _go_infos;
    
    ULog _user;
    
    
    constructor(address user) public { _user = ULog(user); }
    
    
    function DecomposeI (O.OInfo memory info) private pure returns(string memory, string memory, string memory, string memory) {
        return (Skills.DateToStr(info.dt.yyyy, info.dt.mm, info.dt.dd, info.dt.hh, info.dt.m, info.dt.s), info.org_name, info.org_hostname, info.org_kind);
    }
    
    
    function GetI (address o_add, uint256 i) private view returns(string memory, string memory, string memory, string memory) {
        return DecomposeI( _go_infos[o_add][i] );
    }
    
    
    function Check(address o_add) public view returns(bool) {
        if (_go_infos[o_add].length > 0) return true;
        else return false;
    }
    
    
    function AddUser(address o_add, address user_add) public {
        require(!Check(o_add), "Error ( OLog->AddUser ): organization by address (arg1) is't exist!");
        require(!_user.Check(user_add), "Error ( OLog->AddUser ): user by address (arg2) is't exist!");
        _os_users[o_add].push(user_add);
    }
    
    function AddInfo (address o_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, string memory name, string memory project_name, string memory project_descr) public {
        require(!Check(o_add), "Error ( OLog->AddInfo ): organization by address (arg1) is't exist!");
        _go_infos[o_add].push(O.OInfo(DT.DateTime(yyyy, mm, dd, hh, m, s), name, project_name, project_descr));
    }
    
    function AddOrg (address o_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, string memory name, string memory project_name, string memory project_descr) public {
        require(Check(o_add), "Error ( OLog->AddOrg ): organization by address (arg1) is currently exist!");
         _go_infos[o_add].push(O.OInfo(DT.DateTime(yyyy, mm, dd, hh, m, s), name, project_name, project_descr));
    }
    
    function GetOrg (address o_add, uint256 i) public view returns(string memory, string memory, string memory, string memory) {
        require(Check(o_add), "Error ( OLog->GetOrg ): organization by address (arg1) is't exist!");
        require( i < _os_users[o_add].length, "Error ( OLog->GetOrg ): out of range (arg2)!");
        return GetI(o_add, i);
    }
    
    function GetLastOrg (address o_add) public view returns(string memory, string memory, string memory, string memory) {
        require(Check(o_add), "Error ( OLog->GetOrg ): organization by address (arg1) is't exist!");
        return GetI(o_add, _go_infos[o_add].length - 1);
    }
    
    function GetLastUserInOrg(address o_add) public view returns(address) {
        require(Check(o_add), "Error ( OLog->GetUsersIbOrg ): organization by address (arg1) is't exist!");
        return  _os_users[o_add][_go_infos[o_add].length - 1];
    }
    
    function GetUserInOrg(address o_add, uint256 i) public view returns(address) {
        require(Check(o_add), "Error ( OLog->GetUsersIbOrg ): organization by address (arg1) is't exist!");
        require( i < _go_infos[o_add].length, "Error ( OLog->GetUsersIbOrg ): out of range (arg2)!");
        return  _os_users[o_add][i];
    }
    
}//OLog

