pragma solidity >= 0.4.0 < 0.6.0;
import "./DataTypes.sol";
import "./Skills.sol";


contract OLog {
    
    struct OInfo {
        string org_name;
        string org_hostname;
        string org_kind;
    }
    
    mapping ( address => OInfo[] ) private _gs_infos;
    
    function DecomposeI (OInfo memory info) private pure returns(string memory, string memory, string memory) { return (info.org_name, info. org_hostname, info.org_kind); }
    
    function GetI (address g_add, uint256 i) private view returns(string memory, string memory, string memory) { return DecomposeI( _gs_infos[g_add][i] ); }
    
    function CO(address g_add) private view returns(bool) {
        if (_gs_infos[g_add].length > 0) { return true; } else { return false; }
    }
    
    function Check(address g_add) public view returns(bool, string memory, bool) {
        if (!CO(g_add)) return (true, "Warning ( OLog->Check ): group by address (arg1) don't exist!", false);
        return (true, "Message ( GLog->Check ): group by address (arg1) is exist!", true);
    }
    
    function AddInfo (address g_add, string memory name, string memory p_name, string memory p_descr) public returns(bool, string memory) {
        if (!CO(g_add)) { return (false, "Warning (OLog->AddInfo ): group by address (arg1) don't exist!"); }
        _gs_infos[g_add].push(OInfo(name, p_name, p_descr));
        return (true, "Message ( OLog->AddInfo ): successfully added!");
    }
    
    function AddOrg (address g_add, string memory name, string memory p_name, string memory p_descr) public returns(bool, string memory) {
        if (CO(g_add)) { return (false, "Warning (OLog->AddOrg ): the group by address (arg1) is currently exist!"); }
        _gs_infos[g_add].push(OInfo(name, p_name, p_descr));
        return (true, "Message ( OLog->AddOrg ): successfully added!");
    }
    
    function GetOrg (address g_add, uint256 i) public view returns(bool, string memory, string memory, string memory, string memory) {
        if (!CO(g_add)) { return (false, "Warning ( OLog->GetOrg ): group by address (arg1) don't exist!", '', '', ''); }
        if (i >= _gs_infos[g_add].length) { return (false, "Error ( OLog->GetOrg ): out of range i (arg2)!!", '', '', ''); }
        (string memory name, string memory p_name, string memory p_deskr) = GetI(g_add, i);
        return (true, "Message ( OLog->GetOrg ): successfully geted!", name, p_name, p_deskr);
    }
    
    function GetLastOrg (address g_add) public view returns(bool, string memory, string memory, string memory, string memory) {
        if (!CO(g_add)) { return (false, "Warning ( OLog->GetLastOrg ): group by address (arg1) don't exist!", '', '', ''); }
        (string memory name, string memory p_name, string memory p_deskr) = GetI(g_add, _gs_infos[g_add].length - 1);
        return (true, "Message ( OLog->GetLastOrg ): successfully geted!", name, p_name, p_deskr);
    }
    
}//OLog

