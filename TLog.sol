pragma solidity >= 0.4.0 < 0.6.0;
import "./DataTypes.sol";
import "./Skills.sol";
import "./SCCLog.sol";
import "./CNLog.sol";
import "./CMLog.sol";
import "./GLog.sol";
import "./OLog.sol";
import "./ULog.sol";

contract TLog {
    
    mapping ( address => address[] ) private    _ts_cns;        //tasts's CNs
    
    mapping ( address => address[] ) private    _ts_cms;        //tasts's CMs
    
    mapping ( address => address[] ) private    _ts_sccs;       //tasks's SCCs
    
    mapping ( address => address[] ) private    _ts_admin;      //tasks's admin
    
    mapping ( address => address[] ) private    _ts_systm;      //tasks's system
    
    mapping ( address => address[] ) private    _ts_group;      //tasks's group
    
    mapping ( address => T.TStatus[] ) private  _ts_stats;      //tasks's status
    
    mapping ( address => T.TInfo[] ) private    _ts_infos;      //tasks's infos
    
    SCCLog  _scc;
    CNLog   _cn;
    CMLog   _cm;
    OLog    _org;
    ULog    _user;
    GLog    _group;
    
    
    constructor(address scc_add, address cn_add, address cm_add, address org_add, address group_add, address user_add) public {
        _scc    = SCCLog(scc_add);
        _cn     = CNLog(cn_add);
        _cm     = CMLog(cm_add);
        _org    = OLog(org_add);
        _group  = GLog(group_add);
        _user   = ULog(user_add);
    }
    
    
    function CS (address t_add) private view returns(bool) {
        if ( _ts_stats[t_add].length != 0) return true;
        else return false;
    }
    
    function CI (address t_add) private view returns(bool) {
        if ( _ts_infos[t_add].length != 0) return true;
        else return false;
    }
    
    function CT (address t_add) private view returns(bool) { 
        if ( CS(t_add) && CI(t_add) ) return true;
        else return false;
    }
    
    function CSCC (address t_add, address scc_add) private view returns(bool) {
        for (uint256 i = 0; i < _ts_sccs[t_add].length; ++i)
            if (_ts_sccs[t_add][i] == scc_add)
                return true;
        return false;
    }
    
    function CCN (address t_add, address cn_add) private view returns(bool) {
        for (uint256 i = 0; i < _ts_cns[t_add].length; ++i)
            if (_ts_cns[t_add][i] == cn_add)
                return true;
        return false;
    }
    
    function CCM (address t_add, address cm_add) private view returns(bool) {
        for (uint256 i = 0; i < _ts_cms[t_add].length; ++i)
            if (_ts_cms[t_add][i] == cm_add)
                return true;
        return false;
    }
    
    function CA (address t_add, address admin_add) private view returns(bool) {
        for (uint256 i = 0; i < _ts_admin[t_add].length; ++i) 
            if (_ts_admin[t_add][i] == admin_add)
                return true;
        return false;
    }
    
    function CS (address t_add, address sys_add) private view returns(bool) {
        for (uint256 i = 0; i < _ts_systm[t_add].length; ++i)
            if (_ts_systm[t_add][i] == sys_add)
                return true;
        return false;
    }
    
    function CG (address t_add, address group_add) private view returns(bool) {
        for (uint256 i = 0; i < _ts_group[t_add].length; ++i)
            if (_ts_group[t_add][i] == group_add)
                return true;
        return false;
    }
    
    
    function DecomposeS (T.TStatus memory status) private pure returns(string memory, T.TState) { 
        return (Skills.DateToStr(status.dt.yyyy, status.dt.mm, status.dt.dd, status.dt.hh, status.dt.m, status.dt.s), status.st);
    }
    
    function DecomposeI (T.TInfo memory info) private pure returns(address, string memory, uint32, uint32, uint32) {
        return (info.owner, info.name, info.nproc, info.p_coast, info.f_coast);
    }
    
    function GetS (address t_add, uint256 i) private view returns(string memory, T.TState) {
        return DecomposeS(_ts_stats[t_add][i]);
    }
    
    function GetI (address t_add, uint256 i) private view returns(address, string memory, uint32, uint32, uint32) {
        return DecomposeI(_ts_infos[t_add][i]);
    }
    
    
    function Check (address t_add) public view returns(bool) {
        if(CS(t_add) && CI(t_add))
            return true;
        return false;
    }
    
    function CheckSCC (address t_add, address scc_add) public view returns(bool) {
        require(Check(t_add), "Warning ( TLog->CheckSCC ): the task by address (arg1) is't exist!");
        return CSCC(t_add, scc_add);
    }
    
    function CheckCN (address t_add, address cn_add) public view returns(bool) {
        require(Check(t_add), "Warning ( TLog->CheckCN ): the task by address (arg1) is't exist!");
        return CCN(t_add, cn_add);
    }
    
    function CheckCM (address t_add, address cm_add) public view returns(bool) {
        require(Check(t_add), "Warning ( TLog->CheckCM ): the task by address (arg1) is't exist!");
        return CCM(t_add, cm_add);
    }
    
    function CheckAdmin (address t_add, address admin_add) public view returns(bool) {
        require(Check(t_add), "Warning ( TLog->CheckAdmin ): the task by address (arg1) is't exist!");
        return CA(t_add, admin_add);
    }
    
    function CheckSystem (address t_add, address system_add) public view returns(bool) {
        require(Check(t_add), "Warning ( TLog->CheckSystem ): the task by address (arg1) is't exist!");
        return CS(t_add, system_add);
    }
    
    function CheckGroup (address t_add, address group_add) public view returns(bool) {
        require(Check(t_add), "Warning ( TLog->CheckGroup ): the task by address (arg1) is't exist!");
        return CG(t_add, group_add);
    }
    
    
    function AddCM (address t_add, address cm_add) public {
        require(Check(t_add), "Warning ( TLog->AddCM ): the task by address (arg1) is't exist!");
        require(_cm.Check(cm_add), "Warning ( TLog->AddCM ): the CM by address (arg2) is't exist!");
        _ts_cms[t_add].push(cm_add);
    }
    
    function AddCN (address t_add, address cn_add) public {
        require(Check(t_add), "Warning ( TLog->AddCN ): the task by address (arg1) is't exist!");
        require(_cn.Check(cn_add), "Warning ( TLog->AddCN ): the CN by address (arg2) is't exist!");
        _ts_cns[t_add].push(cn_add);
    }
    
    function AddSCC (address t_add, address scc_add) public {
        require(Check(t_add), "Warning ( TLog->AddSCC ): the task by address (arg1) is't exist!");
        require(_scc.Check(scc_add), "Warning ( TLog->AddSCC ): the SCC by address (arg2) is't exist!");
        _ts_sccs[t_add].push(scc_add);
    }
    
    function AddAdmin (address t_add, address admin_add) public {
        require(Check(t_add), "Warning ( TLog->AddAdmin ): the task by address (arg1) is't exist!");
        require(_user.Check(admin_add), "Warning ( TLog->AddAdmin ): the user by address (arg2) is't exist!");
        _ts_admin[t_add].push(admin_add);
    }
    
    function AddSystem (address t_add, address system_add) public {
        require(Check(t_add), "Warning ( TLog->AddSystem ): the task by address (arg1) is't exist!");
        require(_user.Check(system_add), "Warning ( TLog->AddSystem ): the user by address (arg2) is't exist!");
        _ts_systm[t_add].push(system_add);
    }
    
    function AddGroup (address t_add, address group_add) public {
        require(Check(t_add), "Warning ( TLog->AddGroup ): the task by address (arg1) is't exist!");
        require(_group.Check(group_add), "Warning ( TLog->AddGroup ): the group by address (arg2) is't exist!");
        _ts_group[t_add].push(group_add);
    }
    
    function AddStatus (address t_add, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, T.TState status) public {
        require(Check(t_add), "Warning ( TLog->AddStatus ): the task by address (arg1) is't exist!");
        _ts_stats[t_add].push( T.TStatus( DT.DateTime(yyyy, mm, dd, hh, m, s), status ) );
    }
    
    function AddInfo (address t_add, string memory name, uint32 numperproc, uint32 p_coast, uint32 f_coast) public {
        require(Check(t_add), "Warning ( TLog->AddInfo ): the task by address (arg1) is't exist!");
        _ts_infos[t_add].push( T.TInfo(t_add, name, numperproc, p_coast, f_coast) );
    }
    
    function AddTask (address t_add, address owner, uint8 yyyy, uint8 mm, uint8 dd, uint8 hh, uint8 m, uint8 s, string memory name, uint32 numperproc, uint32 p_coast, uint32 f_coast) public returns(bool, string memory) {
        require(!Check(t_add), "Warning ( TLog->AddTask ): the task by address (arg1) is currently exist!");
        require(_user.Check(owner), "Warning ( TLog->AddTask ): the user-owner by address (arg2) is't exist!");
        AddInfo(owner, name, numperproc, p_coast, f_coast);
        AddStatus(t_add, yyyy, mm, dd, hh, m, s, T.TState.initial);
    }
    
    
    function GetCM (address t_add, uint256 i) public view returns(address) {
        require(Check(t_add), "Warning ( TLog->GetCM ): the task by address (arg1) is't exist!");
        require(i < _ts_cms[t_add].length, "Error ( TLog-> GetCM ): out of range i (arg2)!");
        return _ts_cms[t_add][i];
    }
    
    function GetCN (address t_add, uint256 i) public view returns(address) {
        require(Check(t_add), "Warning ( TLog->GetCN ): the task by address (arg1) is't exist!");
        require(i < _ts_cns[t_add].length, "Error ( TLog-> GetCN ): out of range i (arg2)!");
        return _ts_cns[t_add][i];
    }
    
    function GetSCC (address t_add, uint256 i) public view returns(address) {
        require(Check(t_add), "Warning ( TLog->GetSCC ): the task by address (arg1) is't exist!");
        require(i < _ts_sccs[t_add].length, "Error ( TLog-> GetSCC ): out of range i (arg2)!");
        return _ts_sccs[t_add][i];
    }
    
    function GetSystem (address t_add, uint256 i) public view returns(address) {
        require(Check(t_add), "Warning ( TLog->GetSystem ): the task by address (arg1) is't exist!");
        require(i < _ts_systm[t_add].length, "Error ( TLog-> GetSystem ): out of range i (arg2)!");
        return _ts_systm[t_add][i];
    }
    
    function GetAdmin (address t_add, uint256 i) public view returns(address) {
        require(Check(t_add), "Warning ( TLog->GetAdmin ): the task by address (arg1) is't exist!");
        require(i < _ts_admin[t_add].length, "Error ( TLog-> GetAdmin ): out of range i (arg2)!");
        return _ts_admin[t_add][i];
    }
    
    function GetGroup (address t_add, uint256 i) public view returns(address) {
        require(Check(t_add), "Warning ( TLog->GetGroup ): the task by address (arg1) is't exist!");
        require(i < _ts_group[t_add].length, "Error ( TLog-> GetGroup ): out of range i (arg2)!");
        return _ts_group[t_add][i];
    }
    
    function GetStatus (address t_add, uint256 i) public view returns(string memory, T.TState) {
        require(Check(t_add), "Warning ( TLog->GetStatus ): the task by address (arg1) is't exist!");
        require(i < _ts_stats[t_add].length, "Error ( TLog-> GetStatus ): out of range i (arg2)!");
        return GetS(t_add, i);
    }
    
    function GetInfos (address t_add, uint256 i) public view returns(address, string memory, uint32, uint32, uint32) {
        require(Check(t_add), "Warning ( TLog->GetInfos ): the task by address (arg1) is't exist!");
        require(i < _ts_infos[t_add].length, "Error ( TLog-> GetInfos ): out of range i (arg2)!");
        return GetI(t_add, i);
    }
    
    
    function GetLastStatus (address t_add) public view returns(string memory, T.TState) {
        require(Check(t_add), "Warning ( TLog->GetStatus ): the task by address (arg1) is't exist!");
        return GetS(t_add, _ts_stats[t_add].length - 1);
    }
    
    function GetLastInfos (address t_add) public view returns(address, string memory, uint32, uint32, uint32) {
        require(Check(t_add), "Warning ( TLog->GetInfos ): the task by address (arg1) is't exist!");
        return GetI(t_add, _ts_infos[t_add].length - 1);
    }
    
}//TLog
