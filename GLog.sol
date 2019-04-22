pragma solidity >= 0.4.0 < 0.6.0;
import "./DataTypes.sol";
import "./Skills.sol";


contract GLog {
    
    struct GInfo {
        string group_name;
        string project_name;
        string project_description;
    }
    
    mapping ( address => GInfo[] ) private _gs_infos;
    
    function DecomposeI (GInfo memory info) private pure returns(string memory, string memory, string memory) { return (info.group_name, info. project_name, info.project_description); }
    
    function GetI (address g_add, uint256 i) private view returns(string memory, string memory, string memory) { return DecomposeI( _gs_infos[g_add][i] ); }
    
    function CG(address g_add) private view returns(bool) {
        if (_gs_infos[g_add].length > 0) { return true; } else { return false; }
    }
    
    function Check(address g_add) public view returns(bool, string memory, bool) {
        if (!CG(g_add)) return (true, "Warning ( GLog->Check ): group by address (arg1) don't exist!", false);
        return (true, "Message ( GLog->Check ): group by address (arg1) is exist!", true);
    }
    
    function AddInfo (address g_add, string memory name, string memory p_name, string memory p_descr) public returns(bool, string memory) {
        if (!CG(g_add)) { return (false, "Warning ( GLog->AddInfo ): group by address (arg1) don't exist!"); }
        _gs_infos[g_add].push(GInfo(name, p_name, p_descr));
        return (true, "Message ( GLog->AddInfo ): successfully added!");
    }
    
    function AddGroup (address g_add, string memory name, string memory p_name, string memory p_descr) public returns(bool, string memory) {
        if (CG(g_add)) { return (false, "Warning (GLog->AddGroup ): the group by address (arg1) is currently exist!"); }
        _gs_infos[g_add].push(GInfo(name, p_name, p_descr));
        return (true, "Message ( GLog->AddGroup ): successfully added!");
    }
    
    function GetGroup (address g_add, uint256 i) public view returns(bool, string memory, string memory, string memory, string memory) {
        if (!CG(g_add)) { return (false, "Warning ( GLog->GetGroup ): group by address (arg1) don't exist!", '', '', ''); }
        if (i >= _gs_infos[g_add].length) { return (false, "Error ( GLog->GetGroup ): out of range i (arg2)!!", '', '', ''); }
        (string memory name, string memory p_name, string memory p_deskr) = GetI(g_add, i);
        return (true, "Message ( GLog->GetGroup ): successfully geted!", name, p_name, p_deskr);
    }
    
    function GetLastGroup (address g_add) public view returns(bool, string memory, string memory, string memory, string memory) {
        if (!CG(g_add)) { return (false, "Warning ( GLog->GetLastGroup ): group by address (arg1) don't exist!", '', '', ''); }
        (string memory name, string memory p_name, string memory p_deskr) = GetI(g_add, _gs_infos[g_add].length - 1);
        return (true, "Message ( GLog->GetLastGroup ): successfully geted!", name, p_name, p_deskr);
    }
    
}//GLog

