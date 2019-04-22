pragma solidity >= 0.4.0 < 0.6.0;
import "./DataTypes.sol";
import "./Skills.sol";

contract TLog {
    
    mapping ( address => address[] ) private    _ts_cns;        //tasts's CNs
    
    mapping ( address => address[] ) private    _ts_cms;        //tasts's CMs
    
    mapping ( address => address[] ) private    _ts_sccs;       //tasks's SCCs
    
    mapping ( address => address[] ) private    _ts_admin;      //tasks's admin
    
    mapping ( address => address[] ) private    _ts_systm;      //tasks's system
    
    mapping ( address => address[] ) private    _ts_group;      //tasks's group
    
    mapping ( address => T.TStatus[] ) private  _ts_stats;      //tasks's status
    
    mapping ( address => T.TInfo[] ) private    _ts_infos;      //tasks's infos
    
    
    function CS (address t_add) private view returns(bool) { if ( _ts_stats[t_add].length != 0) { return true; } else { return false; } }
    
    function CI (address t_add) private view returns(bool) { if ( _ts_infos[t_add].length != 0) { return true; } else { return false; } }
    
    function CT (address t_add) private view returns(bool) { if ( CS(t_add) && CI(t_add) ) { return true; } else { return false; } }
    
    function CSCC (address t_add, address scc_add) private view returns(bool) {
        for (uint256 i = 0; i < _ts_sccs[t_add].length; ++i ) { if (_ts_sccs[t_add][i] == scc_add) { return true; } }
        return false;
    }
    
    function CCN (address t_add, address cn_add) private view returns(bool) {
        for (uint256 i = 0; i < _ts_cns[t_add].length; ++i ) { if (_ts_cns[t_add][i] == cn_add) { return true; } }
        return false;
    }
    
    function CCM (address t_add, address cm_add) private view returns(bool) {
        for (uint256 i = 0; i < _ts_cms[t_add].length; ++i ) { if (_ts_cms[t_add][i] == cm_add) { return true; } }
        return false;
    }
    
    function CA (address t_add, address admin_add) private view returns(bool) {
        for (uint256 i = 0; i < _ts_admin[t_add].length; ++i ) { if (_ts_admin[t_add][i] == admin_add) { return true; } }
        return false;
    }
    
    function CS (address t_add, address sys_add) private view returns(bool) {
        for (uint256 i = 0; i < _ts_systm[t_add].length; ++i ) { if (_ts_systm[t_add][i] == sys_add) { return true; } }
        return false;
    }
    
    function CG (address t_add, address group_add) private view returns(bool) {
        for (uint256 i = 0; i < _ts_group[t_add].length; ++i ) { if (_ts_group[t_add][i] == group_add) { return true; } }
        return false;
    }
    
    function DecomposeS (T.TStatus memory status) private pure returns(string memory, T.TState) { 
        return (Skills.DateToStr(status.dt.yyyy, status.dt.mm, status.dt.dd, status.dt.hh, status.dt.m, status.dt.s), status.st);
    }
    
    function DecomposeI (T.TInfo memory info) private pure returns(address, string memory, uint32, uint32, uint32) {
        return (info.owner, info.name, info.nproc, info.p_coast, info.f_coast);
    }
    
    function GetS (address t_add, uint256 i) private view returns(string memory, T.TState) { return DecomposeS(_ts_stats[t_add][i]); }
    
    function GetI (address t_add, uint256 i) private view returns(address, string memory, uint32, uint32, uint32) { return DecomposeI(_ts_infos[t_add][i]); }
    
    
    function CheckSCC (address t_add, address scc_add) public view returns(bool, string memory, bool) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->CheckSCC ): the task by address (arg1) don't exist!", false); }
        if (!CSCC(t_add, scc_add)) { return (true, "Message ( TLog->CheckSCC ): the SCC (arg2) of task by address (arg1) don't exist!", false); }
        return (true, "Message ( TLog->CheckSCC ): the SCC (arg2) of task by address (arg1) is exist!", true);
    }
    
    function CheckCN (address t_add, address cn_add) public view returns(bool, string memory, bool) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->CheckCN ): the task by address (arg1) don't exist!", false); }
        if (!CCN(t_add, cn_add)) { return (true, "Message ( TLog->CheckCN ): the CN (arg2) of task by address (arg1) don't exist!", false); }
        return (true, "Message ( TLog->CheckCN ): the CN (arg2) of task by address (arg1) is exist!", true);
    }
    
    function CheckCM (address t_add, address cm_add) public view returns(bool, string memory, bool) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->CheckCM ): the task by address (arg1) don't exist!", false); }
        if (!CCM(t_add, cm_add)) { return (true, "Message ( TLog->CheckCM ): the CM (arg2) of task by address (arg1) don't exist!", false); }
        return (true, "Message ( TLog->CheckCM ): the CM (arg2) of task by address (arg1) is exist!", true);
    }
    
    function CheckAdmin (address t_add, address admin_add) public view returns(bool, string memory, bool) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->CheckAdmin ): the task by address (arg1) don't exist!", false); }
        if (!CA(t_add, admin_add)) { return (true, "Message ( TLog->CheckAdmin ): the admin-address (arg2) of task by address (arg1) don't exist!", false); }
        return (true, "Message ( TLog->CheckAdmin ): the admin-address (arg2) of task by address (arg1) is exist!", true);
    }
    
    function CheckSystem (address t_add, address system_add) public view returns(bool, string memory, bool) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->CheckSystem ): the task by address (arg1) don't exist!", false); }
        if (!CS(t_add, system_add)) { return (true, "Message ( TLog->CheckSystem ): the system-address (arg2) of task by address (arg1) don't exist!", false); }
        return (true, "Message ( TLog->CheckSystem ): the system-address (arg2) of task by address (arg1) is exist!", true);
    }
    
    function CheckGroup (address t_add, address group_add) public view returns(bool, string memory, bool) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->CheckGroup ): the task by address (arg1) don't exist!", false); }
        if (!CG(t_add, group_add)) { return (true, "Message ( TLog->CheckGroup ): the group-address (arg2) of task by address (arg1) don't exist!", false); }
        return (true, "Message ( TLog->CheckGroup ): the group-address (arg2) of task by address (arg1) is exist!", true);
    }
    
    function Check (address t_add) public view returns(bool, string memory, bool) {
        if (!CS(t_add) && !CI(t_add)) { return (true, "Message ( TLog->Check ): the task by address (arg1) don't exist!", false); }
        if (!CS(t_add)) { return (false, "Error ( TLog->Check ): the task's infos by address (arg1) is exist but task's status not!", false); }
        if (!CI(t_add)) { return (false, "Error ( TLog->Check ): the task's status by address (arg1) is exist but task's infos not!", false); }
        return (true, "Message ( TLog->Check ): the task by address (arg1) is exist!", true);
    }
    
    
    function AddCM (address t_add, address cm_add) public returns(bool, string memory) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->AddCM ): task by address (arg1) don't exist!"); }
        _ts_cms[t_add].push(cm_add);
        return (true, "Message ( TLog->AddCM ): succsessfulli added!");
    }
    
    function AddCN (address t_add, address cn_add) public returns(bool, string memory) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->AddCN ): task by address (arg1) don't exist!"); }
        _ts_cns[t_add].push(cn_add);
        return (true, "Message ( TLog->AddCN ): succsessfulli added!");
    }
    
    function AddSCC (address t_add, address scc_add) public returns(bool, string memory) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->AddCN ): task address (arg1) don't exist!"); }
        _ts_sccs[t_add].push(scc_add);
        return (true, "Message ( TLog->AddCN ): succsessfulli added!");
    }
    
    function AddAdmin (address t_add, address admin_add) public returns(bool, string memory) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->AddSCC ): task by address (arg1) don't exist!"); }
        _ts_admin[t_add].push(admin_add);
        return (true, "Message ( TLog->AddSCC ): succsessfulli added!");
    }
    
    function AddSystem (address t_add, address system_add) public returns(bool, string memory) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->AddSystem ): task by address (arg1) don't exist!"); }
        _ts_systm[t_add].push(system_add);
        return (true, "Message ( TLog->AddSystem ): succsessfulli added!");
    }
    
    function AddGroup (address t_add, address group_add) public returns(bool, string memory) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->AddGroup ): task by address (arg1) don't exist!"); }
        _ts_group[t_add].push(group_add);
        return (true, "Message ( TLog->AddGroup ): succsessfulli added!");
    }
    
    function AddStatus (address t_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, T.TState status) public returns(bool, string memory) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->AddStatus ): task by address (arg1) don't exist!"); }
        _ts_stats[t_add].push( T.TStatus( DT.DateTime(yyyy, mm, dd, hh, m, s), status ) );
        return (true, "Message ( TLog->AddStatus ): succsessfulli added!");
    }
    
    function AddInfo (address t_add, string memory name, uint32 numperproc, uint32 p_coast, uint32 f_coast) public returns(bool, string memory) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->AddInfo ): task by address (arg1) don't exist!"); }
        _ts_infos[t_add].push( T.TInfo(t_add, name, numperproc, p_coast, f_coast) );
        return (true, "Message ( TLog->AddInfo ): succsessfulli added!");
    }
    
    function AddTask (address t_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, string memory name, uint32 numperproc, uint32 p_coast, uint32 f_coast) public returns(bool, string memory) {
        if (CT(t_add)) { return (false, "Warning ( TLog->AddTask ): task by address (arg1) is exist in current time!"); }
        AddInfo(t_add, name, numperproc, p_coast, f_coast);
        AddStatus(t_add, yyyy, mm, dd, hh, m, s, T.TState.initial);
        return (true, "Message ( TLog->AddTask ): succsessfulli added!");
    }
    
    
    function GetCM (address t_add, uint256 i) public view returns(bool, string memory, address) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->GetCM ): task by address (arg1) is exist in current time!", address(0)); }
        if (i >= _ts_cms[t_add].length) return (false, "Error ( TLog-> GetCM ): out of range i (arg2)!", address(0));
        return (true, "Message ( TLog->GetCM ): succsessfulli geted!", _ts_cms[t_add][i]);
    }
    
    function GetCN (address t_add, uint256 i) public view returns(bool, string memory, address) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->GetCN ): task by address (arg1) is exist in current time!", address(0)); }
        if (i >= _ts_cns[t_add].length) return (false, "Error ( TLog-> GetCN ): out of range i (arg2)!", address(0));
        return (true, "Message ( TLog->GetCN ): succsessfulli geted!", _ts_cns[t_add][i]);
    }
    
    function GetSCC (address t_add, uint256 i) public view returns(bool, string memory, address) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->GetSCC ): task by address (arg1) is exist in current time!", address(0)); }
        if (i >= _ts_sccs[t_add].length) return (false, "Error ( TLog-> GetSCC ): out of range i (arg2)!", address(0));
        return (true, "Message ( TLog->GetSCC ): succsessfulli geted!", _ts_sccs[t_add][i]);
    }
    
    function GetSystem (address t_add, uint256 i) public view returns(bool, string memory, address) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->GetSystem ): task by address (arg1) is exist in current time!", address(0)); }
        if (i >= _ts_systm[t_add].length) return (false, "Error ( TLog-> GetSystem ): out of range i (arg2)!", address(0));
        return (true, "Message ( TLog->GetSystem ): succsessfulli geted!", _ts_systm[t_add][i]);
    }
    
    function GetAdmin (address t_add, uint256 i) public view returns(bool, string memory, address) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->GetAdmin ): task by address (arg1) is exist in current time!", address(0)); }
        if (i >= _ts_admin[t_add].length) return (false, "Error ( TLog-> GetAdmin ): out of range i (arg2)!", address(0));
        return (true, "Message ( TLog->GetAdmin ): succsessfulli geted!", _ts_admin[t_add][i]);
    }
    
    function GetGroup (address t_add, uint256 i) public view returns(bool, string memory, address) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->GetGroup ): task by address (arg1) is exist in current time!", address(0)); }
        if (i >= _ts_group[t_add].length) return (false, "Error ( TLog-> GetGroup ): out of range i (arg2)!", address(0));
        return (true, "Message ( TLog->GetGroup ): succsessfulli geted!", _ts_group[t_add][i]);
    }
    
    function GetStatus (address t_add, uint256 i) public view returns(bool, string memory, string memory, T.TState) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->GetStatus ): task by address (arg1) is exist in current time!", '', T.TState.not_info); }
        if (i >= _ts_stats[t_add].length) return (false, "Error ( TLog-> GetStatus ): out of range i (arg2)!", '', T.TState.not_info);
        (string memory data, T.TState status) = GetS(t_add, i);
        return (true, "Message ( TLog->GetStatus ): succsessfulli geted!", data, status);
    }
    
    function GetInfos (address t_add, uint256 i) public view returns(bool, string memory, address, string memory, uint32, uint32, uint32) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->GetInfos ): task by address (arg1) is exist in current time!", address(0), '', 0, 0, 0); }
        if (i >= _ts_stats[t_add].length) return (false, "Error ( TLog-> GetInfos ): out of range i (arg2)!", address(0), '', 0, 0, 0);
        (address owner, string memory name, uint32 proccount, uint32 p_coast, uint32 f_coast) = GetI(t_add, i);
        return (true, "Message ( TLog->GetInfos ): succsessfulli geted!", owner, name, proccount, p_coast, f_coast);
    }
    
    
    function GetLastStatus (address t_add) public view returns(bool, string memory, string memory, T.TState) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->GetStatus ): task by address (arg1) is exist in current time!", '', T.TState.not_info); }
        (string memory data, T.TState status) = GetS(t_add, _ts_stats[t_add].length - 1);
        return (true, "Message ( TLog->GetStatus ): succsessfulli geted!", data, status);
    }
    
    function GetLastInfos (address t_add) public view returns(bool, string memory, address, string memory, uint32, uint32, uint32) {
        if (!CT(t_add)) { return (false, "Warning ( TLog->GetInfos ): task by address (arg1) is exist in current time!", address(0), '', 0, 0, 0); }
        uint256 i = _ts_infos[t_add].length - 1;
        (address owner, string memory name, uint32 proccount, uint32 p_coast, uint32 f_coast) = GetI(t_add, i);
        return (true, "Message ( TLog->GetInfos ): succsessfulli geted!", owner, name, proccount, p_coast, f_coast);
    }
    
}//TLog
